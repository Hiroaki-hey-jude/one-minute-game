import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:timer_chellenge/pages/pin_page.dart';
import 'package:timer_chellenge/service/database_service.dart';
import 'package:timer_chellenge/widgets.dart/widgets.dart';

class EndPage extends StatefulWidget {
  bool? isAdmin;
  final String roomId;
  EndPage({super.key, required this.isAdmin, required this.roomId});

  @override
  State<EndPage> createState() => _EndPageState();
}

class _EndPageState extends State<EndPage> {
  List participantsTime = [];
  List abs = [];
  List nearest = [];
  bool _isLoading = false;
  QuerySnapshot? searchSnapShot;
  String no1ProfilePic = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _isLoading = true;
    });
    DataBaseService().getRecordsOfparticipant(widget.roomId).then((val) {
      setState(() {
        participantsTime = val;
        findNearest();
      });
      DataBaseService()
          .searchByTime(participantsTime[0], widget.roomId)
          .then((val) {
        setState(() {
          searchSnapShot = val;
          //_isLoading = false;
        });
        DataBaseService()
            .getProfilePic(getId(searchSnapShot!.docs[0]['userName']))
            .then((val) {
          setState(() {
            no1ProfilePic = val;
            _isLoading = false;
            print(widget.isAdmin);
            print('---------------------');
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Color.fromARGB(255, 13, 4, 93),
        title: const Text('結果集計'),
      ),
      body: _isLoading == false
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        '勝者',
                        style: TextStyle(
                            fontSize: 30,
                            color: Colors.red,
                            fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(width: 3),
                      Text.rich(TextSpan(children: [
                        TextSpan(
                            text: getName(searchSnapShot!.docs[0]['userName']),
                            style: const TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold)),
                        const TextSpan(
                            text: 'さん！', style: TextStyle(fontSize: 18))
                      ])),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "${participantsTime[0].toStringAsFixed(2)}秒",
                    style: const TextStyle(fontSize: 25),
                  ),
                  const SizedBox(height: 15),
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: NetworkImage(no1ProfilePic),
                  ),
                  const SizedBox(height: 15),
                  participantResults(),
                  const SizedBox(height: 20),
                  widget.isAdmin == true
                      ? endButtonForAdmin()
                      : endButtonForParticipants(),
                ],
              ),
            )
          : Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            ),
    );
  }

  participantResults() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.3,
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('rooms')
            .doc(widget.roomId)
            .collection('record')
            .snapshots(),
        builder: (context, snapshot) {
          return snapshot.hasData
              ? SingleChildScrollView(
                  child: Scrollbar(
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          tileColor: Colors.grey[200],
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          leading: profilePicturesWidget(
                              snapshot.data!.docs[index]['userName']),
                          title: Text(
                            '${snapshot.data!.docs[index]['time']}秒',
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                          subtitle: Text(
                            getName(snapshot.data!.docs[index]['userName']),
                            style: const TextStyle(fontWeight: FontWeight.w400),
                          ),
                        );
                      },
                    ),
                  ),
                )
              : Center(
                  child: Text('何かがおかしい'),
                );
        },
      ),
    );
  }

  //60秒に一番近いものを探す
  findNearest() {
    for (int i = 0; i < participantsTime.length; i++) {
      print((60 - participantsTime[i]).abs());
    }
    participantsTime.sort((a, b) => (60 - a).abs().compareTo((60 - b).abs()));
    print(participantsTime);
  }

  endButtonForAdmin() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor),
          onPressed: () {
            setState(() {
              _isLoading = true;
            });
            DataBaseService().deleteRecordData(widget.roomId).then((val) {
              DataBaseService().updateDataOfRooms(widget.roomId).then((val) {
                setState(() {
                  _isLoading = false;
                  nextScreenReplacement(context, const PinPage());
                });
              });
            });
          },
          child: const Text(
            '終了',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  endButtonForParticipants() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor),
        onPressed: () {
          nextScreenReplacement(context, const PinPage());
        },
        child: const Text(
          '終了',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
