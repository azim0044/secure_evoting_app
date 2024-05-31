import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<UserCredential?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      return userCredential;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<UserCredential?> createUserWithEmailAndPassword(
      {required email,
      required password,
      required name,
      required photoUrl}) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      await userCredential.user!.updateDisplayName(name);
      await userCredential.user!.updatePhotoURL(photoUrl);
      return userCredential;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<bool> writeUserDetail(
      {required fullName,
      required email,
      required photoUrl,
      required password}) async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    try {
      await users.doc(_auth.currentUser!.uid).set(
        {
          'full_name': fullName,
          'email': email,
          'photo_url': photoUrl,
          'password': password,
          'userReference': false,
          'aes_key': '',
        },
      );
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
