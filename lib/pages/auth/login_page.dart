import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:timer_chellenge/helper/helper_function.dart';
import 'package:timer_chellenge/pages/auth/register_page.dart';
import 'package:timer_chellenge/pages/home_page.dart';
import 'package:timer_chellenge/service/auth_service.dart';
import 'package:timer_chellenge/shared/enum.dart';
import 'package:timer_chellenge/widgets.dart/widgets.dart';

import '../../service/database_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  bool _isloading = false;
  AuthService authService = AuthService();
  double deviceHeight = 0;
  double deviceWidth = 0;
  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: _isloading
          ? Center(
              child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor))
          : GestureDetector(
              onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.fromLTRB(30, deviceHeight / 4.8, 30, 0),
                    child: Column(
                      children: [
                        Text(
                          '１分間ゲーム',
                          style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Image.asset(
                          "assets/transIcons.png",
                          height: 200,
                        ),
                        TextFormField(
                          decoration: textInputDecoration.copyWith(
                              labelText: "Email",
                              prefixIcon: Icon(
                                Icons.email,
                                color: Theme.of(context).primaryColor,
                              )),
                          onChanged: (val) {
                            setState(() {
                              email = val;
                            });
                          },

                          // check tha validation
                          validator: (val) {
                            return RegExp(
                                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(val!)
                                ? null
                                : "Please enter a valid email";
                          },
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          obscureText: true,
                          decoration: textInputDecoration.copyWith(
                              labelText: "Password",
                              prefixIcon: Icon(
                                Icons.lock,
                                color: Theme.of(context).primaryColor,
                              )),
                          validator: (val) {
                            if (val!.length < 6) {
                              return "Password must be at least 6 characters";
                            } else {
                              return null;
                            }
                          },
                          onChanged: (val) {
                            setState(() {
                              password = val;
                            });
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).primaryColor,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30))),
                            child: const Text(
                              'ログイン',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                            onPressed: () {
                              login();
                            },
                          ),
                        ),
                        const SizedBox(height: 15),
                        Text.rich(
                          TextSpan(
                              text: "アカウントを持っていませんか? ",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 14),
                              children: <TextSpan>[
                                TextSpan(
                                    text: '登録',
                                    style: TextStyle(
                                        color: Colors.black,
                                        decoration: TextDecoration.underline),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        nextScreen(
                                            context, const RegisterPage());
                                      })
                              ]),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  login() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isloading = true;
      });
      final EmailLogInResults emailLogInResults =
          await authService.logInUserWithEmailandPassword(email, password);
      String message = '';
      if (emailLogInResults == EmailLogInResults.LogInCompleted) {
        QuerySnapshot snapshot =
            await DataBaseService(uid: FirebaseAuth.instance.currentUser!.uid)
                .gettingUserData(email);
        await HelperFunction.saveUserLoggedInStatus(true);
        await HelperFunction.saveUserEmailSF(email);
        await HelperFunction.saveUserNameSF(snapshot.docs[0]['name']); //naze
        print(snapshot.docs[0]['name']);
        nextScreenReplacement(context, const HomePage());
      } else if (emailLogInResults == EmailLogInResults.EmailNotVerified) {
        message =
            'Email not verified. \nPlease Verify your Email and then log in';
      } else if (emailLogInResults == EmailLogInResults.EmailPasswordInvalid) {
        message = 'Email Or Password Invalid';
      } else
        message = 'Log in not completed';

      if (message != '')
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(message)));

      setState(() {
        _isloading = false;
      });
    } else {
      print('not validated ');
    }
  }
}
