import 'package:chat_app/authenication%20page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Bottomchatbar.dart';

class Homescreen extends StatelessWidget {
  const Homescreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: Text(user!.displayName!),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[Colors.red, Colors.blue])),
        ),
        actions: [
          TextButton(
            onPressed: () {
              AuthProvider().signOut();
            },
            child: const Icon(
              Icons.exit_to_app,
              size: 32,
              color: Colors.orangeAccent,
            ),
          )
        ],
      ),
      body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[Color(0xfffc575e), Color(0xff90d5ec)]),
          ),
          padding: const EdgeInsets.all(4),
          child: Column(
            children: [
              Chats(),
              const BottomChatBar(),
            ],
          )),
    );
  }
}

class Chats extends StatelessWidget {
  Chats({Key? key}) : super(key: key);
  final user = FirebaseAuth.instance.currentUser;
  final Stream<QuerySnapshot> _chatScreen = FirebaseFirestore.instance
      .collection('chats')
      .orderBy('createdAt', descending: false)
      .limit(15)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _chatScreen,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text(" ${snapshot.error}"),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        return Flexible(
          child: GestureDetector(
            child: ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot doc) {
                Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
                if (user?.uid == data['owner']) {
                  return sendMessage(data: data);
                } else {
                  return ReceivedMessage(data: data);
                }
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}

// ignore: camel_case_types
class sendMessage extends StatelessWidget {
  const sendMessage({Key? key, required this.data}) : super(key: key);
  final Map<String, dynamic> data;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: 20,
          ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[Color(0xff20bf55), Color(0xff01baef)]),
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    data['text'],
                    textAlign: TextAlign.right,
                  ),
                ),
                const SizedBox(
                  width: 12,
                ),
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(
                    data['image'],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ReceivedMessage extends StatelessWidget {
  const ReceivedMessage({Key? key, required this.data}) : super(key: key);
  final Map<String, dynamic> data;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: 20,
          ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[Color(0xfffc575e), Color(0xff90d5ec)]),
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(
                    data['image'],
                  ),
                ),
                SizedBox(
                  width: 12,
                ),
                Flexible(
                  child: Text(
                    data['text'],
                    textAlign: TextAlign.right,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
