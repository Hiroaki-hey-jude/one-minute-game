import 'package:flutter/material.dart';

class PlayingGamePage extends StatefulWidget {
  const PlayingGamePage({super.key});

  @override
  State<PlayingGamePage> createState() => _PlayingGamePageState();
}

class _PlayingGamePageState extends State<PlayingGamePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('playing page')),
    );
  }
}