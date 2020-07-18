import 'package:flutter/material.dart';
import 'package:AttendanceTracker/pages/login_signup_page.dart';
import 'package:AttendanceTracker/services/authentication.dart';
import 'package:AttendanceTracker/welcome_page.dart';
import 'package:AttendanceTracker/globals.dart' as globals;
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_login_demo/utils/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum AuthStatus {
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  LOGGED_IN,
}

class RootPage extends StatefulWidget {
  final BaseAuth auth;

  RootPage({this.auth});

  @override
  State<StatefulWidget> createState() => new _RootPageState();
}

class _RootPageState extends State<RootPage> {
  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;
  String _userId = "";
  String displayName = "Default";

  @override
  void initState() {
    super.initState();
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        if (user != null) {
          _userId = user?.uid;
        }
        authStatus =
            user?.uid == null ? AuthStatus.NOT_LOGGED_IN : AuthStatus.LOGGED_IN;
        if (user?.uid != null) {
          globals.email = user.email;
          //globals.name = 'User';
          displayName = user.displayName;
        }
      });
    });
  }

  void loginCallback() {
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        _userId = user.uid.toString();
        // String email = user.email;
        //String name = user.displayName; //?
        //globals.name = name;
        // globals.email = email;
        // globals.isLoggedIn = true;
        //print("Display Name   " + name);
        print('Login Call Back User: $_userId');
        print("user id mila");
        // getData();
      });
    });
    setState(() {
      authStatus = AuthStatus.LOGGED_IN;
      print("logged in!");
    });
  }

  void getData() async {
    // await widget.auth.getCurrentUser().then((user) {
    //   // setState(() {
    //   globals.email = user.email;

    //   // });
    // });
    final ds = await Firestore.instance
        .collection('Faculty')
        .document(globals.email)
        .get();
    setState(() {
      globals.name = ds['name'];
    });
  }
  // void homeCallback(){
  //    setState(() {
  //     authStatus = AuthStatus.LOGGED_IN;
  //   });
  // }

  void logoutCallback() {
    setState(() {
      authStatus = AuthStatus.NOT_LOGGED_IN;
      _userId = "";
    });
  }

  Widget buildWaitingScreen() {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.NOT_DETERMINED:
        return buildWaitingScreen();
        break;
      case AuthStatus.NOT_LOGGED_IN:
        return new LoginSignupPage(
          auth: widget.auth,
          loginCallback: loginCallback,
          //logoutCallback: logoutCallback,
        );
        break;
      case AuthStatus.LOGGED_IN:
        getData();

        if (_userId.length > 0 && _userId != null) {
          //print("Get data called");
          if (globals.name != 'User') {
            // print('User DisplayName=     ' + displayName);
            return WelcomePage(
              logoutCallback: logoutCallback,
              loginCallback: loginCallback,
              auth: widget.auth,
            );
          } else {
            return buildWaitingScreen();
          }
        } else
          return buildWaitingScreen();
        break;
      default:
        return buildWaitingScreen();
    }
  }
}
