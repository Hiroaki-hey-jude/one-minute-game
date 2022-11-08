import 'dart:math';

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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(pin),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                numberButton('1'),
                numberButton('2'),
                numberButton('3'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                numberButton('4'),
                numberButton('5'),
                numberButton('6'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                numberButton('7'),
                numberButton('8'),
                numberButton('9'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                numberButton('戻る'),
                numberButton('0'),
                numberButton('Go'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  numberButton(String number) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: 90,
        height: 90,
        child: ElevatedButton(
          onPressed: () {
            composePin(number);
          },
          style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.6),
              shape: const CircleBorder()),
          child: Text(
            number,
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  composePin(String pieceOfPin) {
    switch (pieceOfPin) {
      case '0':
        setState(() {
          pin = '${pin}0';
        });
        break;
      case '1':
        setState(() {
          pin = '${pin}1';
        });
        break;
      case '2':
        setState(() {
          pin = '${pin}2';
        });
        break;
      case '3':
        setState(() {
          pin = '${pin}3';
        });
        break;
      case '4':
        setState(() {
          pin = '${pin}4';
        });
        break;
      case '5':
        setState(() {
          pin = '${pin}5';
        });
        break;
      case '6':
        setState(() {
          pin = '${pin}6';
        });
        break;
      case '7':
        setState(() {
          pin = '${pin}7';
        });
        break;
      case '8':
        setState(() {
          pin = '${pin}8';
        });
        break;
      case '9':
        setState(() {
          pin = '${pin}9';
        });
        break;
      case '戻る':
        final pos = pin.length - 1;
        print(pos);
        setState(() {
          if (pos >= 0) {
            print('correct');
            pin = pin.substring(0, pos);
          } else {
            print('kotti');
            pin = pin;
          }
        });
        break;
    }
  }
}
