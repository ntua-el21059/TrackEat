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
      // Set receiver based on who is logged in
      if (currentUser.email == 'vchristou32@gmail.com') {
        receiverId = 'admin@admin.com';
      } else if (currentUser.email == 'admin@admin.com') {
        receiverId = 'vchristou32@gmail.com';
      }
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

    final List<String> ids = [currentUser.email!, receiverId!]..sort();
    final String chatRoomId = ids.join('_');

    return _firestore
        .collection('chats')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .distinct()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => Message.fromMap(doc.data()))
              .toList();
        });
  }

  // Mark messages as read
  Future<void> markMessagesAsRead() async {
    final currentUser = _auth.currentUser;
    if (currentUser == null || receiverId == null) return;

    final List<String> ids = [currentUser.email!, receiverId!]..sort();
    final String chatRoomId = ids.join('_');

    final unreadMessages = await _firestore
        .collection('chats')
        .doc(chatRoomId)
        .collection('messages')
        .where('receiverId', isEqualTo: currentUser.email!)
        .where('isRead', isEqualTo: false)
        .get();

    final batch = _firestore.batch();
    for (var doc in unreadMessages.docs) {
      batch.update(doc.reference, {'isRead': true});
    }
    await batch.commit();
  }

  @override
  void dispose() {
    messageoneController.dispose();
    _userSubscription?.cancel();
    super.dispose();
  }
}