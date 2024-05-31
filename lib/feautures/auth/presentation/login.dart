// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, prefer_const_literals_to_create_immutables, unnecessary_null_comparison

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:secure_evoting_app/feautures/auth/presentation/otp_home.dart';
import 'package:secure_evoting_app/feautures/auth/presentation/register.dart';
import 'package:secure_evoting_app/feautures/auth/services/auth.dart';
import 'package:secure_evoting_app/shared/const/api_endpoints.dart';
import 'package:secure_evoting_app/shared/widget/easy_loading_custom.dart';
import 'package:secure_evoting_app/shared/widget/form_filed.dart';
import 'package:http/http.dart' as http;

class LoginPageScreen extends StatelessWidget {
  const LoginPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    FocusNode emailFocusNode = FocusNode();
    FocusNode passwordFocusNode = FocusNode();

    Future<http.Response> _userLogin() async {
      String url = ApiEndPoints().login;
      Map<String, dynamic> jsonPayload = {
        'email': emailController.text,
        'password': passwordController.text,
      };
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(jsonPayload),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseBody = jsonDecode(response.body);
        String message = responseBody['access_token'];
        String secureKey = responseBody['secureKey'];
        FlutterSecureStorage storage = FlutterSecureStorage();
        await storage.write(key: 'token', value: message);
        await storage.write(key: 'secureKey', value: secureKey);
        await storage.write(
            key: 'secureKeyTime', value: DateTime.now().toIso8601String());
        return response;
      } else {
        throw Exception(
            'Failed to login. Please try again later or contact support.');
      }
    }

    void signInUser() async {
      try {
        var results = await performLoading<List<dynamic>>(
          Future.wait([
            Auth().signInWithEmailAndPassword(
              email: emailController.text,
              password: passwordController.text,
            ),
            _userLogin(),
          ]),
          'Signing in...',
          'Successfully signed in!',
          'Failed to sign in',
        );

        if (results != null && results.every((result) => result != null)) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Get.offAll(() => const QrCodeHome());
          });
        }
      } catch (e) {
        print(e);
      }
    }

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 70.0),
                  Container(
                    alignment: Alignment.topRight,
                    child: SizedBox(
                      width: 130,
                      child: Image.asset('assets/images/vote.png'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Column(
                      children: [
                        const SizedBox(height: 20.0),
                        Container(
                          alignment: Alignment.topLeft,
                          child: RichText(
                            text: TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                  text: 'Hi !',
                                  style: TextStyle(
                                    fontSize: 60,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Blinker',
                                    color: Colors.black,
                                  ),
                                ),
                                TextSpan(
                                  text: '\n',
                                  style: TextStyle(
                                    fontSize: 60,
                                    height:
                                        0.5, // Adjust this value to control the space
                                  ),
                                ),
                                TextSpan(
                                  text: 'Welcome',
                                  style: TextStyle(
                                    fontSize: 60,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Blinker',
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              'Sign in to get started.',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                  fontFamily: 'OpenSans',
                                  color: Colors.grey),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Padding(
                    padding: const EdgeInsets.all(30),
                    child: SizedBox(
                      child: Column(
                        children: [
                          CustomFormWidget(
                            labelText: 'Email',
                            hintText: 'Enter your email',
                            icon: Icons.mail,
                            isPassword: false,
                            controller: emailController,
                            focusNode: emailFocusNode,
                          ),
                          const SizedBox(height: 10),
                          CustomFormWidget(
                            labelText: 'Password',
                            hintText: 'Enter your password',
                            icon: Icons.lock,
                            isPassword: true,
                            controller: passwordController,
                            focusNode: passwordFocusNode,
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () async {
                                if (emailController.text.isEmpty ||
                                    passwordController.text.isEmpty) {
                                } else {
                                  signInUser();
                                }
                              },
                              child: const Padding(
                                padding: EdgeInsets.all(15),
                                child: Text(
                                  'Login',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'OpenSans',
                                      color: Colors.white),
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: HexColor('#FB5D02'),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                elevation: 5.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 0),
                    child: Center(
                        child: Text.rich(
                      TextSpan(
                        text: "Don't have an account? ",
                        style:
                            const TextStyle(fontSize: 16, color: Colors.grey),
                        children: <InlineSpan>[
                          WidgetSpan(
                            child: InkWell(
                              onTap: () {
                                Get.to(() => const RegisterPageScreen(),
                                    transition: Transition.downToUp);
                              },
                              child: Text(
                                'Sign Up',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: HexColor('#FB5D02'),
                                  decoration: TextDecoration.underline,
                                  fontFamily: 'OpenSans',
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
