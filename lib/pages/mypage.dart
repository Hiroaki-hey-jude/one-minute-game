import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:timer_chellenge/pages/profile_page.dart';
import 'package:timer_chellenge/widgets.dart/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  double deviceHeight = 0;
  double deviceWidth = 0;
  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('設定'),
      ),
      body: SingleChildScrollView(
        child: SettingsList(
          sections: [
            SettingsSection(
              tiles: [
                SettingsTile.navigation(
                  title: const Text('プロフィール設定'),
                  leading: Icon(Icons.person, color: Colors.white),
                  onPressed: (context) {
                    nextScreen(context, const ProfilePage());
                  },
                ),
              ],
            ),
            SettingsSection(
              tiles: [
                SettingsTile.navigation(
                  title: const Text('利用規約'),
                  leading: Icon(Icons.person, color: Colors.white),
                  onPressed: (context) async {
                    final url = Uri.parse(
                        'https://cut-primula-dac.notion.site/4581a5ada23945d7a11862cb9140a34e');
                    if (!await launchUrl(url)) {
                    } else {
                      throw 'このURLにはアクセスできません';
                    }
                  },
                ),
              ],
            ),
            SettingsSection(
              tiles: [
                SettingsTile.navigation(
                  title: const Text('プライバシーポリシー'),
                  leading: Icon(Icons.person, color: Colors.white),
                  onPressed: (context) async {
                    final url = Uri.parse(
                        'https://cut-primula-dac.notion.site/b07b0b0a444847f2990172e9dddef2d2');
                    if (!await launchUrl(url)) {
                    } else {
                      throw 'このURLにはアクセスできません';
                    }
                  },
                ),
              ],
            ),
            SettingsSection(
              tiles: [
                SettingsTile.navigation(
                  title: const Text('お問い合わせ'),
                  leading: Icon(Icons.person, color: Colors.white),
                  onPressed: (context) async {
                    final url = Uri.parse(
                        'https://forms.gle/FwZNwXkjJhjCt2WE8');
                    if (!await launchUrl(url)) {
                    } else {
                      throw 'このURLにはアクセスできません';
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
