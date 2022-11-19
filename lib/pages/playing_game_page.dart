import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:timer_chellenge/pages/end_page.dart';
import 'package:timer_chellenge/service/database_service.dart';

import '../widgets.dart/widgets.dart';

class PlayingGamePage extends StatefulWidget {
  bool? isAdmin;
  final String roomId;
  final String userName;
  PlayingGamePage(
      {super.key,
      required this.isAdmin,
      required this.roomId,
      required this.userName});

  @override
  State<PlayingGamePage> createState() => _PlayingGamePageState();
}

class _PlayingGamePageState extends State<PlayingGamePage> {
  bool hasTimerStarted = false;
  bool hasFiveSecondsPassed = false;
  bool hasParticipantsStopButtonPressed = false;
  bool hasTimerStopped = false;
  final _isHours = false;
  final _isMins = true;
  final _isSeconds = true;
  final _isMilliSeconds = true;
  final _stopWatchTimer = StopWatchTimer(
    mode: StopWatchMode.countUp,
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _stopWatchTimer.dispose();
    super.dispose();
  }

  String getName(String r) {
    return r.substring(r.indexOf('_') + 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.isAdmin == true
          ? SafeArea(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child: Center(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                    child: Column(
                      children: [
                        countTimer(),
                        hasTimerStarted == false ? startButton() : stopButton(),
                        SizedBox(height: 15),
                        participantsTiles(),
                      ],
                    ),
                  ),
                ),
              ),
            )
          : SafeArea(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                child: hasParticipantsStopButtonPressed == false
                    ? Center(
                        child: Column(
                          children: [
                            patcipantsTimer(),
                            const SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 40, vertical: 10),
                              child: hasTimerStarted == true
                                  ? const Text(
                                      'あなたがジャスト１分だと思った時STOPを押してください',
                                      style: TextStyle(
                                        fontSize: 20,
                                      ),
                                    )
                                  : const Text(
                                      'ルームマスターがタイマーを\nSTARTするまでお待ちください',
                                      style: TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                            )
                          ],
                        ),
                      )
                    : const Center(
                        child: Text(
                          '集計中です、少々お待ちください',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
              ),
            ),
    );
  }

  participantsTiles() {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height / 3,
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('rooms')
            .doc(widget.roomId)
            .collection('record')
            .snapshots(),
        builder: (context, snapshot) {
          return snapshot.hasData
              ? SingleChildScrollView(
                  child: ListView.builder(
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
                            getName(snapshot.data!.docs[index]['userName']),
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                          subtitle: const Text(
                            'がSTOPボタンを押した！',
                            style: TextStyle(fontWeight: FontWeight.w400),
                          ),
                        );
                      }),
                )
              : const Center(
                  child: Text('少々お待ちください'),
                );
        },
      ),
    );
  }

  patcipantsTimer() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('rooms')
          .doc(widget.roomId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!['hasTimerStopped'] == true) {
            Future.delayed(
              Duration(seconds: 1),
              (() {
                nextScreenReplacement(context, const EndPage());
              }),
            );
          }
          if (snapshot.data!.get('hasTimerStarted') == true) {
            print('kokokiteru????');
            _stopWatchTimer.onStartTimer();
            Future.delayed(const Duration(seconds: 5), () {
              //５秒経ったら秒数消す
              setState(() {
                hasFiveSecondsPassed = true;
              });
            });
          }
          return countTimerForParticipants();
        } else {
          return const Center(
            child: Text('少々お待ちください'),
          );
        }
      },
    );
  }

  countTimer() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 3,
      child: StreamBuilder<int>(
        stream: _stopWatchTimer.rawTime,
        initialData: _stopWatchTimer.rawTime.value,
        builder: (context, snapshot) {
          final value = snapshot.data;
          final displayTime = StopWatchTimer.getDisplayTime(
            value!,
            hours: _isHours,
            minute: _isMins,
            second: _isSeconds,
            milliSecond: _isMilliSeconds,
          );
          print(value);
          return Center(
            child: SizedBox(
              width: double.infinity,
              child: FittedBox(
                fit: BoxFit.fitWidth,
                child: Text(
                  displayTime,
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  countTimerForParticipants() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.5,
      child: StreamBuilder(
        stream: _stopWatchTimer.rawTime,
        initialData: _stopWatchTimer.rawTime.value,
        builder: (context, snapshot) {
          final displayTime = StopWatchTimer.getDisplayTime(
            snapshot.data!,
            hours: _isHours,
            minute: _isMins,
            second: _isSeconds,
            milliSecond: _isMilliSeconds,
          );
          print(snapshot.data!);
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: hasFiveSecondsPassed == true
                        ? Center(
                            child: const Text('集中。。。'),
                          )
                        : Text(
                            displayTime,
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 30),
                buttonForParticipantsToStop(snapshot.data!),
              ],
            ),
          );
        },
      ),
    );
  }

  startButton() {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 3,
      height: MediaQuery.of(context).size.height / 9,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.amber,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(70),
          ),
        ),
        onPressed: () {
          FirebaseFirestore.instance
              .collection('rooms')
              .doc(widget.roomId)
              .update({
            'hasTimerStarted': true,
          });
          setState(() {
            hasTimerStarted = true;
          });
          _stopWatchTimer.onStartTimer();
        },
        child: const Text(
          'START',
          style: TextStyle(fontSize: 28),
        ),
      ),
    );
  }

  stopButton() {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 3,
      height: MediaQuery.of(context).size.height / 9,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.amber,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(70),
          ),
        ),
        onPressed: () {
          if(hasTimerStarted == true) {
            FirebaseFirestore.instance
                .collection('rooms')
                .doc(widget.roomId)
                .update({
              'hasTimerStopped': true,
            });
            nextScreenReplacement(context, const EndPage());
          }
        },
        child: const Text(
          'STOP',
          style: TextStyle(fontSize: 28),
        ),
      ),
    );
  }

  buttonForParticipantsToStop(int timePressed) {
    return SizedBox(
      height: 120,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          backgroundColor: Theme.of(context).primaryColor.withOpacity(0.7),
        ),
        onPressed: () {
          if (hasTimerStarted == true) {
            _stopWatchTimer.onStopTimer();
            Map<String, dynamic> timeParticipant = {
              'time': timePressed / 1000,
              'userName': widget.userName,
            };
            DataBaseService().pressStopButtonAndSaveInFIrestore(
                widget.roomId, timeParticipant);
            setState(() {
              hasParticipantsStopButtonPressed = true;
            });
          }
        },
        child: const Text(
          'STOP',
          style: TextStyle(fontSize: 30),
        ),
      ),
    );
  }
}
