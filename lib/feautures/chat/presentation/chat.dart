import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:secure_evoting_app/feautures/auth/services/auth.dart';
import 'package:secure_evoting_app/feautures/chat/model/model.dart';
import 'package:secure_evoting_app/feautures/chat/presentation/bubble.dart';
import 'package:secure_evoting_app/feautures/chat/service/service.dart';

class ChatPage extends StatefulWidget {
  const ChatPage(
      {super.key, required this.candidateId, required this.candidateImage});
  final String candidateId;
  final String candidateImage;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final scrollController = ScrollController();
  void _sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      String messageId = await _chatService.sendMessage(
        _messageController.text,
        widget.candidateId,
      );
      await _chatService.filterMessage(
        candidateId: widget.candidateId,
        messageId: messageId,
        message: _messageController.text,
      );
      if (scrollController.hasClients) {
        scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); // <-- Hide virtual keyboard
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_rounded),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text(
            "Campaign Chat",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.blueAccent,
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundImage: NetworkImage(
                    widget.candidateImage), // replace with your image url
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: __buildMessageList(),
            ),
            _buildeMessageInput()
          ],
        ),
      ),
    );
  }

  Widget __buildMessageList() {
    return StreamBuilder(
      stream: _chatService.getMessages(widget.candidateId),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
          return Align(
            alignment: Alignment.topCenter,
            child: ListView.separated(
              reverse: true,
              controller: scrollController,
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final doc = snapshot.data!.docs[index];
                final message =
                    Message.fromJson(doc.data() as Map<String, dynamic>);
                return Bubble(
                  chat: message,
                  margin: EdgeInsets.only(
                    left: 10,
                    right: 10,
                    top: 1,
                    bottom: 1,
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return SizedBox(height: 8);
              },
            ),
          );
        } else if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text("No messages yet. Start the conversation now!"),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget _buildMessageItem(DocumentSnapshot message) {
    Map<String, dynamic> data = message.data() as Map<String, dynamic>;

    var alignment = (data['senderId'] == Auth().currentUser!.uid)
        ? Alignment.centerRight
        : Alignment.centerLeft;

    return Align(
      alignment: alignment,
      child: Container(
        margin: EdgeInsets.all(8),
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: (data['senderId'] == Auth().currentUser!.uid)
              ? Colors.blue
              : Colors.grey,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(data['senderEmail']),
            Text(data['message']),
          ],
        ),
      ),
    );
  }

  Widget _buildeMessageInput() {
    return Container(
      margin: EdgeInsets.all(15.0),
      height: 61,
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(35.0),
                boxShadow: [
                  BoxShadow(
                      offset: Offset(0, 3), blurRadius: 5, color: Colors.grey)
                ],
              ),
              child: Row(
                children: [
                  const SizedBox(width: 15),
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                          hintText: "Type Something...",
                          hintStyle: TextStyle(color: Colors.black54),
                          border: InputBorder.none),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 15),
          Container(
              decoration: BoxDecoration(
                  color: Colors.blueAccent, shape: BoxShape.circle),
              child: IconButton(
                icon: Icon(Icons.send, color: Colors.white),
                onPressed: _sendMessage,
              ))
        ],
      ),
    );
  }
}
