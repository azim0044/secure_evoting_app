// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, unused_element

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:secure_evoting_app/feautures/auth/services/auth.dart';
import 'package:secure_evoting_app/shared/widget/easy_loading_custom.dart';
import 'package:secure_evoting_app/shared/widget/form_filed.dart';
import 'package:bcrypt/bcrypt.dart';

class UpdateProfileWidget extends StatefulWidget {
  const UpdateProfileWidget({super.key});

  @override
  _UpdateProfileWidgetState createState() => _UpdateProfileWidgetState();
}

class _UpdateProfileWidgetState extends State<UpdateProfileWidget> {
  TextEditingController oldPassword = TextEditingController();
  TextEditingController newPassword = TextEditingController();
  TextEditingController cPassword = TextEditingController();

  FocusNode oldPasswordFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  FocusNode cPasswordFocusNode = FocusNode();

  final storage = FirebaseStorage.instance;

  @override
  void initState() {
    super.initState();
  }

  void _updateUserPassword() async {
    try {
      await performLoading<void>(
        updatePassword(),
        'Checking old password...',
        'Password updated successfully!',
      );
    } catch (e) {
      EasyLoading.showError(
          e is Exception ? e.toString().split('Exception: ')[1] : e.toString());
    }
  }

  Future<bool> updatePassword() async {
    FirebaseFirestore _db = FirebaseFirestore.instance;
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: Auth().currentUser!.email!,
        password: oldPassword.text,
      );
      if (userCredential.user != null) {
        try {
          await userCredential.user!.updatePassword(newPassword.text);
          await _db.collection('users').doc(Auth().currentUser!.uid).update({
            '`password`': BCrypt.hashpw(newPassword.text, BCrypt.gensalt())
          });
          return true;
        } on FirebaseAuthException catch (e) {
          if (e.code == 'weak-password') {
            throw Exception('Password must be at least 6 characters');
          } else {
            throw Exception(
                'An unknown error occusssdsdrred while updating the password');
          }
        }
      } else {
        throw Exception('Old password is incorrect');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        throw Exception('Old password is incorrect');
      } else {
        throw Exception('Old password is incorrect');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_rounded),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text(
            "Update Password",
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
                  Padding(
                    padding: const EdgeInsets.all(30),
                    child: SizedBox(
                      child: Column(
                        children: [
                          const SizedBox(height: 70),
                          CustomFormWidget(
                            labelText: 'Old Password',
                            hintText: 'Enter your password',
                            icon: Icons.lock,
                            isPassword: true,
                            controller: oldPassword,
                            focusNode: oldPasswordFocusNode,
                          ),
                          const SizedBox(height: 10),
                          CustomFormWidget(
                            labelText: 'New Password',
                            hintText: 'Enter your password',
                            icon: Icons.lock,
                            isPassword: true,
                            controller: newPassword,
                            focusNode: passwordFocusNode,
                          ),
                          const SizedBox(height: 10),
                          CustomFormWidget(
                            labelText: 'Confirm Password',
                            hintText: 'Enter your password',
                            icon: Icons.lock,
                            isPassword: true,
                            controller: cPassword,
                            focusNode: cPasswordFocusNode,
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () async {
                                _updateUserPassword();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueAccent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                elevation: 5.0,
                              ),
                              child: const Padding(
                                padding: EdgeInsets.all(15),
                                child: Text(
                                  'Update',
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
          ]),
        ));
  }
}
