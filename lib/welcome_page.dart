import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:AttendanceTracker/globals.dart' as globals;
import 'profile.dart';
import 'package:AttendanceTracker/services/authentication.dart';

class WelcomePage extends StatefulWidget {
  final VoidCallback logoutCallback;
  final VoidCallback loginCallback;
  final BaseAuth auth;
  WelcomePage({this.logoutCallback, this.loginCallback, this.auth});
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  // signOutt() async {
  //   try {
  //     await signOut();
  //     widget.logoutCallback();
  //   } catch (e) {
  //     print(e);
  //   }

  String yearDropdownValue = 'SY';
  String divisionDropdownValue = 'A';
  String subjectDropdownValue = 'RDBMS';
  String lectureDropdownValue = '1';
  String formattedTime;
  // String displayName;
  // String email;

  @override
  void initState() {
    DateTime now = DateTime.now();
    formattedTime = DateFormat('hh:mm').format(now);
    Timer.periodic(Duration(seconds: 60), (Timer t) => _getTime());
    super.initState();
    //getData();
  }

  void _getTime() {
    final DateTime now = DateTime.now();
    final String formattedDateTime = DateFormat('hh:mm').format(now);
    setState(() {
      formattedTime = formattedDateTime;
    });
  }

  // void getData() async {
  //   final ds = await Firestore.instance
  //       .collection('Faculty')
  //       .document(globals.email)
  //       .get();
  //   globals.name = ds['name'];
  //   // await FirebaseAuth.instance
  //   //     .currentUser()
  //   //     .then((value) => email = value.email);
  //   // globals.email = email;
  //   // globals.name = displayName;
  // }

  void setData() async {
    await Firestore.instance
        .collection('Faculty')
        .document(globals.email)
        .collection('Lecture')
        .document(subjectDropdownValue + lectureDropdownValue)
        .setData({
      'division': divisionDropdownValue,
      'year': yearDropdownValue,
      'subject': subjectDropdownValue,
      'lecture_num': lectureDropdownValue
    });
  }

  DropdownButton dropdown(List<String> list, String type, String val) {
    return DropdownButton<String>(
      value: val,
      icon: Icon(Icons.arrow_drop_down),
      iconSize: 24,
      elevation: 16,
      style: TextStyle(color: Color(0xFFF9AA33), fontWeight: FontWeight.bold),
      underline: Container(
        height: 2,
        color: Colors.blue,
      ),
      onChanged: (String newValue) {
        setState(() {
          if (type == "Division") divisionDropdownValue = newValue;
          if (type == "Year") yearDropdownValue = newValue;
          if (type == "Lecture") lectureDropdownValue = newValue;
          if (type == "Subject") subjectDropdownValue = newValue;
        });
      },
      items: list.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            style:
                GoogleFonts.hindMadurai(textStyle: TextStyle(fontSize: 24.0)),
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('EEE, d MMMM').format(now);
    //formattedTime = DateFormat('hh:mm').format(now);
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
              accountName: Text(globals.name ??
                  'Loading...'), // name obtained from query in getData
              accountEmail: Text(globals.email ?? "Loading..."),
              currentAccountPicture: CircleAvatar(
                backgroundColor:
                    Theme.of(context).platform == TargetPlatform.iOS
                        ? Colors.blue
                        : Colors.white,
                child: Text(
                  globals.name[0] ?? "U",
                  style: TextStyle(fontSize: 40.0),
                ),
              ),
            ),
            Divider(
              height: 1,
              color: Colors.white,
            ),
            ListTile(
              title: Text('Profile'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Profile(
                              logoutCallback: widget.logoutCallback,
                              loginCallback: widget.loginCallback,
                              auth: widget.auth,
                            )));
              },
            ),
            ListTile(
              title: Text('Logout'),
              onTap: () {
                // signOutt();
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(0, 20, 0, 50),
            alignment: Alignment.topCenter,
            child: Text(
              "Welcome " + globals.name + " !" ?? "User",
              style: TextStyle(fontSize: 24.0),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(
                formattedDate,
                style: GoogleFonts.workSans(
                    textStyle:
                        TextStyle(fontSize: 38.0, fontWeight: FontWeight.bold)),
              ),
              Text(
                formattedTime,
                style: GoogleFonts.workSans(
                    textStyle:
                        TextStyle(fontSize: 34.0, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          Flexible(
            child: Padding(
              padding: EdgeInsets.fromLTRB(70, 0, 70, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Divider(
                    color: Colors.white,
                    thickness: 2,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Subject",
                        // style: TextStyle(fontSize: 24.0),
                        style: GoogleFonts.hindMadurai(
                            textStyle: TextStyle(fontSize: 26.0)),
                      ),
                      dropdown(['PSOT', 'AOA', 'TACD', 'RDBMS'], "Subject",
                          subjectDropdownValue),
                    ],
                  ),
                  Divider(
                    color: Colors.white,
                    thickness: 2,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Year",
                        style: GoogleFonts.hindMadurai(
                            textStyle: TextStyle(fontSize: 26.0)),
                      ),
                      dropdown(['SY', 'TY', 'LY'], "Year", yearDropdownValue),
                    ],
                  ),
                  Divider(
                    color: Colors.white,
                    thickness: 2,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Division",
                        style: GoogleFonts.hindMadurai(
                            textStyle: TextStyle(fontSize: 26.0)),
                      ),
                      dropdown(['A', 'B'], "Division", divisionDropdownValue),
                    ],
                  ),
                  Divider(
                    color: Colors.white,
                    thickness: 2,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Lecture",
                        style: GoogleFonts.hindMadurai(
                            textStyle: TextStyle(fontSize: 26.0)),
                      ),
                      dropdown(['1', '2', '3', '4'], "Lecture",
                          lectureDropdownValue),
                    ],
                  ),
                  Divider(
                    color: Colors.white,
                    thickness: 2,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 40),
                    child: CupertinoButton(
                      // color: Colors.deepPurpleAccent[200],
                      color: Colors.blue,
                      // splashColor: Color(0xFFF9AA33),
                      borderRadius: BorderRadius.circular(20),
                      // borderRadius: BorderRadius.circular(20.0),
                      onPressed: () {
                        setData();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomePage(
                                    yearDropdownValue: yearDropdownValue,
                                    divisionDropdownValue:
                                        divisionDropdownValue,
                                    subjectDropdownValue: subjectDropdownValue,
                                    lectureDropdownValue: lectureDropdownValue,
                                    logoutCallback: widget.logoutCallback,
                                    loginCallback: widget.loginCallback,
                                    auth: widget.auth)));
                      },
                      child: Text(
                        "Submit",
                        style: TextStyle(
                          fontSize: 22.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
