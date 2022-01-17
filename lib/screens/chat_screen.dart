import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Test App',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          DropdownButton(
            underline: Container(),
            icon: const Icon(
              Icons.more_vert,
              color: Colors.amber,
            ),
            items: [
              DropdownMenuItem<String>(
                child: Row(
                  children: const [
                    Icon(
                      Icons.logout,
                      color: Colors.black,
                    ),
                    SizedBox(width: 10),
                    Text('Logout'),
                  ],
                ),
                value: 'Logout',
              ),
            ],
            onChanged: (val) async {
              if (val == 'Logout') await FirebaseAuth.instance.signOut();
            },
          )
        ],
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('chats/sWNNCBpul4xICHSeH2kA/messeges')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            final docs = snapshot.data!.docs;
            return ListView.builder(
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  return Text(
                    docs[index]['text'],
                    style: const TextStyle(fontSize: 35),
                  );
                });
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          FirebaseFirestore.instance
              .collection('chats/sWNNCBpul4xICHSeH2kA/messeges')
              .add({'text': 'Button Text'});
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
