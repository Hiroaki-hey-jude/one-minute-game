import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:timer_chellenge/helper/helper_function.dart';
import 'package:timer_chellenge/pages/join_page.dart';
import 'package:timer_chellenge/pages/make_game_page.dart';
import 'package:timer_chellenge/pages/pin_page.dart';
import 'package:timer_chellenge/pages/profile_page.dart';
import 'package:timer_chellenge/service/auth_service.dart';
import 'package:timer_chellenge/service/database_service.dart';
import 'package:timer_chellenge/widgets.dart/widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AuthService authService = AuthService();
  bool _isLoading = false;
  String roomName = "";
  String email = '';
  String userName = '';
  Stream? room;
  QuerySnapshot? searchSnapShot;
  bool hasRoomSearched = false;
  TextEditingController searchController = TextEditingController();
  int _selectedIndex = 0;
  static List<Widget> _widgetOptions = <Widget>[
    const PinPage(),
    const Text('Search Page',
        style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    gettingUserData();
  }

  gettingUserData() async {
    await HelperFunction.getUserEmailFromSF().then((value) {
      setState(() {
        email = value!;
      });
    });
    await HelperFunction.getUserNameFromSF().then((value) {
      setState(() {
        userName = value!;
      });
    });

    //getting the list of snapshot in our stream
    await DataBaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getUserRoom()
        .then((snapshot) {
      setState(() {
        room = snapshot;
      });
    }).catchError((e) {
      print(e);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).primaryColor,
        selectedItemColor: Colors.white,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.pin),
            label: 'Pin',
            tooltip: "This is a Book Page",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.rocket_launch),
            label: 'ゲーム作成',
            tooltip: "This is a Business Page",
            backgroundColor: Colors.green,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            activeIcon: Icon(Icons.school_outlined),
            label: 'アカウント',
            tooltip: "This is a School Page",
            backgroundColor: Colors.purple,
          ),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     popUpDialog(context);
      //   },
      //   elevation: 0,
      //   backgroundColor: Theme.of(context).primaryColor,
      //   child: const Icon(
      //     Icons.add,
      //     color: Colors.white,
      //     size: 30,
      //   ),
      // ),
    );
  }

  popUpDialog(context) {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: const Text(
              'ルームを作成する',
              textAlign: TextAlign.left,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _isLoading == true
                    ? Center(
                        child: CircularProgressIndicator(
                          color: Theme.of(context).primaryColor,
                        ),
                      )
                    : TextField(
                        onChanged: (val) {
                          setState(() {
                            roomName = val;
                          });
                        },
                        style: const TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).primaryColor,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.red,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).primaryColor,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      )
              ],
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('キャンセル'),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (roomName != '') {
                    setState(() {
                      _isLoading = true;
                    });
                    DataBaseService(uid: FirebaseAuth.instance.currentUser!.uid)
                        .createRoom(userName,
                            FirebaseAuth.instance.currentUser!.uid, roomName)
                        .whenComplete(() {
                      _isLoading = false;
                    });
                    showSnackBar(context, Colors.green, 'ルームを作成しました');
                    Navigator.pop(context);
                    nextScreen(context, const MakeGamePage());
                    setState(() {
                      _isLoading = false;
                    });
                  }
                },
                child: const Text('作成'),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor),
              ),
            ],
          );
        });
      },
    );
  }

  enterKeyDialog(context) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: ((context, setState) {
          return AlertDialog(
            title: const Text(
              'ルームキーを入力してください',
              textAlign: TextAlign.left,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _isLoading == true
                    ? Center(
                        child: CircularProgressIndicator(
                          color: Theme.of(context).primaryColor,
                        ),
                      )
                    : TextFormField(
                        controller: searchController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        style: const TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).primaryColor,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.red,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).primaryColor,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
              ],
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: ElevatedButton(
                  onPressed: () async {
                    initiateSearchMethod();
                  },
                  child: const Text('探す'),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor),
                ),
              ),
            ],
          );
        }));
      },
    );
  }

  initiateSearchMethod() async {
    if (searchController.text.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });
      await DataBaseService()
          .searchByKey(searchController.text)
          .then((snapshot) {
        setState(() {
          searchSnapShot = snapshot;
          _isLoading = false;
          hasRoomSearched = true;
        });
        print(searchSnapShot!.docs[0]['roomId']);
        searchController.clear();
        Navigator.of(context).pop();
        nextScreen(context, const MakeGamePage());
      }).catchError((error) {
        Navigator.of(context).pop();
        searchController.clear();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('ルームキーが存在しません、もう一度試してください'),
          backgroundColor: Colors.red,
        ));
      });
    }
  }
}
