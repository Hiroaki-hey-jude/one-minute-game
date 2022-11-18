import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class PlayingGamePage extends StatefulWidget {
  bool? isAdmin;
  final String roomId;
  PlayingGamePage({super.key, required this.isAdmin, required this.roomId});

  @override
  State<PlayingGamePage> createState() => _PlayingGamePageState();
}

class _PlayingGamePageState extends State<PlayingGamePage> {
  bool hasTimerStarted = false;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.isAdmin == true
          ? SafeArea(
              child: Center(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                  child: Column(
                    children: [
                      countTimer(),
                      startButton(),
                    ],
                  ),
                ),
              ),
            )
          : SafeArea(
              child: Center(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                  child: Column(
                    children: [
                      patcipantsTimer(),
                    ],
                  ),
                ),
              ),
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
          if (snapshot.data!.get('hasTimerStarted') == true) {
            print('kokokiteru????');
            _stopWatchTimer.onStartTimer();
          }
          return countTimerForParticipants();
        } else {
          return Center(
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
          final displayTime = StopWatchTimer.getDisplayTime(
            snapshot.data!,
            hours: _isHours,
            minute: _isMins,
            second: _isSeconds,
            milliSecond: _isMilliSeconds,
          );
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
      height: MediaQuery.of(context).size.height / 3,
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
          hasTimerStarted = true;
          FirebaseFirestore.instance
              .collection('rooms')
              .doc(widget.roomId)
              .update({
            'hasTimerStarted': true,
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
}
