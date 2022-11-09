import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:timer_chellenge/service/database_service.dart';

import '../widgets.dart/widgets.dart';
import 'make_game_page.dart';

class PinPage extends StatefulWidget {
  const PinPage({super.key});

  @override
  State<PinPage> createState() => _PinPageState();
}

class _PinPageState extends State<PinPage> {
  String pin = '';
  QuerySnapshot? searchSnapShot;
  bool _isLoading = false;
  bool hasRoomSearched = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading == true
          ? Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    '6桁のパスコードを打ってください',
                    style: TextStyle(fontSize: 15),
                  ),
                  Text(
                    pin,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 35,
                    ),
                  ),
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
      case 'Go':
        initiateSearchMethod();
        break;
    }
  }

  initiateSearchMethod() async {
    if (pin.length == 6) {
      setState(() {
        _isLoading = true;
      });
      await DataBaseService().searchByKey(pin).then((snapshot) {
        setState(() {
          searchSnapShot = snapshot;
          _isLoading = false;
          hasRoomSearched = true;
        });
        // if (searchSnapShot!.docs[0]['roomId'].notEmpty()) {
        //   nextScreen(context, const MakeGamePage());
        // } else {
        //   print(searchSnapShot!.docs[0]['roomId']);
        // }
        if (searchSnapShot!.docs[0]['roomId'] == null) {
          print('nullだよん');
        } else {
          print('ナルジャない');
        }
        print(searchSnapShot!.docs.length);
        nextScreen(context, const MakeGamePage());
      }).catchError((error) {
        print(error);
        _isLoading = false;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('ルームキーが存在しません、もう一度試してください'),
          backgroundColor: Colors.red,
        ));
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('ルームキーは6桁です。'),
        backgroundColor: Colors.red,
      ));
    }
  }
}
