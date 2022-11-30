import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:timer_chellenge/pages/how_to_use.dart';
import 'package:timer_chellenge/pages/profile_page.dart';
import 'package:timer_chellenge/widgets.dart/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

import '../service/auth_service.dart';
import 'auth/login_page.dart';

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  AuthService authService = AuthService();
  double deviceHeight = 0;
  double deviceWidth = 0;
  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('設定'),
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SizedBox(
        width: deviceWidth,
        height: deviceHeight,
        child: SettingsList(
          sections: [
            SettingsSection(
              tiles: [
                SettingsTile.navigation(
                  title: const Text('使い方'),
                  leading: const Icon(Icons.help, color: Colors.black),
                  onPressed: (context) {
                    nextScreen(context, HelpPage());
                  },
                ),
              ],
            ),
            SettingsSection(
              tiles: [
                SettingsTile.navigation(
                  title: const Text('プロフィール設定'),
                  leading: const Icon(Icons.person, color: Colors.black),
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
                  leading: const Icon(
                    Icons.notes_sharp,
                    color: Colors.black,
                  ),
                  onPressed: (context) async {
                    final url = Uri.parse(
                        'https://cut-primula-dac.notion.site/4581a5ada23945d7a11862cb9140a34e');
                    if (!await launchUrl(url)) {
                    } else {
                      throw 'このURLにはアクセスできません';
                    }
                  },
                ),
                SettingsTile.navigation(
                  title: const Text('プライバシーポリシー'),
                  leading: const Icon(Icons.notes, color: Colors.black),
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
                  leading: const Icon(
                    Icons.mail_outline,
                    color: Colors.black,
                  ),
                  onPressed: (context) async {
                    final url =
                        Uri.parse('https://forms.gle/FwZNwXkjJhjCt2WE8');
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
                  title: const Text('ログアウト'),
                  leading: const Icon(
                    Icons.logout,
                    color: Colors.black,
                  ),
                  onPressed: (context) async {
                    popupForLogout(context);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  popupForLogout(context) {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: const Text(
              'ログアウトする',
              textAlign: TextAlign.left,
            ),
            actions: [
              ElevatedButton(
                onPressed: () async {
                  await authService.signOut();
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()),
                      (route) => false);
                },
                child: const Text('ログアウト'),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor),
              ),
              ElevatedButton(
                onPressed: () {
                  print('hihi');
                  Navigator.of(context).pop();
                },
                child: const Text('キャンセル'),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor),
              ),
            ],
          );
        });
      },
    );
  }
}
