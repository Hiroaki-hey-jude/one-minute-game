import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:timer_chellenge/helper/helper_function.dart';
import 'package:timer_chellenge/pages/auth/login_page.dart';
import 'package:timer_chellenge/pages/home_page.dart';
import 'package:timer_chellenge/shared/enum.dart';
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
  @override
  Widget build(BuildContext context) {
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
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
                  child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            '1分間ゲーム',
                            style: TextStyle(
                                fontSize: 40, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          Image.asset("assets/transIcons.png"),
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
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30))),
                              child: const Text(
                                "アカウント作成",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
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
                              style:
                                  TextStyle(color: Colors.black, fontSize: 14),
                              children: <TextSpan>[
                                TextSpan(
                                    text: 'ログイン',
                                    style: TextStyle(
                                        color: Colors.black,
                                        decoration: TextDecoration.underline),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        nextScreen(context, const LoginPage());
                                      })
                              ],
                            ),
                          ),
                        ],
                      )),
                ),
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
