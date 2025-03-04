import 'package:Chat_chate/components/ChatBubble.dart';
import 'package:Chat_chate/components/Text_field.dart';
import 'package:Chat_chate/pages/chat/chatService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class chatpage extends StatefulWidget {
  final String receiverEmail;
  final String receiverId;

  const chatpage(
      {super.key, required this.receiverEmail, required this.receiverId});

  @override
  State<chatpage> createState() => _chatpageState();
}

class _chatpageState extends State<chatpage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void SendMessages() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(
          widget.receiverId, _messageController.text);
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,

      appBar: AppBar(
        title: Text(widget.receiverEmail,style: TextStyle(fontFamily: 'Ostrich',fontSize:20,letterSpacing: 2,fontWeight: FontWeight.bold,),),
        centerTitle: true,
        backgroundColor: Colors.black12,
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildMessageList(),
          ),
          _buildMessageInput(),
          const SizedBox(height: 25,),
        ],
      ),
    );
  }
  // build message List

  Widget _buildMessageList() {
    return StreamBuilder(
        stream: _chatService.getMessages(
            widget.receiverId, _firebaseAuth.currentUser!.uid),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error${snapshot.error}');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text('Loading..');
          }

          return ListView(
            children: snapshot.data!.docs
                .map((document) => _buildMessageItem(document))
                .toList(),
          );
        });
  }

  //build message Item
  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    //alignment
    var alignment = (data['senderId'] == _firebaseAuth.currentUser!.uid)
        ? Alignment.centerRight
        : Alignment.centerLeft;
    return Container(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment:
              (data['senderId'] == _firebaseAuth.currentUser!.uid)
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.end,
          mainAxisAlignment:
              (data['senderId'] == _firebaseAuth.currentUser!.uid)
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start,
          children: [
            // Text(data['senderEmail']),
            SizedBox(height: 7,),
            ChatBubble(message: data['message']),
          ],
        ),
      ),
    );
  }

  //build message Input
  Widget _buildMessageInput() {

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10,),
      child: Row(
        children: [
          Expanded(
            child: Container(
              color: Colors.grey,


                child: MyTextField(
                  controller: _messageController,
                  hinttext: 'Enter message',
                  unknowntext: false,
                  // obscureText: false,
                ),
              ),
            ),

          SizedBox(width: 5),
          Card(
            color: Colors.grey,
            elevation: 10,
            child: Container(
              decoration: BoxDecoration(
                color:Colors.grey,
                shape: BoxShape.circle,
              ),
              child: IconButton(

                  onPressed: SendMessages,
                  icon: Icon(
                    Icons.arrow_upward,
                    size: 30,
                  )),
            ),
          )
        ],
      ),
    );
  }
}
