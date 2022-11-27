import 'package:flutter/material.dart';

class HelpPage extends StatelessWidget {
  double deviceHeight = 0;
  double deviceWidth = 0;

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.fromLTRB(30, 0, 30, 30),
        color: Colors.grey.shade100,
        height: deviceHeight,
        width: deviceWidth,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset(
                'assets/icon-white.png',
                height: 150,
              ),
              const Text(
                'ー　使い方　ー',
                style: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
              const SizedBox(height: 20),
              const Text(
                '１ アドミン編',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Color(0xFFEF9F9F),
                    fontWeight: FontWeight.bold,
                    fontSize: 17),
              ),
              const SizedBox(height: 20),
              const Text(
                'ルームを作ろう！',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.black54, fontWeight: FontWeight.bold),
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
                '２ ルームキーを友達に教えよう！',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Color(0xFFEF9F9F),
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
              const SizedBox(height: 20),
              const Text(
                '他の人が投稿したコレクションをみてみましょう。\n知らなかった知識が増えたり\n気の合う仲間を見つけることができるかも！',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.black54, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              Image.asset(
                'assets/image/IMG_0586.PNG',
                height: 450,
              ),
              const SizedBox(height: 30),
              const Text(
                '素敵なアイテムがあったらお気に入りにしたり\nコメントしてみましょう！',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.black54, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              Image.asset(
                'assets/image/IMG_0597.PNG',
                height: 450,
              ),
              const SizedBox(height: 30),
              const Text(
                'インストールいただきありがとうございます。\n今後、随時アップデートしていく予定ですので\nどうぞFavpicをお楽しみください。',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.black54, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              Image.asset(
                'assets/image/launcher_icon_foreground.png',
                height: 70,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
