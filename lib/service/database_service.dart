import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

class DataBaseService {
  final String? uid;
  DataBaseService({this.uid});
  var rndnumber = "";
  var rnd = Random();
  //reference for our collections
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference roomCollection =
      FirebaseFirestore.instance.collection('rooms');
  Future savingUserData(String name, String email) async {
    return await userCollection.doc(uid).set({
      'name': name,
      'email': email,
      'profilePic': '',
      'uid': uid,
      'roomName': '',
    });
  }

  //getting the user data
  Future gettingUserData(String email) async {
    QuerySnapshot querySnapshot =
        await userCollection.where('email', isEqualTo: email).get();
    return querySnapshot;
  }

  Future createRoom(String userName, String id, String roomName) async {
    for (var i = 0; i < 6; i++) {
      rndnumber = rndnumber + rnd.nextInt(9).toString();
    }
    DocumentReference roomDocumentReference = await roomCollection.add({
      'roomName': roomName,
      'admin': '${id}_$userName',
      'members': '',
      'roomId': '',
      'roomKey': rndnumber
    }
    );
    //update the members
    await roomDocumentReference.update({
      'members': FieldValue.arrayUnion(['${uid}_$userName']),
      'roomId': roomDocumentReference.id
    });
    DocumentReference userDocumentReference = userCollection.doc(id);
    return await userDocumentReference.update({
      'rooms':
          FieldValue.arrayUnion(['${roomDocumentReference.id}_$roomName']),
    });
  }

  //get user groups
  getUserRoom() async {
    return userCollection.doc(uid).snapshots();
  }

  searchByKey(String roomKey) {
    return roomCollection.where('roomKey', isEqualTo: roomKey).get();
  }
}
