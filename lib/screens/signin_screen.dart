import 'package:firebase_auth/firebase_auth.dart';
import 'package:voidremover/reusable_widgets/reusable_widget.dart';
import 'package:voidremover/screens/home_screen.dart';
import 'package:voidremover/screens/reset_password.dart';
import 'package:voidremover/screens/signup_screen.dart';
import 'package:voidremover/utils/color_utils.dart';
import 'package:flutter/material.dart';
import 'package:voidremover/screens/reset_password.dart';
import 'package:voidremover/screens/signup_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../reusable_widgets/reusable_widget.dart';
import '../utils/color_utils.dart';
import 'home_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {

  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          hexStringToColor("8fe7bc"),
          hexStringToColor("52959f"),
          hexStringToColor("286575")
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                20, MediaQuery.of(context).size.height * 0.1, 20, 0),
            child: Column(
              children: <Widget>[
                logoWidget("assets/images/logo1.png"),
                const SizedBox(
                  height: 30,
                ),
                reusableTextField(AppLocalizations.of(context)!.enteremailid, Icons.person_outline, false,
                    _emailTextController),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField(AppLocalizations.of(context)!.enterpassword, Icons.lock_outline, true,
                    _passwordTextController),
                const SizedBox(
                  height: 5,
                ),
                forgetPassword(context),
                firebaseUIButton(context, AppLocalizations.of(context)!.signin, () {
                  FirebaseAuth.instance
                      .signInWithEmailAndPassword(
                          email: _emailTextController.text,
                          password: _passwordTextController.text)
                      .then((value) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HomeScreen()));
                  }).onError((error, stackTrace) {
                    print("Error ${error.toString()}");
                  });
                }),
                signUpOption()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row signUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(AppLocalizations.of(context)!.donthaveaccount,
            style: TextStyle(color: Colors.white70)),
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SignUpScreen()));
          },
          child: Text(
            AppLocalizations.of(context)!.signup,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }

  Widget forgetPassword(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 35,
      alignment: Alignment.bottomRight,
      child: TextButton(
        child: Text(
          AppLocalizations.of(context)!.forgotpassword,
          style: TextStyle(color: Colors.white70),
          textAlign: TextAlign.right,
        ),
        onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => ResetPassword())),
      ),
    );
  }
}
