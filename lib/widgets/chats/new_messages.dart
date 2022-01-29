import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({Key? key}) : super(key: key);

  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final controller = TextEditingController();
  String enteredText = '';
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
              child: TextField(
            controller: controller,
            decoration: const InputDecoration(labelText: 'Send a message...'),
            onChanged: (val) {
              setState(() {
                enteredText = val;
              });
            },
          )),
          IconButton(
            color: Theme.of(context).primaryColor,
            onPressed: enteredText.trim().isNotEmpty ? sendMessage : null,
            icon: const Icon(Icons.send),
          )
        ],
      ),
    );
  }

  void sendMessage() async {
    final currentUser = await FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser?.uid)
        .get();
    FocusScope.of(context).unfocus();
    await FirebaseFirestore.instance.collection('chats').add({
      'text': enteredText,
      'createdAt': Timestamp.now(),
      'userName': userData['userName'],
      'userId': currentUser?.uid,
    });
    controller.clear();
    setState(() {
      enteredText = '';
    });
  }
}
