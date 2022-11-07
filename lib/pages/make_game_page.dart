import 'package:flutter/material.dart';

class MakeGamePage extends StatefulWidget {
  const MakeGamePage({super.key, });

  @override
  State<MakeGamePage> createState() => _MakeGamePageState();
}

class _MakeGamePageState extends State<MakeGamePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('make game page'),
      ),
    );
  }
}
