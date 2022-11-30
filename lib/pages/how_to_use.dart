import 'package:flutter/material.dart';

class HelpPage extends StatelessWidget {
  double deviceHeight = 0;
  double deviceWidth = 0;

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('使い方'),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
      ),
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.fromLTRB(30, 0, 30, 30),
        color: Colors.grey.shade100,
        height: deviceHeight,
        width: deviceWidth,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Text(
                'ー アドミンとプレイヤーの2種類の遊び方があるよ！ ー',
                style: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
              const SizedBox(height: 20),
              const Text(
                'アドミン編',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Color(0xFFEF9F9F),
                    fontWeight: FontWeight.bold,
                    fontSize: 21),
              ),
              const SizedBox(height: 20),
              const Text(
                '1.ルームを作ろう！',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
              const SizedBox(height: 30),
              Image.asset(
                'assets/screenshot1.png',
                height: 450,
              ),
              const SizedBox(height: 20),
              const Text(
                '＊ルームを作ったらそのルーム名をタップして下さい',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.black54, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              const Text(
                '2.ルームキーを友達に教えよう！',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
              const SizedBox(height: 20),
              Image.asset(
                'assets/screenshot2.png',
                height: 450,
              ),
              const SizedBox(height: 20),
              const Text(
                '＊プレイヤーが集まったら”プレイヤーを締め切る”ボタンを押してください',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.black54, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              const Text(
                '3.プレイヤーが全員タイマーをストップしたらSTOPボタンを押して結果画面へGO',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
              const SizedBox(height: 20),
              Image.asset(
                'assets/screenshot3.png',
                height: 450,
              ),
              const SizedBox(height: 30),
              const Text(
                'プレイヤーがいつSTOPしたかをアドミンはリアルタイムで見れるよ！',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.black54, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              const Text(
                '4.結果を見たら終了ボタンを押してゲームを閉じよう！',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
              const SizedBox(height: 20),
              Image.asset(
                'assets/screenshot4.png',
                height: 450,
              ),
              const SizedBox(height: 30),
              const Text(
                'プレイヤー編',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Color(0xFFEF9F9F),
                    fontWeight: FontWeight.bold,
                    fontSize: 21),
              ),
              const SizedBox(height: 20),
              const Text(
                '1.アドミンから教えてもらったPINを入力してルームに入ろう！',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
              const SizedBox(height: 20),
              Image.asset(
                'assets/screenshot5.png',
                height: 450,
              ),
              const SizedBox(height: 30),
              const Text(
                '＊GOをタップしたらルームに入れるよ！',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.black54, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              const Text(
                '2.アドミンがタイマーをスタートしたら自動で始まります。１分間ジャストだと思ったらSTOPボタンを押しましょう',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
              const SizedBox(height: 20),
              Image.asset(
                'assets/screenshot6.png',
                height: 450,
              ),
              const SizedBox(height: 30),
              const Text(
                '＊アドミンがゲームを終了したら自動的に結果ページに遷移します！',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.black54, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              const Text(
                '3.結果発表！',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
              const SizedBox(height: 20),
              Image.asset(
                'assets/screenshot4.png',
                height: 450,
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
