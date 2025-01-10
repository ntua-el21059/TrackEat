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
  List<Message> _cachedMessages = [];
  bool isLoading = false;
  StreamSubscription<DocumentSnapshot>? _userSubscription;
  StreamSubscription<QuerySnapshot>? _messageSubscription;
  String? _currentChatRoomId;

  // Getter for cached messages
  List<Message> get messages => _cachedMessages;

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
      _setupMessageListener();
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

  void _setupMessageListener() {
    final currentUser = _auth.currentUser;
    if (currentUser == null || receiverId == null) return;

    // Cancel existing subscription if any
    _messageSubscription?.cancel();

    // Create chat room ID
    final List<String> ids = [currentUser.email!, receiverId!]..sort();
    _currentChatRoomId = ids.join('_');

    // Listen only to new messages
    _messageSubscription = _firestore
        .collection('chats')
        .doc(_currentChatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .listen((snapshot) {
          if (snapshot.docChanges.isNotEmpty) {
            // Process only changes
            for (var change in snapshot.docChanges) {
              final message = Message.fromMap({
                ...change.doc.data()!,
                'id': change.doc.id
              });
              
              switch (change.type) {
                case DocumentChangeType.added:
                  if (!_cachedMessages.any((m) => m.id == message.id)) {
                    _cachedMessages.add(message);
                  }
                  break;
                case DocumentChangeType.modified:
                  final index = _cachedMessages.indexWhere((m) => m.id == message.id);
                  if (index != -1) {
                    _cachedMessages[index] = message;
                  }
                  break;
                case DocumentChangeType.removed:
                  _cachedMessages.removeWhere((m) => m.id == message.id);
                  break;
              }
            }
            
            // Sort messages by timestamp
            _cachedMessages.sort((a, b) => a.timestamp.compareTo(b.timestamp));
            notifyListeners();
          }
        }, onError: (error) {
          print('Error in message stream: $error');
        });

    // Initial fetch of messages
    _fetchInitialMessages();
  }

  Future<void> _fetchInitialMessages() async {
    try {
      final snapshot = await _firestore
          .collection('chats')
          .doc(_currentChatRoomId)
          .collection('messages')
          .orderBy('timestamp', descending: false)
          .get();

      _cachedMessages = snapshot.docs.map((doc) {
        return Message.fromMap({...doc.data(), 'id': doc.id});
      }).toList();

      notifyListeners();
    } catch (e) {
      print('Error fetching initial messages: $e');
    }
  }

  // Stream of messages for the current chat
  Stream<List<Message>> getMessages() {
    return Stream.value(_cachedMessages);
  }

  // Send a message
  Future<void> sendMessage(String content) async {
    if (content.trim().isEmpty || receiverId == null) return;

    final currentUser = _auth.currentUser;
    if (currentUser == null) return;

    try {
      // Create a new document reference to get the ID
      final messageRef = _firestore
          .collection('chats')
          .doc(_currentChatRoomId)
          .collection('messages')
          .doc();

      final message = Message(
        id: messageRef.id,
        senderId: currentUser.email!,
        receiverId: receiverId!,
        content: content.trim(),
        timestamp: Timestamp.now(),
      );

      // Use the same reference to set the data
      await messageRef.set(message.toMap());

      // Update chat room info
      await _firestore.collection('chats').doc(_currentChatRoomId).set({
        'lastMessage': content,
        'lastMessageTime': Timestamp.now(),
        'participants': [currentUser.email!, receiverId!],
        'unreadCount': {
          receiverId!: FieldValue.increment(1),
        }
      }, SetOptions(merge: true));

      // Create notification for the recipient
      await _createNotification(content, currentUser.email!);

      // Clear the input field
      messageoneController.clear();
    } catch (e) {
      print('Error sending message: $e');
    }
  }

  Future<void> _createNotification(String messageContent, String senderEmail) async {
    try {
      print('Starting notification creation...');
      print('Receiver ID: $receiverId');
      print('Sender Email: $senderEmail');

      if (receiverId == null) {
        print('Error: receiverId is null');
        return;
      }

      // Get sender's username
      print('Fetching sender document...');
      final senderDoc = await _firestore.collection('users').doc(senderEmail).get();
      if (!senderDoc.exists) {
        print('Error: Sender document does not exist');
        return;
      }

      final senderData = senderDoc.data()!;
      print('Sender data: $senderData');
      
      final senderUsername = senderData['username'] as String?;
      if (senderUsername == null) {
        print('Error: username is null in sender data');
        return;
      }

      print('Creating notification data...');
      // Create notification with exact structure
      final notificationData = {
        'isRead': false,
        'message': '@$senderUsername sent you a message',
        'senderId': senderEmail,
        'timestamp': FieldValue.serverTimestamp(),
        'type': 'message'
      };

      print('Notification data: $notificationData');
      print('Adding notification to path: users/$receiverId/notifications/');

      // Add to the correct path: users/{receiverEmail}/notifications/{notificationId}
      final notificationRef = await _firestore
          .collection('users')
          .doc(receiverId)
          .collection('notifications')
          .add(notificationData);

      print('Notification created successfully with ID: ${notificationRef.id}');
    } catch (e, stackTrace) {
      print('Error creating notification: $e');
      print('Stack trace: $stackTrace');
    }
  }

  @override
  void dispose() {
    messageoneController.dispose();
    _userSubscription?.cancel();
    _messageSubscription?.cancel();
    super.dispose();
  }
}