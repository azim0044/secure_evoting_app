import 'package:face_camera/face_camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:secure_evoting_app/feautures/auth/presentation/login.dart';
import 'package:secure_evoting_app/feautures/body_layout/presentation/body_layout.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
WidgetsFlutterBinding.ensureInitialized();
await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
  await FaceCamera.initialize();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      builder: EasyLoading.init(),
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: HexColor('#FAF9F6'),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(HexColor('#FB5D02')),
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
        ),
        buttonTheme: const ButtonThemeData(
          buttonColor: Colors.black,
          textTheme: ButtonTextTheme.normal,
        ),
      ),
      home: FutureBuilder<bool>(
        future: _getInitialScreen(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator(); // or some other widget while waiting
          } else {
            if (snapshot.data == true) {
              return const BodyLayoutWidget();
            } else {
              return const LoginPageScreen();
            }
          }
        },
      ),
    );
  }

  Future<bool> _getInitialScreen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isLogin = prefs.getBool('isVerified');
    print(isLogin);
    return isLogin ?? false;
  }
}

// import 'dart:async';

// import 'package:chatview/chatview.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:secure_evoting_app/data.dart';
// import 'package:secure_evoting_app/firebase_options.dart';
// import 'package:secure_evoting_app/theme.dart';
// import 'package:rxdart/rxdart.dart';
// import 'package:tuple/tuple.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//   runApp(const Example());
// }

// class Example extends StatelessWidget {
//   const Example({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Chat UI Demo',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         primaryColor: const Color(0xffEE5366),
//         colorScheme:
//             ColorScheme.fromSwatch(accentColor: const Color(0xffEE5366)),
//       ),
//       home: const ChatScreen(),
//     );
//   }
// }

// class ChatScreen extends StatefulWidget {
//   const ChatScreen({Key? key}) : super(key: key);

//   @override
//   State<ChatScreen> createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   @override
//   void initState() {
//     super.initState();
//     _initializeFirebase();
//   }

//   Future<void> _initializeFirebase() async {
//     _listenToChatUpdates();
//   }

//   final _chatController = ChatController(
//     initialMessageList: [],
//     scrollController: ScrollController(),
//     chatUsers: [], // Initialize with an empty list
//   );

//   void _listenToChatUpdates() {
//     FirebaseFirestore.instance
//         .collection('chat')
//         .doc('test1')
//         .collection('chats')
//         .snapshots()
//         .listen((snapshot) {
//       List<Message> messages = snapshot.docs.map((doc) {
//         Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
//         return Message(
//           id: data['sendBy'] as String,
//           message: data['message'] as String,
//           createdAt: DateTime.parse(data['createdAt'] as String),
//           sendBy: data['sendBy'] as String,
//         );
//       }).toList();

//       List<ChatUser> users = messages.map((message) {
//         return ChatUser(
//           id: message.sendBy,
//           name: 'Flutter', // Replace with actual name
//           profilePhoto: Data.profileImage, // Replace with actual profile photo
//         );
//       }).toList();

//       if (mounted) {
//         setState(() {
//           _chatController.initialMessageList = messages;
//           _chatController.chatUsers = users;
//         });
//       }
//     });
//   }

//   AppTheme theme = LightTheme();
//   bool isDarkTheme = false;
//   final currentUser = ChatUser(
//     id: '1',
//     name: 'Flutter',
//     profilePhoto: Data.profileImage,
//   );

//   // Usage

//   void _showHideTypingIndicator() {
//     _chatController.setTypingIndicator = !_chatController.showTypingIndicator;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: ChatView(
//         currentUser: currentUser,
//         chatController: _chatController,
//         onSendTap: _onSendTap,
//         featureActiveConfig: const FeatureActiveConfig(
//           lastSeenAgoBuilderVisibility: true,
//           receiptsBuilderVisibility: true,
//         ),
//         chatViewState: ChatViewState.hasMessages,
//         chatViewStateConfig: ChatViewStateConfiguration(
//           loadingWidgetConfig: ChatViewStateWidgetConfiguration(
//             loadingIndicatorColor: theme.outgoingChatBubbleColor,
//           ),
//           onReloadButtonTap: () {},
//         ),
//         typeIndicatorConfig: TypeIndicatorConfiguration(
//           flashingCircleBrightColor: theme.flashingCircleBrightColor,
//           flashingCircleDarkColor: theme.flashingCircleDarkColor,
//         ),
//         appBar: ChatViewAppBar(
//           elevation: theme.elevation,
//           backGroundColor: theme.appBarColor,
//           profilePicture: Data.profileImage,
//           backArrowColor: theme.backArrowColor,
//           chatTitle: "Chat view",
//           chatTitleTextStyle: TextStyle(
//             color: theme.appBarTitleTextStyle,
//             fontWeight: FontWeight.bold,
//             fontSize: 18,
//             letterSpacing: 0.25,
//           ),
//           userStatus: "online",
//           userStatusTextStyle: const TextStyle(color: Colors.grey),
//           actions: [
//             IconButton(
//               onPressed: _onThemeIconTap,
//               icon: Icon(
//                 isDarkTheme
//                     ? Icons.brightness_4_outlined
//                     : Icons.dark_mode_outlined,
//                 color: theme.themeIconColor,
//               ),
//             ),
//             IconButton(
//               tooltip: 'Toggle TypingIndicator',
//               onPressed: _showHideTypingIndicator,
//               icon: Icon(
//                 Icons.keyboard,
//                 color: theme.themeIconColor,
//               ),
//             ),
//           ],
//         ),
//         chatBackgroundConfig: ChatBackgroundConfiguration(
//           messageTimeIconColor: theme.messageTimeIconColor,
//           messageTimeTextStyle: TextStyle(color: theme.messageTimeTextColor),
//           defaultGroupSeparatorConfig: DefaultGroupSeparatorConfiguration(
//             textStyle: TextStyle(
//               color: theme.chatHeaderColor,
//               fontSize: 17,
//             ),
//           ),
//           backgroundColor: theme.backgroundColor,
//         ),
//         sendMessageConfig: SendMessageConfiguration(
//           imagePickerIconsConfig: ImagePickerIconsConfiguration(
//             cameraIconColor: theme.cameraIconColor,
//             galleryIconColor: theme.galleryIconColor,
//           ),
//           replyMessageColor: theme.replyMessageColor,
//           defaultSendButtonColor: theme.sendButtonColor,
//           replyDialogColor: theme.replyDialogColor,
//           replyTitleColor: theme.replyTitleColor,
//           textFieldBackgroundColor: theme.textFieldBackgroundColor,
//           closeIconColor: theme.closeIconColor,
//           textFieldConfig: TextFieldConfiguration(
//             onMessageTyping: (status) {
//               /// Do with status
//               debugPrint(status.toString());
//             },
//             compositionThresholdTime: const Duration(seconds: 1),
//             textStyle: TextStyle(color: theme.textFieldTextColor),
//           ),
//           micIconColor: theme.replyMicIconColor,
//         ),
//         chatBubbleConfig: ChatBubbleConfiguration(
//           outgoingChatBubbleConfig: ChatBubble(
//             linkPreviewConfig: LinkPreviewConfiguration(
//               backgroundColor: theme.linkPreviewOutgoingChatColor,
//               bodyStyle: theme.outgoingChatLinkBodyStyle,
//               titleStyle: theme.outgoingChatLinkTitleStyle,
//             ),
//             receiptsWidgetConfig:
//                 const ReceiptsWidgetConfig(showReceiptsIn: ShowReceiptsIn.all),
//             color: theme.outgoingChatBubbleColor,
//           ),
//           inComingChatBubbleConfig: ChatBubble(
//             linkPreviewConfig: LinkPreviewConfiguration(
//               linkStyle: TextStyle(
//                 color: theme.inComingChatBubbleTextColor,
//                 decoration: TextDecoration.underline,
//               ),
//               backgroundColor: theme.linkPreviewIncomingChatColor,
//               bodyStyle: theme.incomingChatLinkBodyStyle,
//               titleStyle: theme.incomingChatLinkTitleStyle,
//             ),
//             textStyle: TextStyle(color: theme.inComingChatBubbleTextColor),
//             onMessageRead: (message) {
//               /// send your message reciepts to the other client
//               debugPrint('Message Read');
//             },
//             senderNameTextStyle:
//                 TextStyle(color: theme.inComingChatBubbleTextColor),
//             color: theme.inComingChatBubbleColor,
//           ),
//         ),
//         replyPopupConfig: ReplyPopupConfiguration(
//           backgroundColor: theme.replyPopupColor,
//           buttonTextStyle: TextStyle(color: theme.replyPopupButtonColor),
//           topBorderColor: theme.replyPopupTopBorderColor,
//         ),
//         reactionPopupConfig: ReactionPopupConfiguration(
//           shadow: BoxShadow(
//             color: isDarkTheme ? Colors.black54 : Colors.grey.shade400,
//             blurRadius: 20,
//           ),
//           backgroundColor: theme.reactionPopupColor,
//         ),
//         messageConfig: MessageConfiguration(
//           messageReactionConfig: MessageReactionConfiguration(
//             backgroundColor: theme.messageReactionBackGroundColor,
//             borderColor: theme.messageReactionBackGroundColor,
//             reactedUserCountTextStyle:
//                 TextStyle(color: theme.inComingChatBubbleTextColor),
//             reactionCountTextStyle:
//                 TextStyle(color: theme.inComingChatBubbleTextColor),
//             reactionsBottomSheetConfig: ReactionsBottomSheetConfiguration(
//               backgroundColor: theme.backgroundColor,
//               reactedUserTextStyle: TextStyle(
//                 color: theme.inComingChatBubbleTextColor,
//               ),
//               reactionWidgetDecoration: BoxDecoration(
//                 color: theme.inComingChatBubbleColor,
//                 boxShadow: [
//                   BoxShadow(
//                     color: isDarkTheme ? Colors.black12 : Colors.grey.shade200,
//                     offset: const Offset(0, 20),
//                     blurRadius: 40,
//                   )
//                 ],
//                 borderRadius: BorderRadius.circular(10),
//               ),
//             ),
//           ),
//           imageMessageConfig: ImageMessageConfiguration(
//             margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
//             shareIconConfig: ShareIconConfiguration(
//               defaultIconBackgroundColor: theme.shareIconBackgroundColor,
//               defaultIconColor: theme.shareIconColor,
//             ),
//           ),
//         ),
//         profileCircleConfig: const ProfileCircleConfiguration(
//           profileImageUrl: Data.profileImage,
//         ),
//         repliedMessageConfig: RepliedMessageConfiguration(
//           backgroundColor: theme.repliedMessageColor,
//           verticalBarColor: theme.verticalBarColor,
//           repliedMsgAutoScrollConfig: RepliedMsgAutoScrollConfig(
//             enableHighlightRepliedMsg: true,
//             highlightColor: Colors.pinkAccent.shade100,
//             highlightScale: 1.1,
//           ),
//           textStyle: const TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//             letterSpacing: 0.25,
//           ),
//           replyTitleTextStyle: TextStyle(color: theme.repliedTitleTextColor),
//         ),
//         swipeToReplyConfig: SwipeToReplyConfiguration(
//           replyIconColor: theme.swipeToReplyIconColor,
//         ),
//       ),
//     );
//   }

//   void _onSendTap(
//     String message,
//     ReplyMessage replyMessage,
//     MessageType messageType,
//   ) {
//     final id = int.parse(Data.messageList.last.id) + 1;
//     _chatController.addMessage(
//       Message(
//         id: id.toString(),
//         createdAt: DateTime.now(),
//         message: message,
//         sendBy: currentUser.id,
//         replyMessage: replyMessage,
//         messageType: messageType,
//       ),
//     );
//     Future.delayed(const Duration(milliseconds: 300), () {
//       print(DateTime.now());
//       _chatController.initialMessageList.last.setStatus =
//           MessageStatus.undelivered;
//     });
//     Future.delayed(const Duration(seconds: 1), () {
//       _chatController.initialMessageList.last.setStatus = MessageStatus.read;
//     });
//   }

//   void _onThemeIconTap() {
//     setState(() {
//       if (isDarkTheme) {
//         theme = LightTheme();
//         isDarkTheme = false;
//       } else {
//         theme = DarkTheme();
//         isDarkTheme = true;
//       }
//     });
//   }
// }
