import 'package:chat_app/components/chat_bubble.dart';
import 'package:chat_app/components/my_text_field.dart';
import 'package:chat_app/services/auth/auth_service.dart';
import 'package:chat_app/services/chat/chat_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Chat extends StatefulWidget {
  const Chat(
      {super.key, required this.recieverEmail, required this.recieverID});

  final String recieverEmail;
  final String recieverID;

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final TextEditingController _messageController = TextEditingController();

  final _authSevices = AuthService();
  final _chatServices = ChatServices();

  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        Future.delayed(Duration(milliseconds: 500), () => scrollDown());
      }
    });

    Future.delayed(Duration(microseconds: 500), () => scrollDown());
  }

  @override
  void dispose() {
    focusNode.dispose();
    _messageController.dispose();
    super.dispose();
  }

  final ScrollController _scrollController = ScrollController();
  void scrollDown() {
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: Duration(seconds: 1), curve: Curves.fastOutSlowIn);
  }

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatServices.sendMessage(
          widget.recieverID, _messageController.text);

      _messageController.clear();
    }

    scrollDown();
  }

  void editMessage(String text) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(widget.recieverEmail),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.green.shade500,
        elevation: 0,
      ),
      body: Column(
        children: [Expanded(child: _buildMessageList()), _buildMessageInput()],
      ),
    );
  }

  Widget _buildMessageList() {
    String senderID = _authSevices.getCurrentUser()!.uid;

    return StreamBuilder(
        stream: _chatServices.getMessages(senderID, widget.recieverID),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Hata');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text('Yükleniyor');
          }

          return Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: ListView(
              controller: _scrollController,
              children: snapshot.data!.docs
                  .map((doc) => _buildMessageItem(doc))
                  .toList(),
            ),
          );
        });
  }

  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    bool isCurrentUser = data['senderID'] == _authSevices.getCurrentUser()!.uid;

    var aligment =
        isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start;

    return Row(
      mainAxisAlignment: aligment,
      children: isCurrentUser
          ? [
              ChatBubble(
                  message: data['message'], isCurrentUser: isCurrentUser),
              GestureDetector(
                onTap: () => _messageController.text = data['message'],
                child: Icon(
                  Icons.edit,
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              Icon(
                Icons.delete,
                size: 20,
              )
            ]
          : [
              GestureDetector(
                onTap: () => _messageController.text = data['message'],
                child: Icon(
                  Icons.edit,
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              Icon(
                Icons.delete,
                size: 20,
              ),
              ChatBubble(message: data['message'], isCurrentUser: isCurrentUser)
            ],
    );
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 50.0),
      child: Row(
        children: [
          Expanded(
              child: MyTextField(
            hinText: 'Bir mesaj Yazınız',
            obscureText: false,
            controller: _messageController,
            focusNode: focusNode,
          )),
          Container(
            decoration: BoxDecoration(
                color: Colors.green.shade600, shape: BoxShape.circle),
            margin: EdgeInsets.only(right: 25.0),
            child: IconButton(
                onPressed: sendMessage,
                icon: Icon(Icons.send, color: Colors.white)),
          )
        ],
      ),
    );
  }
}
