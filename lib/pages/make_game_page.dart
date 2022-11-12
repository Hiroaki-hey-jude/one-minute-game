import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:timer_chellenge/helper/helper_function.dart';

import '../service/database_service.dart';
import '../widgets.dart/widgets.dart';

class MakeGamePage extends StatefulWidget {
  const MakeGamePage({
    super.key,
  });

  @override
  State<MakeGamePage> createState() => _MakeGamePageState();
}

class _MakeGamePageState extends State<MakeGamePage> {
  String userName = '';
  String roomName = '';
  String admin = '';
  bool _isLoading = false;
  QuerySnapshot? searchSnapShot;
  Stream<QuerySnapshot>? streamSnapshot;

  @override
  void initState() {
    super.initState();
    getUserName();
    //getStreamSnapshot();
  }

  getUserName() async {
    setState(() {
      _isLoading = true;
    });
    await HelperFunction.getUserNameFromSF().then(
      (value) => {
        setState(() {
          userName = value!;
          print('masaka');
          print(userName);
        })
      },
    );
    getAdmin();

    await DataBaseService().searchByAdmin(admin).then((snapshot) {
      setState(() {
        searchSnapShot = snapshot;
        print('ナナ垢');
        print(searchSnapShot!.docs[1]['roomKey']);
      });
    });
    setState(() {
      _isLoading = false;
    });
  }

  String getName(String r) {
    return r.substring(r.indexOf('_') + 1);
  }

  getAdmin() {
    setState(() {
      admin = '${FirebaseAuth.instance.currentUser!.uid}_$userName';
      print('admin');
      print(admin);
    });
  }

  // getStreamSnapshot() {
  //   DataBaseService().getRoomCollection().then((snapshot) {
  //     setState(() {
  //       print('ここ来てる');
  //       streamSnapshot = snapshot;
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.cyan,
        elevation: 0,
        onPressed: () {
          popUpDialog(context);
        },
        child: Icon(Icons.add),
      ),
      body: _isLoading
          ? Center(
              child: Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor,
                ),
              ),
            )
          : roomList(),
    );
  }

  roomList() {
    return SafeArea(
      child: Column(
        children: [
          const Text(
            'ルーム名',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const Divider(height: 20),
          Expanded(
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('rooms')
                    .where('admin', isEqualTo: admin)
                    .snapshots(),
                builder: (context, AsyncSnapshot snapshot) {
                  return snapshot.hasData
                      ? ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data.docs.length,
                          itemBuilder: ((context, index) {
                            return groupTile(
                              getName(admin),
                              snapshot.data!.docs[index]['roomName'],
                            );
                          }),
                        )
                      : Container();
                }),
          ),
        ],
      ),
    );
  }

  Widget groupTile(String admin, String roomName) {
    return ListTile(
        shape: RoundedRectangleBorder(side: BorderSide(color: Colors.black12)),
        title:
            Text(roomName, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(admin));
  }

  popUpDialog(context) {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: const Text(
              'ルームを作成する',
              textAlign: TextAlign.left,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _isLoading == true
                    ? Center(
                        child: CircularProgressIndicator(
                          color: Theme.of(context).primaryColor,
                        ),
                      )
                    : TextField(
                        onChanged: (val) {
                          setState(() {
                            roomName = val;
                          });
                        },
                        style: const TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).primaryColor,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.red,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).primaryColor,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      )
              ],
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor),
                child: const Text('キャンセル'),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (roomName != '') {
                    setState(() {
                      _isLoading = true;
                    });
                    DataBaseService(uid: FirebaseAuth.instance.currentUser!.uid)
                        .createRoom(userName,
                            FirebaseAuth.instance.currentUser!.uid, roomName)
                        .whenComplete(() {
                      _isLoading = false;
                    });
                    showSnackBar(context, Colors.green, 'ルームを作成しました');
                    Navigator.pop(context);
                    setState(() {
                      _isLoading = false;
                    });
                  } else {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('ルームの名前を入力してください')));
                  }
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor),
                child: const Text('作成'),
              ),
            ],
          );
        });
      },
    );
  }
}
