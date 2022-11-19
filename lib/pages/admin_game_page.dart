import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:timer_chellenge/pages/playing_game_page.dart';
import 'package:timer_chellenge/pages/room_info_page.dart';
import 'package:timer_chellenge/service/database_service.dart';

import '../widgets.dart/widgets.dart';

class AdminGamePage extends StatefulWidget {
  final String roomId;
  final String userName;
  final String roomName;
  final String roomKey;
  const AdminGamePage({
    super.key,
    required this.roomId,
    required this.userName,
    required this.roomName,
    required this.roomKey,
  });

  @override
  State<AdminGamePage> createState() => _AdminGamePageState();
}

class _AdminGamePageState extends State<AdminGamePage> {
  Stream? members;
  String imageProfile = '';
  String urlOfProfilePic = '';
  List<String> urls = [];
  bool? isAdmin;
  bool _isloading = false;

  String getName(String r) {
    return r.substring(r.indexOf('_') + 1);
  }

  String getId(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  @override
  void initState() {
    super.initState();
    getMembers();
    adminOrNot();
  }

  getMembers() async {
    DataBaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getRoomMembers(widget.roomId)
        .then((val) {
      setState(() {
        members = val;
      });
    });
  }

  adminOrNot() {
    print(widget.roomId);
    String adminFirestore = '';
    DataBaseService().getAdminByRoomId(widget.roomId).then((val) {
      adminFirestore = val;
      print(adminFirestore + '------>');
      print(widget.userName + '----->widget.userName');
      if (adminFirestore == widget.userName) {
        print('キタキタ');
        setState(() {
          isAdmin = true;
        });
        print('adminだああああああああ');
      } else {
        setState(() {
          isAdmin = false;
        });
        if (isAdmin == null) {
          print('nulllllllll');
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isAdmin == null) {
      backgroundColor:
      Colors.grey[300];
      return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Theme.of(context).primaryColor,
          centerTitle: true,
          title: Text(widget.roomName),
          actions: [
            IconButton(
                onPressed: () {
                  nextScreen(
                      context,
                      RoomInfoPage(
                        roomId: widget.roomId,
                        roomName: widget.roomName,
                        admin: widget.userName,
                      ));
                },
                icon: const Icon(Icons.info))
          ],
        ),
        body: const Center(
          child: CircularProgressIndicator(
            color: Colors.grey,
          ),
        ),
      );
    }
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        title: Text(widget.roomName),
        actions: [
          IconButton(
              onPressed: () {
                nextScreen(
                    context,
                    RoomInfoPage(
                      roomId: widget.roomId,
                      roomName: widget.roomName,
                      admin: widget.userName,
                    ));
              },
              icon: const Icon(Icons.info))
        ],
      ),
      body: isAdmin == true
          ? Center(
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                    //color: Colors.white,
                    child: GestureDetector(
                      onTap: () async {
                        await Clipboard.setData(
                          ClipboardData(text: widget.roomKey),
                        );
                      },
                      child: Text(
                        widget.roomKey,
                        style: const TextStyle(
                          fontSize: 50,
                          letterSpacing: 0.15,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    child: ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          _isloading = true;
                        });
                        await FirebaseFirestore.instance
                            .collection('rooms')
                            .doc(widget.roomId)
                            .update({
                          'hasGameStarted': true,
                        });
                        setState(() {
                          _isloading = true;
                        });
                        nextScreenReplacement(context, PlayingGamePage(isAdmin: isAdmin, roomId: widget.roomId, userName: widget.userName,));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Theme.of(context).primaryColor.withOpacity(0.4),
                        minimumSize: const Size(100, 50),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32.0)),
                      ),
                      child: const FittedBox(
                        child: Text(
                          '参加者を締め切る',
                          style: TextStyle(fontSize: 20),
                        ),
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  const Text(
                    '参加者',
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 10),
                  StreamBuilder(
                    stream: members,
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data['members'].length != 0) {
                          return SingleChildScrollView(
                            child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: snapshot.data['members'].length,
                              itemBuilder: (context, index) {
                                return participantTiles(
                                  getId(snapshot.data['members'][index]),
                                  snapshot.data['members'][index],
                                  index,
                                );
                              },
                            ),
                          );
                        } else {
                          return const Text("友達にルームキーを教えよう！");
                        }
                      } else {
                        return const Text("NO MEMBERS");
                      }
                    },
                  )
                ],
              ),
            )
          : Center( //adminじゃない
              child: Column(
                children: [
                  const SizedBox(height: 15),
                  const Text(
                    'ゲームが始まるまで少々お待ちください',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 25),
                  const Text(
                    '参加者',
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 15),
                  StreamBuilder(
                    stream: members,
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data['hasGameStarted'] == true) {
                          Future.delayed(Duration(seconds: 1), (() {
                            nextScreenReplacement(
                              context,
                              PlayingGamePage(
                                  isAdmin: isAdmin, roomId: widget.roomId, userName: widget.userName));
                          }));
                        }
                        if (snapshot.data['members'].length != 0) {
                          return SingleChildScrollView(
                            child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: snapshot.data['members'].length,
                              itemBuilder: (context, index) {
                                return participantTiles(
                                  getId(snapshot.data['members'][index]),
                                  snapshot.data['members'][index],
                                  index,
                                );
                              },
                            ),
                          );
                        } else {
                          return const Text("友達にルームキーを教えよう！");
                        }
                      } else {
                        return const Text("NO MEMBERS");
                      }
                    },
                  )
                ],
              ),
            ),
    );
  }

  participantTiles(String roomId, String userName, int index) {
    print('hihihi->3');
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: ListTile(
        tileColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        leading: profilePicturesWidget(userName),
        title: Text(
          getName(userName),
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  // Widget profilePicturesWidget(String userName) {
  //   return SizedBox(
  //     height: 50,
  //     width: 50,
  //     child: StreamBuilder(
  //         stream: FirebaseFirestore.instance
  //             .collection('users')
  //             .doc(getId(userName))
  //             .snapshots(),
  //         builder: (context, snapshot) {
  //           if (snapshot.connectionState == ConnectionState.waiting)
  //             return Center(child: CircularProgressIndicator());
  //           String originalImgURL = snapshot.data!.get('profilePic')
  //                       as String !=
  //                   ''
  //               ? snapshot.data!.get('profilePic') as String
  //               : 'https://msp.c.yimg.jp/images/v2/FUTi93tXq405grZVGgDqGx5cm8knTLo61O84kVTxOan841a30-aIJSoqkmlQNsP4-Qv0KVqX9M9vYFUiwJk7Td3V7vPM0KOdWqrUituYvtnSar9x6L84qPLmIBtWCypFJz0KXlr7qn7fBK3IAzXNoKqa8nXN1Pz9ov4LKOTDRDV8wVWo1nQMCGO9E4o6K36McUAylQDeTQRNF9Op3JfY2iTFAun4IWDGV3qwbY8bHxZl4xSjUUv4fCzYvGjh2ca9bpeFmXd2K-uN80LrsmWEALH9sYrv73X1ZPxpgNLPBEe_7WG2Ffw6G1V4ZRj10gSJAhhlIWmL3Dppp79xAsruIw==/800px-Solid_blue.svg.png?errorImage=false';
  //           print(originalImgURL);
  //           return CircleAvatar(
  //             radius: 30,
  //             backgroundImage: NetworkImage(originalImgURL),
  //           );
  //         }),
  //   );
  // }
}
