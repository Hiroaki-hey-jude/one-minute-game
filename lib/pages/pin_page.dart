import 'package:flutter/material.dart';

class PinPage extends StatefulWidget {
  const PinPage({super.key});

  @override
  State<PinPage> createState() => _PinPageState();
}

class _PinPageState extends State<PinPage> {
  String pin = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(pin),
          Row(
            children: [
              numberButton('1'),
              numberButton('2'),
              numberButton('3'),
            ],
          ),
          Row(
            children: [
              numberButton('4'),
              numberButton('5'),
              numberButton('6'),
            ],
          ),
          Row(
            children: [
              numberButton('7'),
              numberButton('8'),
              numberButton('9'),
            ],
          ),
          Row(
            children: [
              numberButton('<-'),
              numberButton('0'),
              numberButton('Go'),
            ],
          ),
        ],
      ),
    );
  }

  numberButton(String number) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))),
      child: Text(number),
    );
  }
}
