import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BottomChatBar extends StatefulWidget {
  const BottomChatBar({Key? key}) : super(key: key);

  @override
  State<BottomChatBar> createState() => _BottomChatBarState();
}

class _BottomChatBarState extends State<BottomChatBar> {
  final textController = TextEditingController();

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  final user = FirebaseAuth.instance.currentUser;
  CollectionReference chatRef = FirebaseFirestore.instance.collection('chats');

  Future sendMessage() async {
    if (textController.text.isNotEmpty) {
      if (textController.text.length < 40) {
        try {
          return chatRef.doc().set(
            {
              "text": textController.text,
              "owner": user?.uid,
              "image": user?.photoURL,
              "createdAt": FieldValue.serverTimestamp()
            },
          ).then((value) => {
                textController.clear(),
              });
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                e.toString(),
              ),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Must be 40 character or less"),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Must be 40 character or less"),
        ),
      );
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[Color(0xfffc575e), Color(0xff90d5ec)]),
      ),
      width: MediaQuery.of(context).size.width,
      child: Align(
        alignment: Alignment.center,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.symmetric(horizontal: 15.0),
              constraints: const BoxConstraints(maxWidth: 275),
              child: TextField(
                cursorColor: Colors.lightBlue,
                controller: textController,
                textAlign: TextAlign.left,
                textAlignVertical: TextAlignVertical.center,
                keyboardType: TextInputType.text,
                onEditingComplete: sendMessage,
                decoration: const InputDecoration(
                  filled: true,
                  labelText: 'Enter Message',
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  contentPadding: EdgeInsets.only(
                    left: 20,
                    right: 10,
                    top: 0,
                    bottom: 0,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 45,
              width: 50,
              child: FloatingActionButton(
                onPressed: sendMessage,
                elevation: 8,
                backgroundColor: Colors.lightBlue,
                child: const Center(
                  child: Icon(
                    Icons.send,
                    size: 30,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
