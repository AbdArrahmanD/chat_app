import 'dart:io';

import 'package:chat_app/widgets/auth_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final auth = FirebaseAuth.instance;

  bool isLoading = false;

  void submitAuthForm(
    String email,
    String password,
    String userName,
    File image,
    bool isLogin,
    BuildContext context,
  ) async {
    // ignore: unused_local_variable
    UserCredential authResult;
    try {
      setState(() {
        isLoading = true;
      });
      if (isLogin) {
        authResult = await auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        authResult = await auth.createUserWithEmailAndPassword(
            email: email, password: password);
        final ref = FirebaseStorage.instance
            .ref()
            .child('usersImage')
            .child(authResult.user!.uid + '.jpg');
        await ref.putFile(image);
        final url = ref.getDownloadURL();
        await FirebaseFirestore.instance
            .collection('users')
            .doc(authResult.user!.uid)
            .set({
          'userName': userName,
          'password': password,
          'image_url': url,
        });
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        isLoading = false;
      });
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      } else if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      } else {
        setState(() {
          isLoading = false;
        });
        print('e : $e');
        Scaffold.of(context).showSnackBar(SnackBar(
          content: const Text('Faild,pleas try again.'),
          backgroundColor: Theme.of(context).errorColor,
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthForm(submitAuthForm, isLoading),
    );
  }
}
