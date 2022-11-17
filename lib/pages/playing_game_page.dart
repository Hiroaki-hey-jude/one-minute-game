import 'package:flutter/material.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class PlayingGamePage extends StatefulWidget {
  bool? isAdmin;
  PlayingGamePage({super.key, required this.isAdmin});

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
    mode: StopWatchMode.countUp, //カウントダウンだぜ
    presetMillisecond: 1000 * 60,
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
                      CountDownTimer(),
                      startButton(),
                    ],
                  ),
                ),
              ),
            )
          : Center(
              child: Text('not admin'),
            ),
    );
  }

  CountDownTimer() {
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
