// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'dart:io';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:secure_evoting_app/feautures/auth/services/auth.dart';
import 'package:secure_evoting_app/shared/widget/easy_loading_custom.dart';
import 'package:secure_evoting_app/shared/widget/form_filed.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:bcrypt/bcrypt.dart';

class RegisterPageScreen extends StatefulWidget {
  const RegisterPageScreen({super.key});

  @override
  State<RegisterPageScreen> createState() => _RegisterPageScreenState();
}

class _RegisterPageScreenState extends State<RegisterPageScreen> {
  File? _image;

  final storage = FirebaseStorage.instance;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController cPasswordController = TextEditingController();
  TextEditingController fullName = TextEditingController();

  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  FocusNode fullNameFocusNode = FocusNode();
  FocusNode cPasswordFocusNode = FocusNode();

  Future getImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (image != null) {
        _image = File(image.path);
      } else {
        print('No image selected.');
      }
    });
  }

  void signUpUser() async {
    try {
      String profilePhoto = await uploadImage();
      await performLoading<UserCredential>(
        Auth()
            .createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
          name: fullName.text,
          photoUrl: profilePhoto,
        )
            .then((UserCredential? result) async {
          if (result == null) {
            return Future.error('Failed to sign in');
          } else {
            await Auth()
                .writeUserDetail(
                    fullName: fullName.text,
                    email: emailController.text,
                    photoUrl: profilePhoto,
                    password: BCrypt.hashpw(
                        passwordController.text, BCrypt.gensalt()))
                .then((value) {
              return result;
            });
          }
          return result;
        }),
        'Signing in...',
        'Successfully signed in!',
        'Failed to sign in',
      );
    } catch (e) {
      print(e);
    }
  }

  Future<String> uploadImage() async {
    File file = File(_image!.path);
    String fileExtension = extension(_image!.path);
    final filePath = 'user_profile_pic/${DateTime.now()}${fileExtension}';
    final ref = storage.ref().child(filePath);
    await ref.putFile(file);
    String downloadURL = await ref.getDownloadURL();
    return downloadURL;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          leading: IconButton(
            icon: Icon(Icons
                .arrow_back_ios_rounded), // change this to your desired icon
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          iconTheme: IconThemeData(
              color: Colors.black), // change this to your desired color
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.topLeft,
                          child: RichText(
                            text: const TextSpan(
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
                              "Let's create your account.",
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
                  Padding(
                    padding: const EdgeInsets.all(30),
                    child: SizedBox(
                      child: Column(
                        children: [
                          CustomFormWidget(
                            labelText: 'Full Name',
                            hintText: 'Enter your Full Name',
                            icon: Icons.person,
                            isPassword: false,
                            controller: fullName,
                            focusNode: fullNameFocusNode,
                          ),
                          const SizedBox(height: 10),
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
                          const SizedBox(height: 10),
                          CustomFormWidget(
                            labelText: 'Confirm Password',
                            hintText: 'Enter your password',
                            icon: Icons.lock,
                            isPassword: true,
                            controller: cPasswordController,
                            focusNode: cPasswordFocusNode,
                          ),
                          const SizedBox(height: 20),
                          Center(
                            child: Stack(
                              alignment: Alignment.center,
                              children: <Widget>[
                                CircleAvatar(
                                  backgroundColor: Colors.grey[200],
                                  radius: 60,
                                  backgroundImage: _image != null
                                      ? FileImage(_image!)
                                      : null,
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: IconButton(
                                    icon: Icon(Icons.camera_alt),
                                    onPressed: getImage,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () async {
                                if (fullName.text.isEmpty ||
                                    emailController.text.isEmpty ||
                                    passwordController.text.isEmpty ||
                                    cPasswordController.text.isEmpty ||
                                    _image == null) {
                                  EasyLoading.showError(
                                      'All fields are required');
                                } else if (passwordController.text !=
                                    cPasswordController.text) {
                                  EasyLoading.showError(
                                      'Password does not match');
                                } else if (!RegExp(
                                        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
                                    .hasMatch(passwordController.text)) {
                                  EasyLoading.showError(
                                      'Password must contain at least 8 characters, one uppercase, one lowercase, one number and one special character');
                                } else {
                                  signUpUser();
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: HexColor('#FB5D02'),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                elevation: 5.0,
                              ),
                              child: const Padding(
                                padding: EdgeInsets.all(15),
                                child: Text(
                                  'Register Account',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'OpenSans',
                                      color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
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
