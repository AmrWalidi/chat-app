import 'package:chat_app/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<List<Map<String, dynamic>>> getUserStream() {
    return _firestore.collection("Users").snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final user = doc.data();

        return user;
      }).toList();
    });
  }

  Future<void> sendMessage(String recieverID, message) async {
    final currentUserID = _auth.currentUser!.uid;
    final currentUserEmail = _auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();

    Message newMsg = Message(
        senderID: currentUserID,
        senderEmail: currentUserEmail,
        recieverID: recieverID,
        message: message,
        timestamp: timestamp);

    List<String> ids = [currentUserID, recieverID];
    ids.sort();

    String chatRoomID = ids.join("_");

    await _firestore
        .collection('chat_rooms')
        .doc(chatRoomID)
        .collection('messages')
        .add(newMsg.toMap());
  }

  Stream<QuerySnapshot> getMessages(String userID, otherUserId) {
    List<String> ids = [userID, otherUserId];
    ids.sort();

    String chatRoomID = ids.join("_");

    return _firestore
        .collection('chat_rooms')
        .doc(chatRoomID)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  Future<void> editMessage(Map<String, dynamic> message) async {
    List<String> ids = [message['senderID'], message['recieverID']];
    ids.sort();

    String chatRoomID = ids.join("_");
    var snapshot = await _firestore
        .collection('chat_rooms')
        .doc(chatRoomID)
        .collection('messages')
        .where('timestamp', isEqualTo: message['timestamp'])
        .get();

    var docId = snapshot.docs.first.id;
    await _firestore
        .collection('chat_rooms')
        .doc(chatRoomID)
        .collection('messages')
        .doc(docId)
        .update({
      'message': message['message'],
    });
  }

  Future<void> deleteMessage(Map<String, dynamic> message) async {
    List<String> ids = [message['senderID'], message['recieverID']];
    ids.sort();

    String chatRoomID = ids.join("_");
    var snapshot = await _firestore
        .collection('chat_rooms')
        .doc(chatRoomID)
        .collection('messages')
        .where('timestamp', isEqualTo: message['timestamp'])
        .get();

    var docId = snapshot.docs.first.id;
    await _firestore
        .collection('chat_rooms')
        .doc(chatRoomID)
        .collection('messages')
        .doc(docId)
        .delete();
  }
}
