import 'package:auto_size_text/auto_size_text.dart';
import 'package:chatting_firebase/Views/Register.dart';
import 'package:chatting_firebase/services/firebasehelp.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  Service service = Service();
  bool _isloading = false;

  void _submit() {
    setState(() {
      _isloading = true;
    });
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        _isloading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: ModalProgressHUD(
          inAsyncCall: _isloading,
          child: Container(
            height: height,
            width: width,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: height * 0.1),
                  child: AutoSizeText(
                    '>>> Sign In >>>',
                    style: TextStyle(
                        color: Colors.lightBlue,
                        fontSize: 42.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: height * 0.1),
                TextingField(
                  height: height,
                  width: width,
                  hint: 'Enter Your Email',
                  input: TextInputType.emailAddress,
                  obs: false,
                  controllers: emailController,
                ),
                SizedBox(height: height * 0.01),
                TextingField(
                  height: height,
                  width: width,
                  hint: 'Enter Your Password',
                  input: TextInputType.visiblePassword,
                  obs: true,
                  controllers: passController,
                ),
                Text(
                  'Forgot Password?',
                  style:
                      TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: height * 0.03),
                ElevatedButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.lightBlue,
                    padding:
                        EdgeInsets.symmetric(horizontal: 100.0, vertical: 11.0),
                    elevation: 8.8,
                  ),
                  onPressed: () async {
                    SharedPreferences pref =
                        await SharedPreferences.getInstance();
                    _submit();
                    if (emailController.text.isNotEmpty &&
                        passController.text.isNotEmpty) {
                      service.loginUser(
                          context, emailController.text, passController.text);
                      pref.setString("email", emailController.text);
                    } else {
                      service.errorBox(context,
                          "Fields must not empty please provide valid email and password");
                    }
                  },
                  child: AutoSizeText(
                    'LOGIN',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.leftToRight,
                            child: Register()));
                  },
                  child: AutoSizeText('I don,t have any account?'),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32.0),
                  child: Divider(
                    color: Colors.grey.shade500,
                  ),
                ),
                SizedBox(height: height * 0.06),
                Padding(
                  padding: EdgeInsets.only(top: height * 0.04),
                  child: Googlebutton(
                    height: height,
                    width: width,
                  ),
                ),
                SizedBox(height: height * 0.1),
                Container(
                  child: AutoSizeText(
                    '@CopyRight Messaging App 2021',
                    style: TextStyle(
                      color: Colors.grey.shade400,
                      wordSpacing: 1.0,
                      fontSize: 11.0,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

//Textfield:
class TextingField extends StatelessWidget {
  const TextingField({
    required this.height,
    required this.width,
    required this.hint,
    required this.input,
    required this.obs,
    required this.controllers,
  });

  final double height;
  final double width;
  final String hint;
  final TextInputType input;
  final bool obs;
  final TextEditingController controllers;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height * 0.08,
      width: width * 0.8,
      child: TextFormField(
        controller: controllers,
        obscureText: obs,
        keyboardType: input,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            fontWeight: FontWeight.w400,
            color: Colors.grey.shade400,
          ),
        ),
      ),
    );
  }
}

//SignIn Google button:
class Googlebutton extends StatelessWidget {
  final double height;
  final double width;

  Googlebutton({required this.height, required this.width});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        width: width * 0.9,
        height: height * 0.097,
        child: Card(
          elevation: 8.0,
          color: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
            side: BorderSide(width: 1, color: Colors.lightBlue),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset('images/g.svg',
                  height: height * 0.06, width: width * 0.03),
              SizedBox(width: width * 0.05),
              AutoSizeText(
                'Google Sign In',
                style: TextStyle(color: Colors.grey, fontSize: 17.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
