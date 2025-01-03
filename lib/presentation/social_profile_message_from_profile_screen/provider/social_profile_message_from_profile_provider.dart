import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/message_model.dart';

/// A provider class for the SocialProfileMessageFromProfileScreen.
///
/// This provider manages the state of the SocialProfileMessageFromProfileScreen, 
/// including the current [socialProfileMessageFromProfileModelObj].
class SocialProfileMessageFromProfileProvider extends ChangeNotifier {
  final TextEditingController messageoneController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  String? receiverId;
  List<Message> messages = [];
  bool isLoading = false;

  void setReceiverId(String id) {
    receiverId = id;
    notifyListeners();
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

      // Clear the input field
      messageoneController.clear();
      notifyListeners();
    } catch (e) {
      print('Error sending message: $e');
    }
  }

  // Stream of messages for the current chat
  Stream<List<Message>> getMessages() {
    if (receiverId == null) return Stream.value([]);

    final currentUser = _auth.currentUser;
    if (currentUser == null) return Stream.value([]);

    final List<String> ids = [currentUser.email!, receiverId!]..sort();
    final String chatRoomId = ids.join('_');

    return _firestore
        .collection('chats')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => Message.fromMap(doc.data()))
              .toList();
        });
  }

  // Mark messages as read
  Future<void> markMessagesAsRead() async {
    if (receiverId == null) return;

    final currentUser = _auth.currentUser;
    if (currentUser == null) return;

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
    super.dispose();
  }
}