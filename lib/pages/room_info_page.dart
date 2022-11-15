import 'package:flutter/material.dart';

class RoomInfoPage extends StatefulWidget {
  final String roomId;
  final String roomName;
  final String admin;
  const RoomInfoPage(
      {super.key,
      required this.roomId,
      required this.roomName,
      required this.admin});

  @override
  State<RoomInfoPage> createState() => _RoomInfoPageState();
}

class _RoomInfoPageState extends State<RoomInfoPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('room info page'),
    );
  }
}
