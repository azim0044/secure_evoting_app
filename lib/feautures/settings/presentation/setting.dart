// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, unused_element

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:secure_evoting_app/feautures/auth/presentation/login.dart';
import 'package:secure_evoting_app/feautures/auth/services/auth.dart';
import 'package:secure_evoting_app/feautures/settings/presentation/face_recognition.dart';
import 'package:secure_evoting_app/feautures/settings/presentation/services.dart';
import 'package:secure_evoting_app/feautures/settings/presentation/update-profile.dart';
import 'package:secure_evoting_app/shared/const/api_endpoints.dart';
import 'package:secure_evoting_app/shared/widget/easy_loading_custom.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:getwidget/getwidget.dart';
import 'package:http/http.dart' as http;

class SettingScreenWidget extends StatefulWidget {
  const SettingScreenWidget({super.key});

  @override
  _SettingScreenWidgetState createState() => _SettingScreenWidgetState();
}

class _SettingScreenWidgetState extends State<SettingScreenWidget> {
  void _generateKeyPair() async {
    try {
      await performLoading<void>(
        _keyPairNetworkRequest(),
        'Generating key...',
        'Key generated and saved successfully!',
      );
    } catch (e) {
      EasyLoading.showError(e.toString());
    }
  }

  Future<http.Response> _keyPairNetworkRequest() async {
    FlutterSecureStorage storage = FlutterSecureStorage();
    String? token = await storage.read(key: 'token');
    String url = ApiEndPoints().generateKey;

    final response = await http.get(
      Uri.parse('$url?userId=${Auth().currentUser!.uid}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> responseBody = jsonDecode(response.body);
      await storage.write(key: 'secureKey', value: responseBody['secureKey']);
      await storage.write(
          key: 'secureKeyTime', value: DateTime.now().toIso8601String());
      return response;
    } else {
      throw Exception(
          'Failed to generate key. Please try again later or contact support.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Settings",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.blueAccent,
        ),
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: ListView(children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  CircleAvatar(
                    radius: 70,
                    backgroundImage: Image.network(
                      Auth().currentUser!.photoURL!,
                    ).image,
                  ),
                  _SingleSection(
                    title: "Account Settings",
                    children: [
                      SingleChildScrollView(
                        child: Card(
                          color: Theme.of(context)
                              .colorScheme
                              .onSecondary
                              .withOpacity(1),
                          child: Container(
                            width: double.infinity,
                            color: Colors.white,
                            child: Column(
                              children: [
                                _CustomListTile1(
                                    title: "Update Password",
                                    icon: Icons.person,
                                    trailing:
                                        Icon(Icons.arrow_forward_ios, size: 18),
                                    onTap: () {
                                      Get.to(() => UpdateProfileWidget(),
                                          transition: Transition.rightToLeft);
                                    }),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  _SingleSection(
                    title: "Privacy and Security",
                    children: [
                      SingleChildScrollView(
                        child: Card(
                          color: Theme.of(context)
                              .colorScheme
                              .onSecondary
                              .withOpacity(1),
                          child: Container(
                            width: double.infinity,
                            color: Colors.white,
                            child: Column(
                              children: [
                                _CustomListTile1(
                                    title: "Generate Secure Key",
                                    icon: Icons.key,
                                    trailing: Icon(Icons.refresh, size: 18),
                                    onTap: () {
                                      _generateKeyPair();
                                    }),
                                Divider(
                                  height: 10,
                                  thickness: 0.7,
                                  indent: 5,
                                  endIndent: 5,
                                ),
                                _CustomListTile1(
                                    title: "Upload Reference Image",
                                    icon: Icons.person,
                                    trailing:
                                        Icon(Icons.arrow_forward_ios, size: 18),
                                    onTap: () {
                                      Get.to(
                                          () => FaceAuthenticationWidgetScreen(
                                                fromWidget: 'Upload Reference',
                                              ),
                                          transition: Transition.rightToLeft);
                                    }),
                                Divider(
                                  height: 10,
                                  thickness: 0.7,
                                  indent: 5,
                                  endIndent: 5,
                                ),
                                _CustomListTile1(
                                  title: "Logout",
                                  icon: Icons.logout_outlined,
                                  onTap: () async {
                                    EasyLoading.show(status: 'Logging out...');
                                    await Future.delayed(
                                        const Duration(seconds: 2));
                                    Auth().signOut();
                                    SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                    prefs.clear();
                                    FlutterSecureStorage storage =
                                        FlutterSecureStorage();
                                    await storage.deleteAll();
                                    EasyLoading.dismiss();
                                    Get.offAll(() => LoginPageScreen());
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ]),
        ));
  }
}

Widget _divider() {
  return Divider(
    height: 10,
    thickness: 1.0,
    indent: 5,
    endIndent: 5,
  );
}

class _CustomListTile extends StatelessWidget {
  final String? title;
  final IconData icon;
  final Widget? trailing;
  final Function onTap;
  const _CustomListTile(
      {Key? key,
      this.title,
      required this.icon,
      required this.onTap,
      this.trailing})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      trailing: trailing ?? const Icon(CupertinoIcons.forward, size: 18),
      onTap: () {
        onTap();
      },
    );
  }
}

class _SingleSection extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const _SingleSection({
    Key? key,
    required this.title,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: GFTypography(
            text: title,
            fontWeight: FontWeight.bold,
            textColor: Colors.black.withOpacity(0.5),
            type: GFTypographyType.typo5,
            showDivider: false,
          ),
        ),
        Container(
          width: double.infinity,
          color: Theme.of(context).colorScheme.surface,
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }
}

class _CustomListTile1 extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget? trailing;
  final Function onTap;
  const _CustomListTile1(
      {Key? key,
      required this.title,
      required this.icon,
      required this.onTap,
      this.trailing})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.normal,
            fontFamily: GoogleFonts.roboto().fontFamily),
      ),
      leading: Icon(icon),
      trailing: trailing,
      onTap: () {
        onTap();
      },
    );
  }
}
