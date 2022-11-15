import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:timer_chellenge/pages/room_info_page.dart';
import 'package:timer_chellenge/service/database_service.dart';

import '../widgets.dart/widgets.dart';

class AdminGamePage extends StatefulWidget {
  final String roomId;
  final String admin;
  final String roomName;
  final String roomKey;
  const AdminGamePage(
      {super.key,
      required this.roomId,
      required this.admin,
      required this.roomName,
      required this.roomKey});

  @override
  State<AdminGamePage> createState() => _AdminGamePageState();
}

class _AdminGamePageState extends State<AdminGamePage> {
  Stream? members;
  String imageProfile = '';
  String urlOfProfilePic = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMembers();
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

  String getName(String r) {
    return r.substring(r.indexOf('_') + 1);
  }

  String getId(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  @override
  Widget build(BuildContext context) {
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
                      admin: widget.admin,
                    ));
              },
              icon: const Icon(Icons.info))
        ],
      ),
      body: Center(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          //crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
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
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Theme.of(context).primaryColor.withOpacity(0.4),
                  minimumSize: const Size(100, 50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0)),
                ),
                child: const FittedBox(
                  child: Text(
                    'START',
                    style: TextStyle(fontSize: 20),
                  ),
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              '参加者',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
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
                          print(getName(snapshot.data['members'][index]) +
                              ' nameだ');
                          print(index);
                          print('streambiulder終わり');
                          DataBaseService()
                              .searchByRoomId(
                                  getId(snapshot.data['members'][index]))
                              .then((val) {
                            setState(() {
                              print(index);
                              print('setstateの中');
                              urlOfProfilePic = val;
                            });
                          }).catchError((e) {
                            urlOfProfilePic =
                                'https://msp.c.yimg.jp/images/v2/FUTi93tXq405grZVGgDqGx5cm8knTLo61O84kVTxOan841a30-aIJSoqkmlQNsP4-Qv0KVqX9M9vYFUiwJk7Td3V7vPM0KOdWqrUituYvtnSar9x6L84qPLmIBtWCypFJz0KXlr7qn7fBK3IAzXNoKqa8nXN1Pz9ov4LKOTDRDV8wVWo1nQMCGO9E4o6K36McUAylQDeTQRNF9Op3JfY2iTFAun4IWDGV3qwbY8bHxZl4xSjUUv4fCzYvGjh2ca9bpeFmXd2K-uN80LrsmWEALH9sYrv73X1ZPxpgNLPBEe_7WG2Ffw6G1V4ZRj10gSJAhhlIWmL3Dppp79xAsruIw==/800px-Solid_blue.svg.png?errorImage=false';
                            print(e);
                          });
                          return ListTile(
                            tileColor: const Color(0xFFCEE5FF),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              ),
                            ),
                            leading: CircleAvatar(
                              radius: 30,
                              backgroundImage: urlOfProfilePic == ''
                                  ? null
                                  : NetworkImage(urlOfProfilePic),
                            ),
                            title: Text(
                              getName(snapshot.data['members'][index]),
                            ),
                            trailing: Text(index.toString()),
                          );
                        },
                      ),
                    );
                  } else {
                    return const Text("NO MEMBERSss");
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
}
