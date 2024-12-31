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
  Map<String, dynamic>? _editedMessage;
  bool _isEditMessage = false;

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
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut,
      );
    }
  }

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatServices.sendMessage(
          widget.recieverID, _messageController.text);

      _messageController.clear();
    }

    scrollDown();
  }

  void editMessage() async {
    if (_messageController.text.isNotEmpty) {
      _editedMessage?['message'] = _messageController.text;
      await _chatServices.editMessage(_editedMessage!);
      _resetEditMessage();
    }
  }

  void _setEditedMessage(Map<String, dynamic> data) {
    _messageController.text = data['message'];
    _editedMessage = data;
    setState(() {
      _isEditMessage = true;
    });
  }

  void _resetEditMessage() {
    _messageController.clear();
    _editedMessage = null;
    setState(() {
      _isEditMessage = false;
    });
  }

  void showDeleteMessage(BuildContext context, Map<String, dynamic> message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Bu mesaj silinecek'),
          content: Text('Mesajı silmek istediğinizden emin misiniz?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('iptal'),
            ),
            TextButton(
              onPressed: () {
                deleteMessage(message);
                Navigator.of(context).pop();
              },
              child: Text('Sil', style: TextStyle(color: Colors.red.shade700)),
            ),
          ],
        );
      },
    );
  }

  void deleteMessage(Map<String, dynamic> message) {
    _chatServices.deleteMessage(message);
  }

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
                onTap: () => _setEditedMessage(data),
                child: Icon(
                  Icons.edit,
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () => showDeleteMessage(context, data),
                child: Icon(
                  Icons.delete,
                  size: 18,
                ),
              )
            ]
          : [
              GestureDetector(
                onTap: () => _messageController.text = data['message'],
                child: Icon(
                  Icons.edit,
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              Icon(
                Icons.delete,
                size: 18,
              ),
              ChatBubble(message: data['message'], isCurrentUser: isCurrentUser)
            ],
    );
  }

  Widget _buildMessageInput() {
    return WillPopScope(
      onWillPop: () async {
        bool pop = !_isEditMessage;

        _resetEditMessage();
        return pop;
      },
      child: Padding(
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
            _isEditMessage
                ? Container(
                    decoration: BoxDecoration(
                        color: Colors.green.shade600, shape: BoxShape.circle),
                    margin: EdgeInsets.only(right: 25.0),
                    child: IconButton(
                        onPressed: editMessage,
                        icon: Icon(Icons.check, color: Colors.white)),
                  )
                : Container(
                    decoration: BoxDecoration(
                        color: Colors.green.shade600, shape: BoxShape.circle),
                    margin: EdgeInsets.only(right: 25.0),
                    child: IconButton(
                        onPressed: sendMessage,
                        icon: Icon(Icons.send, color: Colors.white)),
                  )
          ],
        ),
      ),
    );
  }
}
