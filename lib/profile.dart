import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:AttendanceTracker/globals.dart' as globals;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:AttendanceTracker/pages/login_signup_page.dart';
import 'welcome_page.dart';
import 'package:AttendanceTracker/services/authentication.dart';

class Profile extends StatefulWidget {
  final VoidCallback logoutCallback;
  final VoidCallback loginCallback;
  final BaseAuth auth;
  Profile({this.logoutCallback, this.loginCallback, this.auth});
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  signOutt() async {
    try {
      await signOut();
      widget.logoutCallback();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Attendance Tracker"),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(globals.name),
              accountEmail: Text(globals.email),
              currentAccountPicture: CircleAvatar(
                backgroundColor:
                    Theme.of(context).platform == TargetPlatform.iOS
                        ? Colors.blue
                        : Colors.white,
                child: Text(
                  "X",
                  style: TextStyle(fontSize: 40.0),
                ),
              ),
            ),
            Divider(
              height: 1,
              color: Colors.white,
            ),
            ListTile(
              title: Text('Home'),
              onTap: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => WelcomePage(
                              logoutCallback: widget.logoutCallback,
                              loginCallback: widget.loginCallback,
                              auth: widget.auth,
                            )));
              },
            ),
            ListTile(
              title: Text('Logout'),
              onTap: () {
                signOutt();
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LoginSignupPage(
                            loginCallback: widget.loginCallback,
                            auth: widget.auth)));
              },
            ),
          ],
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Text("Hello " + globals.name),
          ),
        ],
      ),
    );
  }
}
