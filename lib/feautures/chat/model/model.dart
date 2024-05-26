import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderId;
  final String senderEmail;
  final String message;
  final Timestamp timestamp;
  final String profilePhoto;

  Message(
      {required this.senderId,
      required this.senderEmail,
      required this.message,
      required this.timestamp,
      required this.profilePhoto});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
        senderId: json['senderId'],
        senderEmail: json['senderEmail'],
        message: json['message'],
        timestamp: json['timestamp'],
        profilePhoto: json['profilePhoto']);
  }

  Map<String, dynamic> toJson() {
    return {
      'senderId': senderId,
      'senderEmail': senderEmail,
      'message': message,
      'timestamp': timestamp,
      'profilePhoto': profilePhoto
    };
  }
}
