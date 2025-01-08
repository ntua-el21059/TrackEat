import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/message_model.dart';
import 'dart:async';

/// A provider class for the SocialProfileMessageFromProfileScreen.
///
/// This provider manages the state of the SocialProfileMessageFromProfileScreen, 
/// including the current [socialProfileMessageFromProfileModelObj].
class SocialProfileMessageFromProfileProvider extends ChangeNotifier {
  final TextEditingController messageoneController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  String? receiverId;
  String recipientName = '';
  String recipientSurname = '';
  String recipientUsername = '';
  List<Message> messages = [];
  bool isLoading = false;
  StreamSubscription<DocumentSnapshot>? _userSubscription;

  // Initialize provider and set receiver based on current user
  SocialProfileMessageFromProfileProvider() {
    _initializeReceiver();
  }

  void setReceiverInfo({
    String? receiverId,
    String? receiverName,
    String? receiverUsername,
  }) {
    if (receiverId != null) {
      this.receiverId = receiverId;
    }
    if (receiverName != null) {
      final names = receiverName.split(' ');
      if (names.length > 1) {
        recipientName = names[0];
        recipientSurname = names.sublist(1).join(' ');
      } else {
        recipientName = receiverName;
      }
    }
    if (receiverUsername != null) {
      recipientUsername = receiverUsername;
    }
    _listenToRecipientInfo();
    notifyListeners();
  }

  void _initializeReceiver() {
    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      _listenToRecipientInfo();
      notifyListeners();
    }
  }

  void _listenToRecipientInfo() {
    if (receiverId == null) return;

    // Cancel any existing subscription
    _userSubscription?.cancel();

    // Start listening to real-time updates
    _userSubscription = _firestore
        .collection('users')
        .doc(receiverId)
        .snapshots()
        .listen((doc) {
      if (doc.exists) {
        final data = doc.data();
        final newName = data?['firstName'] ?? '';
        final newSurname = data?['lastName'] ?? '';
        final newUsername = data?['username'] ?? '';
        
        bool shouldNotify = false;
        
        // Only update if values are different and not empty
        if (newName.isNotEmpty && recipientName != newName) {
          recipientName = newName;
          shouldNotify = true;
        }
        if (newSurname.isNotEmpty && recipientSurname != newSurname) {
          recipientSurname = newSurname;
          shouldNotify = true;
        }
        if (newUsername.isNotEmpty && recipientUsername != newUsername) {
          recipientUsername = newUsername;
          shouldNotify = true;
        }
        
        if (shouldNotify) {
          notifyListeners();
        }
      }
    }, onError: (e) {
      print('Error listening to recipient info: $e');
    });
  }

  // Send a message
  Future<void> sendMessage(String content) async {
    if (content.trim().isEmpty || receiverId == null) return;

    final currentUser = _auth.currentUser;
    if (currentUser == null) return;

    try {
      final message = Message(
        senderId: currentUser.email!,
        receiverId: receiverId!,
        content: content.trim(),
        timestamp: Timestamp.now(),
      );

      // Create a unique chat room ID by sorting and combining user IDs
      final List<String> ids = [currentUser.email!, receiverId!]..sort();
      final String chatRoomId = ids.join('_');

      await _firestore
          .collection('chats')
          .doc(chatRoomId)
          .collection('messages')
          .add(message.toMap());

      // Update chat room info
      await _firestore.collection('chats').doc(chatRoomId).set({
        'lastMessage': content,
        'lastMessageTime': Timestamp.now(),
        'participants': [currentUser.email!, receiverId!],
        'unreadCount': {
          receiverId!: FieldValue.increment(1),
        }
      }, SetOptions(merge: true));

      // Get sender's username from their user document
      final senderDoc = await _firestore.collection('users').doc(currentUser.email!).get();
      if (senderDoc.exists) {
        final senderUsername = senderDoc.data()?['username'];
        if (senderUsername != null) {
          // Create notification for the recipient
          await _firestore
              .collection('users')
              .doc(receiverId)
              .collection('notifications')
              .add({
                'isRead': false,
                'message': '@$senderUsername sent you a message',
                'timestamp': Timestamp.now(),
                'type': 'message',
                'senderId': currentUser.email
              });
        }
      }

      // Clear the input field
      messageoneController.clear();
      notifyListeners();
    } catch (e) {
      print('Error sending message: $e');
    }
  }

  // Stream of messages for the current chat
  Stream<List<Message>> getMessages() {
    final currentUser = _auth.currentUser;
    if (currentUser == null || receiverId == null) return Stream.value([]);

    // Create a unique chat room ID by sorting and combining user IDs
    final List<String> ids = [currentUser.email!, receiverId!]..sort();
    final String chatRoomId = ids.join('_');

    // Mark messages as read when they are viewed
    _markMessagesAsRead(chatRoomId, currentUser.email!);

    return _firestore
        .collection('chats')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data();
            return Message.fromMap({...data, 'id': doc.id});
          }).toList();
        });
  }

  // Mark messages as read
  Future<void> _markMessagesAsRead(String chatRoomId, String currentUserId) async {
    try {
      // Get unread messages sent to current user
      final unreadMessages = await _firestore
          .collection('chats')
          .doc(chatRoomId)
          .collection('messages')
          .where('receiverId', isEqualTo: currentUserId)
          .where('isRead', isEqualTo: false)
          .get();

      // Mark each message as read
      final batch = _firestore.batch();
      for (var doc in unreadMessages.docs) {
        batch.update(doc.reference, {'isRead': true});
      }
      await batch.commit();

      // Reset unread count for current user in chat room
      await _firestore.collection('chats').doc(chatRoomId).set({
        'unreadCount': {
          currentUserId: 0,
        }
      }, SetOptions(merge: true));
    } catch (e) {
      print('Error marking messages as read: $e');
    }
  }

  @override
  void dispose() {
    messageoneController.dispose();
    _userSubscription?.cancel();
    super.dispose();
  }
}