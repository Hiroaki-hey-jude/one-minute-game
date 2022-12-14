import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:timer_chellenge/pages/auth/login_page.dart';
import 'package:timer_chellenge/service/auth_service.dart';
import 'package:timer_chellenge/service/database_service.dart';
import 'dart:io';
import '../helper/helper_function.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  AuthService authService = AuthService();
  bool _isLoading = false;
  String email = '';
  String userName = '';
  String? name;
  File? imageFile;
  //String originalImgURL = '';
  String imgURL =
      'https://msp.c.yimg.jp/images/v2/FUTi93tXq405grZVGgDqGyL5nc0JPOaUOtLWCRSwKb5x0EhmYEz9re4BenktujdEH2BeWCnnRhcHGCaNnYT---R6QoV-6HppQ2-UFxZJ8wlYN2W1BW0ZK3QdppyfJj7MpQGDRS8w8TecERmF1enDXikbkqjKswAjuBVYiRiTks6Vzua3c4MjoDAwngCiK_6XWFV00-fwYkXUln6Fj_cpyPFRgaMScOAL7iedsaHeAN69leukej5rJxDZTetyU0yS4htPMtWJwsedp038yJXWOOlklgLB2PPlx2ubPDc2K1X1gM4HpzZr4eq_7h8pzvWy/media';
  final picker = ImagePicker();
  String uid = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    uid = FirebaseAuth.instance.currentUser!.uid;
    getUserData();
  }

  getUserData() async {
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.center,
              child: GestureDetector(
                onTap: () {
                  updateProfilePic();
                },
                child: const Text(
                  '??????',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w400),
                ),
              ),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            )
          : StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(uid)
                  .snapshots(),
              builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                  return Center(child: CircularProgressIndicator());
                String originalImgURL = snapshot.data!.get('profilePic')
                            as String !=
                        ''
                    ? snapshot.data!.get('profilePic') as String
                    : 'https://msp.c.yimg.jp/images/v2/FUTi93tXq405grZVGgDqGx5cm8knTLo61O84kVTxOan841a30-aIJSoqkmlQNsP4-Qv0KVqX9M9vYFUiwJk7Td3V7vPM0KOdWqrUituYvtnSar9x6L84qPLmIBtWCypFJz0KXlr7qn7fBK3IAzXNoKqa8nXN1Pz9ov4LKOTDRDV8wVWo1nQMCGO9E4o6K36McUAylQDeTQRNF9Op3JfY2iTFAun4IWDGV3qwbY8bHxZl4xSjUUv4fCzYvGjh2ca9bpeFmXd2K-uN80LrsmWEALH9sYrv73X1ZPxpgNLPBEe_7WG2Ffw6G1V4ZRj10gSJAhhlIWmL3Dppp79xAsruIw==/800px-Solid_blue.svg.png?errorImage=false';
                print(originalImgURL + ' ???????????????URL???');
                return Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 50),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: SizedBox(
                              height: 170,
                              width: 170,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    child: CircleAvatar(
                                      radius: 150,
                                      //backgroundColor: Colors.grey[200],
                                      child: CircleAvatar(
                                        radius: 120,
                                        backgroundImage: imageFile == null
                                            ? NetworkImage(originalImgURL)
                                                as ImageProvider
                                            : FileImage(imageFile!),
                                      ),
                                    ),
                                  ),
                                  RawMaterialButton(
                                    fillColor: Colors.transparent,
                                    onPressed: () async { // alert dialog ????????????
                                      await pickImage();
                                    },
                                    shape: const CircleBorder(),
                                    child: const Icon(Icons.camera_alt_rounded),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 100,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [const Text('??????'), Text(userName)],
                      ),
                      const Divider(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [const Text('Email'), Text(email)],
                      ),
                    ],
                  ),
                );
              }),
    );
  }

  // popupForLogout(context) {
  //   showDialog(
  //     barrierDismissible: true,
  //     context: context,
  //     builder: (context) {
  //       return StatefulBuilder(builder: (context, setState) {
  //         return AlertDialog(
  //           title: const Text(
  //             '?????????????????????',
  //             textAlign: TextAlign.left,
  //           ),
  //           actions: [
  //             ElevatedButton(
  //               onPressed: () async {
  //                 await authService.signOut();
  //                 Navigator.of(context).pushAndRemoveUntil(
  //                     MaterialPageRoute(
  //                         builder: (context) => const LoginPage()),
  //                     (route) => false);
  //               },
  //               child: const Text('???????????????'),
  //               style: ElevatedButton.styleFrom(
  //                   backgroundColor: Theme.of(context).primaryColor),
  //             ),
  //             ElevatedButton(
  //               onPressed: () {
  //                 print('hihi');
  //                 Navigator.of(context).pop();
  //               },
  //               child: const Text('???????????????'),
  //               style: ElevatedButton.styleFrom(
  //                   backgroundColor: Theme.of(context).primaryColor),
  //             ),
  //           ],
  //         );
  //       });
  //     },
  //   );
  // }

  Future<void> pickImage() async {
    print('picked file????????????');
    print(uid);
    //?????????????????????????????????
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 600,
      maxWidth: 600,
    );

    // ??????????????????????????????????????????????????????
    if (pickedFile == null) {
      print('??????????????????');
      return;
    }

    //???????????????????????????????????????
    setState(() {
      imageFile = File(pickedFile.path);
      print('hihihi');
    });
  }

  Future updateProfilePic() async {
    setState(() {
      _isLoading = true;
    });
    final DocumentSnapshot doc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (imageFile != null) {
      final ref = FirebaseStorage.instance
          .ref()
          .child('profileimages')
          .child(userName + '.jpg');
      await ref.putFile(imageFile!);
      imgURL = await ref.getDownloadURL();
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'profilePic': imgURL,
      });
      setState(() {
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      return null;
    }
  }
}
