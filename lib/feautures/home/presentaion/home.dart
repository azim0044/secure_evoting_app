// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, unused_field

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:getwidget/getwidget.dart';
import 'package:intl/intl.dart';
import 'package:secure_evoting_app/feautures/auth/services/auth.dart';
import 'package:secure_evoting_app/shared/widget/build_title.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:secure_evoting_app/shared/widget/easy_loading_custom.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  String _publicKeyDate = '';
  int _pendingElection = 0;
  int _completedElection = 0;

  @override
  void initState() {
    super.initState();
    getElectionCount();
  }

  void checkPublicKey() async {
    try {
      await performLoading<void>(
        checkPublicKeyDate(),
        'Checking key...',
        'Key is still valid!',
      );
    } catch (e) {
      EasyLoading.showError(
          e is Exception ? e.toString().split('Exception: ')[1] : e.toString());
    }
  }

  Future<void> checkPublicKeyDate() async {
    FlutterSecureStorage storage = FlutterSecureStorage();
    final String? publicKeyDateStr = await storage.read(key: 'secureKeyTime');
    final String? publicKey = await storage.read(key: 'secureKey');
    if (publicKey == null) {
      throw Exception('Key not found. Please generate a new key.');
    }
    if (publicKeyDateStr != null && publicKeyDateStr.isNotEmpty) {
      DateTime publicKeyDate = DateTime.parse(publicKeyDateStr);
      DateTime now = DateTime.now();
      int differenceInDays = now.difference(publicKeyDate).inDays;
      if (differenceInDays > 5) {
        throw Exception(
            'More than 5 days have passed since the key date. Please generate a new key.');
      }
      setState(() {
        _publicKeyDate = DateFormat('d MMM h:mm a').format(publicKeyDate);
      });
    }
  }

  void checkUserReference() async {
    try {
      await performLoading<void>(
        fetchUserReference(),
        'Checking user reference...',
        'User already has a reference!',
      );
    } catch (e) {
      EasyLoading.showError(
          e is Exception ? e.toString().split('Exception: ')[1] : e.toString());
    }
  }

  Future<bool> fetchUserReference() async {
    DocumentReference userRef = FirebaseFirestore.instance
        .collection('users')
        .doc(Auth().currentUser!.uid);
    DocumentSnapshot userSnapshot = await userRef.get();
    if (userSnapshot.exists) {
      bool userReference = userSnapshot['userReference'];
      if (userReference) {
        return userReference;
      } else {
        throw Exception('User does not have a reference image.');
      }
    } else {
      throw Exception('User does not exist');
    }
  }

  void getElectionCount() async {
    FirebaseFirestore _db = FirebaseFirestore.instance;

    QuerySnapshot querySnapshot1 = await _db
        .collection('elections')
        .where('voterIds', arrayContains: Auth().currentUser!.uid)
        .where('status', isEqualTo: 'In Progress')
        .get();

    QuerySnapshot querySnapshot2 = await _db
        .collection('elections')
        .where('completedVoterId', arrayContains: Auth().currentUser!.uid)
        .where('status', isEqualTo: 'Complete')
        .get();
    print(querySnapshot1.docs.length);
    print(querySnapshot2.docs.length);
    setState(() {
      _pendingElection = querySnapshot1.docs.length;
      _completedElection = querySnapshot2.docs.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _customHeader(),
              const SizedBox(height: 20),
              buildTitle('Election Status'),
              _ElectionStatusCard(
                image: 'assets/images/alert.png',
                title: 'Pending Votes',
                number: _pendingElection.toString(),
                color: Colors.orange,
              ),
              const SizedBox(height: 20),
              _ElectionStatusCard(
                image: 'assets/images/complete_vote.png',
                title: 'Complete Votes',
                number: _completedElection.toString(),
                color: Colors.green,
              ),
              const SizedBox(height: 20),
              buildTitle('Account Security'),
              _ElectionStatusCard(
                image: 'assets/images/public_key.png',
                title: 'Secure Key',
                subtitle: _publicKeyDate.isEmpty
                    ? 'Check your secure key validity'
                    : "Generated: " + _publicKeyDate,
                icon: Icon(
                  Icons.refresh,
                ),
                onTap: () {
                  // FlutterSecureStorage storage = FlutterSecureStorage();
                  // storage.write(
                  //     key: 'public_key_time',
                  //     value: DateTime.now().toIso8601String());
                  checkPublicKey();
                  print(_publicKeyDate);
                },
              ),
              const SizedBox(height: 20),
              _ElectionStatusCard(
                image: 'assets/images/authentication.png',
                title: 'Reference',
                subtitle: 'Check your reference image',
                icon: Icon(
                  Icons.refresh,
                ),
                onTap: () {
                  checkUserReference();
                },
              )
            ],
          ),
        ],
      ),
    );
  }

  Container _customHeader() {
    return Container(
      height: 180,
      width: double.infinity,
      color: Colors.blueAccent,
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundImage: Image.network(
                    Auth().currentUser!.photoURL!,
                  ).image,
                ),
                const SizedBox(height: 10.0),
                Text(
                  'Today\'s, ${DateFormat('d MMM').format(DateTime.now())}',
                  style: GoogleFonts.radioCanada(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
                Text(
                  Auth().currentUser!.displayName!,
                  style: GoogleFonts.radioCanada(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: GFIconButton(
              onPressed: () {},
              icon: Icon(
                Icons.notifications,
                color: Colors.white,
                size: 30,
              ),
              shape: GFIconButtonShape.square,
              type: GFButtonType.transparent,
            ),
          ),
        ],
      ),
    );
  }
}

class _ElectionStatusCard extends StatelessWidget {
  const _ElectionStatusCard({
    required this.image,
    required this.title,
    this.number,
    this.color,
    this.subtitle,
    this.icon,
    this.onTap,
  });

  final String image;
  final String title;
  final String? number;
  final Color? color;
  final String? subtitle;
  final Icon? icon;
  final Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: ListTile(
              leading: Image.asset(image),
              title: Text(
                title,
                style: GoogleFonts.radioCanada(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: subtitle != null && subtitle!.isNotEmpty
                  ? Text(
                      subtitle!,
                      style: GoogleFonts.radioCanada(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    )
                  : null,
              trailing: icon ??
                  Text(
                    number!,
                    style: GoogleFonts.radioCanada(
                      fontSize: 16,
                      color: color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              onTap: onTap,
            ),
          )),
    );
  }
}
