import 'package:addictx/SplashScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<bool> addChatRoom(chatRoom, chatRoomId) {
  chatRoomReference
      .doc(chatRoomId)
      .update(chatRoom)
      .catchError((e) {
    print(e);
  });
}


Future<void> addMessages(String chatRoomId, chatMessageData){

  chatRoomReference
      .doc(chatRoomId)
      .collection("chats")
      .add(chatMessageData).catchError((e){
    print(e.toString());
  });
}


getChatRoomStream(String chatRoomId) async{
  return chatRoomReference
      .where("chatRoomId",isEqualTo: chatRoomId)
      .snapshots();
}
deleteChats(int index, var snapshot) async{
  await FirebaseFirestore.instance.runTransaction((Transaction myTransaction) async{
    await myTransaction.delete(snapshot.data.documents[index].reference);
  });
}