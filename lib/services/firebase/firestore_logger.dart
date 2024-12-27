import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> logToFirestore() async {
  try {
    final firestore = FirebaseFirestore.instance;

    await firestore.collection('app_logs').add({
      'timestamp': FieldValue.serverTimestamp(),
      'message': 'App opened',
      'details': 'Initialization log',
    });

    print('Logged to Firestore successfully');
  } catch (e) {
    print('Error logging to Firestore: $e');
  }
}