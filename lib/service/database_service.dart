import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io' as io;

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

  getProfilePic(String uid) async {
    DocumentReference d = userCollection.doc(uid);
    DocumentSnapshot documentSnapshot = await d.get();
    return documentSnapshot['profilePic'];
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
      'roomKey': rndnumber,
      'hasGameStarted': false
    });
    //update the members
    await roomDocumentReference.update({
      //'members': FieldValue.arrayUnion(['${uid}_$userName']),
      'roomId': roomDocumentReference.id
    });
    DocumentReference userDocumentReference = userCollection.doc(id);
    return await userDocumentReference.update({
      'rooms': FieldValue.arrayUnion(['${roomDocumentReference.id}_$roomName']),
    });
  }

  Future addMemberToRoomInFirestore(
      String id, String userName, String roomId) async {
    DocumentReference roomDocumentReference = roomCollection.doc(roomId);
    return await roomDocumentReference.update({
      'members': FieldValue.arrayUnion(['${id}_$userName']),
    });
  }

  getRoomCollection() {
    return roomCollection.get();
  }

  getRoomMembers(roomId) async {
    return roomCollection.doc(roomId).snapshots();
  }

  //get user groups
  getUserRoom() async {
    return userCollection.doc(uid).snapshots();
  }

  searchByKey(String roomKey) {
    return roomCollection.where('roomKey', isEqualTo: roomKey).get();
  }

  searchByRoomId(String roomId) async {
    DocumentSnapshot docSnapshot = await userCollection.doc(roomId).get();
    return docSnapshot.get('profilePic') as String;
  }

  getAdminByRoomId(String roomId) async {
    DocumentSnapshot docSnapshot = await roomCollection.doc(roomId).get();
    print(docSnapshot.get('admin') + '->adminです');
    return docSnapshot.get('admin');
  }

  searchByAdmin(String admin) {
    print(admin + 'アドミン');
    return roomCollection.where('admin', isEqualTo: admin).get();
  }

  Future<String?> selectIcon(BuildContext context) async {
    const String selectIcon = "アイコンを選択";
    const List<String> SELECT_ICON_OPTIONS = ["写真から選択", "写真を撮影"];
    const int cameraRoll = 0;
    const int camera = 1;
    var selectType = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text(selectIcon),
            children: SELECT_ICON_OPTIONS.asMap().entries.map((e) {
              return SimpleDialogOption(
                child: ListTile(
                  title: Text(e.value),
                ),
                onPressed: () => Navigator.of(context).pop(e.key),
              );
            }).toList(),
          );
        });

    final picker = ImagePicker();
    var _img_src;

    if (selectType == null) {
      return null;
    }
    //カメラで撮影
    else if (selectType == camera) {
      _img_src = ImageSource.camera;
    }
    //ギャラリーから選択
    else if (selectType == cameraRoll) {
      _img_src = ImageSource.gallery;
    }

    final pickedFile = await picker.pickImage(source: _img_src);

    if (pickedFile == null) {
      return null;
    } else {
      return pickedFile.path;
    }
  }

  Future<void> uploadFile(String sourcePath, String uploadFileName) async {
    final FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage.ref().child("images"); //保存するフォルダ

    io.File file = io.File(sourcePath);
    UploadTask task = ref.child(uploadFileName).putFile(file);

    try {
      var snapshot = await task;
    } catch (FirebaseException) {
      //エラー処理
      print(FirebaseException);
      print('アップロードできてない');
    }
  }
}
