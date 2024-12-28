import 'package:chat_app/components/my_text_field.dart';
import 'package:chat_app/services/auth/auth_service.dart';
import 'package:chat_app/services/chat/chat_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Chat extends StatelessWidget {
  Chat({super.key, required this.recieverEmail, required this.recieverID});

  final String recieverEmail;
  final String recieverID;

  final TextEditingController _messageController = TextEditingController();

  final _authSevices = AuthService();
  final _chatServices = ChatServices();

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatServices.sendMessage(recieverID, _messageController.text);

      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(recieverEmail),
      ),
      body: Column(
        children: [Expanded(child: _buildMessageList()), _buildUserInput()],
      ),
    );
  }

  Widget _buildMessageList() {
    String senderID = _authSevices.getCurrentUser()!.uid;

    return StreamBuilder(
        stream: _chatServices.getMessages(senderID, recieverID),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Hata');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text('Yükleniyor');
          }

          return ListView(
            children: snapshot.data!.docs
                .map((doc) => _buildMessageItem(doc))
                .toList(),
          );
        });
  }

  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    bool isCurrentUser = data['senderID'] == _authSevices.getCurrentUser()!.uid;

    var aligment = isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

    return Container(alignment: aligment, child: Text(data['message']));
  }

  Widget _buildUserInput() {
    return Row(
      children: [
        Expanded(
            child: MyTextField(
                hinText: 'Bir mesaj Yazınız',
                obscureText: false,
                controller: _messageController)),
        IconButton(onPressed: sendMessage, icon: Icon(Icons.send))
      ],
    );
  }
}
