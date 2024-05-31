library flutter_chat_bubble;

import 'package:flutter/material.dart';
import 'package:secure_evoting_app/feautures/auth/services/auth.dart';
import 'package:secure_evoting_app/feautures/chat/model/model.dart';
import 'package:secure_evoting_app/feautures/chat/presentation/formatter.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_1.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';

class Bubble extends StatelessWidget {
  final EdgeInsetsGeometry? margin;
  final Message chat;

  const Bubble({
    super.key,
    this.margin,
    required this.chat,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: alignmentOnType,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (chat.senderId != Auth().currentUser!.uid)
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: CircleAvatar(
              backgroundImage: NetworkImage(chat.profilePhoto),
            ),
          ),
        Container(
          margin: margin ?? EdgeInsets.zero,
          child: PhysicalShape(
            clipper: clipperOnType,
            elevation: 2,
            color: bgColorOnType,
            shadowColor: Colors.grey.shade200,
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.8,
              ),
              padding: paddingOnType,
              child: Column(
                crossAxisAlignment: crossAlignmentOnType,
                children: [
                  Text(
                    chat.message,
                    style: TextStyle(color: textColorOnType),
                  ),
                  if (isRead)
                    const Icon(
                      Icons.warning,
                      size: 16,
                      color: Colors.black38,
                    ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    Formatter.formatDateTime(chat.timestamp.toDate()),
                    style: TextStyle(color: textColorOnType, fontSize: 12),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  bool get isRead {
    String cleanMessage =
        chat.message.replaceAll(RegExp(r'\W'), '').toLowerCase();
    String keyword = 'thismessageisfilteredoutbecauseitcontains'.toLowerCase();

    if (cleanMessage.contains(keyword)) {
      return true;
    } else {
      return false;
    }
  }

  Color get textColorOnType {
    String cleanMessage =
        chat.message.replaceAll(RegExp(r'\W'), '').toLowerCase();
    String keyword = 'thismessageisfilteredoutbecauseitcontains'.toLowerCase();

    if (cleanMessage.contains(keyword)) {
      return Colors.white;
    }
    if (chat.senderId == Auth().currentUser!.uid) {
      return Colors.white;
    } else {
      return const Color(0xFF0F0F0F);
    }
  }

  Color get bgColorOnType {
    String cleanMessage =
        chat.message.replaceAll(RegExp(r'\W'), '').toLowerCase();
    String keyword = 'thismessageisfilteredoutbecauseitcontains'.toLowerCase();

    if (cleanMessage.contains(keyword)) {
      return Color.fromARGB(
          255, 201, 77, 77); // color for messages containing the keyword
    }
    if (chat.senderId == Auth().currentUser!.uid) {
      return const Color(0xFF007AFF); // color for sent messages
    } else {
      return const Color(0xFFE7E7ED); // color for received messages
    }
  }

  CustomClipper<Path> get clipperOnType {
    if (chat.senderId == Auth().currentUser!.uid) {
      return ChatBubbleClipper1(type: BubbleType.sendBubble);
    } else {
      return ChatBubbleClipper1(type: BubbleType.receiverBubble);
    }
  }

  CrossAxisAlignment get crossAlignmentOnType {
    if (chat.senderId == Auth().currentUser!.uid) {
      return CrossAxisAlignment.end;
    } else {
      return CrossAxisAlignment.start;
    }
  }

  MainAxisAlignment get alignmentOnType {
    if (chat.senderId == Auth().currentUser!.uid) {
      return MainAxisAlignment.end;
    } else {
      return MainAxisAlignment.start;
    }
  }

  EdgeInsets get paddingOnType {
    if (chat.senderId == Auth().currentUser!.uid) {
      return const EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 24);
    } else {
      return const EdgeInsets.only(
        top: 10,
        bottom: 10,
        left: 24,
        right: 10,
      );
    }
  }
}
