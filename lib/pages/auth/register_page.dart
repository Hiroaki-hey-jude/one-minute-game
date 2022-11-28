import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:timer_chellenge/helper/helper_function.dart';
import 'package:timer_chellenge/pages/auth/login_page.dart';
import 'package:timer_chellenge/pages/home_page.dart';
import 'package:timer_chellenge/shared/enum.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../service/auth_service.dart';
import '../../widgets.dart/widgets.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String name = '';
  String roomname = '';
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
                color: Theme.of(context).primaryColor,
              ),
            )
          : GestureDetector(
              onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
              child: SingleChildScrollView(
                child: Form(
                    key: formKey,
                    child: Container(
                      alignment: Alignment.center,
                      padding:
                          EdgeInsets.fromLTRB(30, deviceHeight / 6.8, 30, 0),
                      child: Column(
                        children: [
                          Text(
                            '1分間ゲーム',
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
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 10.0,
                                    spreadRadius: 1.0,
                                    offset: Offset(0, 10))
                              ],
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20),
                              ),
                            ),
                            child: Column(children: [
                              RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(children: [
                                    TextSpan(
                                        text: '利用規約',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Color.fromARGB(
                                              255, 228, 168, 144),
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () async {
                                            final Uri _url = Uri.parse(
                                                'https://cut-primula-dac.notion.site/4581a5ada23945d7a11862cb9140a34e');
                                            if (!await launchUrl(_url)) {
                                            } else {
                                              throw 'このURLにはアクセスできません';
                                            }
                                          }),
                                    const TextSpan(
                                        text: 'と',
                                        style: TextStyle(color: Colors.black)),
                                    TextSpan(
                                        text: 'プライバシーポリシー',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Color.fromARGB(
                                              255, 228, 168, 144),
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () async {
                                            final Uri _url = Uri.parse(
                                                'https://cut-primula-dac.notion.site/b07b0b0a444847f2990172e9dddef2d2');
                                            if (!await launchUrl(_url)) {
                                            } else {
                                              throw 'このURLにはアクセスできません';
                                            }
                                          }),
                                    const TextSpan(
                                        text: 'に\n同意して始める',
                                        style: TextStyle(color: Colors.black)),
                                  ])),
                              const SizedBox(height: 8),
                              TextFormField(
                                decoration: textInputDecoration.copyWith(
                                    labelText: "Name",
                                    prefixIcon: Icon(
                                      Icons.person,
                                      color: Theme.of(context).primaryColor,
                                    )),
                                onChanged: (val) {
                                  setState(() {
                                    name = val;
                                  });
                                },
                                // check tha validation
                                validator: (val) {
                                  if (val!.isNotEmpty) {
                                    return null;
                                  } else {
                                    return 'Name cannot be empty';
                                  }
                                },
                              ),
                              const SizedBox(height: 15),
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
                                width: 250,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      elevation: 0,
                                      side: BorderSide(
                                          color: Colors.black, width: 1),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30))),
                                  child: const Text(
                                    "アカウント作成",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 16),
                                  ),
                                  onPressed: () {
                                    register();
                                  },
                                ),
                              ),
                              const SizedBox(height: 15),
                              Text.rich(
                                TextSpan(
                                  text: "アカウントをまだお持ちでないですか？ ",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 14),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: 'ログイン',
                                        style: TextStyle(
                                            color: Colors.black,
                                            decoration:
                                                TextDecoration.underline),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            nextScreen(
                                                context, const LoginPage());
                                          })
                                  ],
                                ),
                              ),
                            ]),
                          ),
                          // TextFormField(
                          //   decoration: textInputDecoration.copyWith(
                          //       labelText: "Name",
                          //       prefixIcon: Icon(
                          //         Icons.person,
                          //         color: Theme.of(context).primaryColor,
                          //       )),
                          //   onChanged: (val) {
                          //     setState(() {
                          //       name = val;
                          //     });
                          //   },
                          //   // check tha validation
                          //   validator: (val) {
                          //     if (val!.isNotEmpty) {
                          //       return null;
                          //     } else {
                          //       return 'Name cannot be empty';
                          //     }
                          //   },
                          // ),
                          // const SizedBox(height: 15),
                          // TextFormField(
                          //   decoration: textInputDecoration.copyWith(
                          //       labelText: "Email",
                          //       prefixIcon: Icon(
                          //         Icons.email,
                          //         color: Theme.of(context).primaryColor,
                          //       )),
                          //   onChanged: (val) {
                          //     setState(() {
                          //       email = val;
                          //     });
                          //   },

                          //   // check tha validation
                          //   validator: (val) {
                          //     return RegExp(
                          //                 r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          //             .hasMatch(val!)
                          //         ? null
                          //         : "Please enter a valid email";
                          //   },
                          // ),
                          // const SizedBox(height: 15),
                          // TextFormField(
                          //   obscureText: true,
                          //   decoration: textInputDecoration.copyWith(
                          //       labelText: "Password",
                          //       prefixIcon: Icon(
                          //         Icons.lock,
                          //         color: Theme.of(context).primaryColor,
                          //       )),
                          //   validator: (val) {
                          //     if (val!.length < 6) {
                          //       return "Password must be at least 6 characters";
                          //     } else {
                          //       return null;
                          //     }
                          //   },
                          //   onChanged: (val) {
                          //     setState(() {
                          //       password = val;
                          //     });
                          //   },
                          // ),
                          // const SizedBox(
                          //   height: 20,
                          // ),
                          // SizedBox(
                          //   width: double.infinity,
                          //   child: ElevatedButton(
                          //     style: ElevatedButton.styleFrom(
                          //         backgroundColor:
                          //             Theme.of(context).primaryColor,
                          //         elevation: 0,
                          //         shape: RoundedRectangleBorder(
                          //             borderRadius: BorderRadius.circular(30))),
                          //     child: const Text(
                          //       "アカウント作成",
                          //       style: TextStyle(
                          //           color: Colors.white, fontSize: 16),
                          //     ),
                          //     onPressed: () {
                          //       register();
                          //     },
                          //   ),
                          // ),
                          // const SizedBox(height: 15),
                          // Text.rich(
                          //   TextSpan(
                          //     text: "アカウントをまだお持ちでないですか？ ",
                          //     style:
                          //         TextStyle(color: Colors.black, fontSize: 14),
                          //     children: <TextSpan>[
                          //       TextSpan(
                          //           text: 'ログイン',
                          //           style: TextStyle(
                          //               color: Colors.black,
                          //               decoration: TextDecoration.underline),
                          //           recognizer: TapGestureRecognizer()
                          //             ..onTap = () {
                          //               nextScreen(context, const LoginPage());
                          //             })
                          //     ],
                          //   ),
                          // ),
                        ],
                      ),
                    )),
              ),
            ),
    );
  }

  register() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isloading = true;
      });
      final EmailSignResults emailSignResults = await authService
          .registerUserWithEmailandPassword(name, email, password);
      String message = '';
      if (emailSignResults == EmailSignResults.SignUpCompleted) {
        await HelperFunction.saveUserLoggedInStatus(true);
        await HelperFunction.saveUserEmailSF(email);
        await HelperFunction.saveUserNameSF(name);
        nextScreenReplacement(context, const HomePage());
      } else if (emailSignResults == EmailSignResults.SignUpNotCompleted) {
        message = 'Sign up not completed, try again';
      } else {
        message = 'Email alaready present';
      }
      if (message != '')
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(message)));
      setState(() {
        _isloading = false;
      });
    } else {
      print('not Validated');
    }
  }
}
