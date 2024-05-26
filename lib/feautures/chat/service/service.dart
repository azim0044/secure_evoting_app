import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:secure_evoting_app/feautures/auth/services/auth.dart';
import 'package:secure_evoting_app/feautures/chat/model/model.dart';
import 'package:http/http.dart' as http;
import 'package:secure_evoting_app/shared/const/api_endpoints.dart';

class ChatService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> sendMessage(String message, String candidateId) async {
    final String currentUserId = Auth().currentUser!.uid;
    final String currentUserEmail = Auth().currentUser!.email!;
    final String profilePhoto = Auth().currentUser!.photoURL!;
    final Timestamp timestamp = Timestamp.now();

    Message newMessage = Message(
        senderId: currentUserId,
        senderEmail: currentUserEmail,
        message: message,
        profilePhoto: profilePhoto,
        timestamp: timestamp);

    DocumentReference docRef = await _firestore
        .collection('chat_rooms')
        .doc(candidateId)
        .collection('messages')
        .add(newMessage.toJson());

    return docRef.id;
  }

  Future<void> filterMessage(
      {required String candidateId,
      required String messageId,
      required String message}) async {
    const FlutterSecureStorage storage = FlutterSecureStorage();
    String? token = await storage.read(key: 'token');
    String url = ApiEndPoints().filterMessage;

    await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, String>{
        'candidateId': candidateId,
        'messageId': messageId,
        'message': message,
      }),
    );
  }

  Stream<QuerySnapshot> getMessages(String candidateId) {
    return _firestore
        .collection('chat_rooms')
        .doc(candidateId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }
}
