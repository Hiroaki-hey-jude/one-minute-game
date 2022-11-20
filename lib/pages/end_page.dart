import 'package:flutter/material.dart';
import 'package:timer_chellenge/service/database_service.dart';

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
        _isLoading = false;
        findNearest();
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
          ? Center(
              child: Text(participantsTime[1].toString()),
            )
          : Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            ),
    );
  }

  //60秒に一番近いものを探す
  findNearest() { 
    for (int i = 0; i < participantsTime.length; i++) {
      print((60 - participantsTime[i]).abs());
    }
    participantsTime.sort((a, b) => (60-a).abs().compareTo((60-b).abs()));
    print(participantsTime);
  }
}
