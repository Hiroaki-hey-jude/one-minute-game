import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

void nextScreen(context, page) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => page));
}

void nextScreenReplacement(context, page) {
  Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => page));
}

String getName(String r) {
  return r.substring(r.indexOf('_') + 1);
}

String getId(String res) {
  return res.substring(0, res.indexOf("_"));
}

const textInputDecoration = InputDecoration(
  labelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w300),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color(0xFFee7b64), width: 2),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color(0xFFee7b64), width: 2),
  ),
  errorBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color(0xFFee7b64), width: 2),
  ),
);

void showSnackBar(context, color, message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(
      message,
      style: const TextStyle(fontSize: 14),
    ),
    backgroundColor: color,
    duration: const Duration(seconds: 2),
    action: SnackBarAction(
      label: 'OK',
      onPressed: () {},
      textColor: Colors.white,
    ),
  ));
}

Widget profilePicturesWidget(String userName) {
  return SizedBox(
    height: 50,
    width: 50,
    child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(getId(userName))
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());
          String originalImgURL = snapshot.data!.get('profilePic') as String !=
                  ''
              ? snapshot.data!.get('profilePic') as String
              : 'https://msp.c.yimg.jp/images/v2/FUTi93tXq405grZVGgDqGx5cm8knTLo61O84kVTxOan841a30-aIJSoqkmlQNsP4-Qv0KVqX9M9vYFUiwJk7Td3V7vPM0KOdWqrUituYvtnSar9x6L84qPLmIBtWCypFJz0KXlr7qn7fBK3IAzXNoKqa8nXN1Pz9ov4LKOTDRDV8wVWo1nQMCGO9E4o6K36McUAylQDeTQRNF9Op3JfY2iTFAun4IWDGV3qwbY8bHxZl4xSjUUv4fCzYvGjh2ca9bpeFmXd2K-uN80LrsmWEALH9sYrv73X1ZPxpgNLPBEe_7WG2Ffw6G1V4ZRj10gSJAhhlIWmL3Dppp79xAsruIw==/800px-Solid_blue.svg.png?errorImage=false';
          print(originalImgURL);
          return CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(originalImgURL),
          );
        }),
  );
}
