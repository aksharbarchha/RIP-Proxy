import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'ReusableCard.dart';
import 'dart:io';
import 'image_storer.dart';
import 'dart:async';
import 'package:image_picker/image_picker.dart';
import 'package:AttendanceTracker/globals.dart' as globals;
import 'profile.dart';
import 'welcome_page.dart';
import 'package:AttendanceTracker/services/authentication.dart';
import 'selectpic.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:path/path.dart' as Path;
// import 'api.dart';
// import 'dart:convert';
// import 'result.dart';

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/firebase_database.dart';

class HomePage extends StatefulWidget {
  final String yearDropdownValue;
  final String divisionDropdownValue;
  final String subjectDropdownValue;
  final String lectureDropdownValue;
  final VoidCallback logoutCallback;
  final VoidCallback loginCallback;
  final BaseAuth auth;
  HomePage(
      {this.yearDropdownValue,
      this.divisionDropdownValue,
      this.subjectDropdownValue,
      this.lectureDropdownValue,
      this.logoutCallback,
      this.loginCallback,
      this.auth});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final object = ImageStorer();
  File _image;
  final picker = ImagePicker();
  var data;
  List studentsList = new List();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      _image = File(pickedFile.path);
      object.setImage(_image);
    });
  }

  pickImageFromGallery(ImageSource source) async {
    final pickedFile = await picker.getImage(source: source);
    // var image = await ImagePicker.pickImage(source: source);
    setState(() {
      _image = File(pickedFile.path);
      object.setImage(_image);
      // _loading = false;
      // print(_image);
    });
  }

  // Future getResponse(String uploadedFileURL) async {
  //   print("Andar Aaya!");
  //   print("URL Dekho:\n" + uploadedFileURL);
  //   // xxxxxxxxxxxx.ngrok.io
  //   var url = 'http://a82868d8e61a.ngrok.io/home?Query=' + uploadedFileURL;
  //   print("aaya");

  //   data = await getImageData(url);
  //   print("lavkar");
  //   var output = jsonDecode(data);
  //   print("output mila  \n");
  //   print(output.toString());
  //   print("Type\n" + output.runtimeType.toString());
  //   Navigator.push(context,
  //       MaterialPageRoute(builder: (context) => Result(userdetails: output)));
  // }

  // Future uploadFile() async {
  //   StorageReference storageReference = FirebaseStorage.instance
  //       .ref()
  //       .child('Images/${Path.basename(_image.path)}');
  //   StorageUploadTask uploadTask = storageReference.putFile(_image);
  //   print("Upload Done  \n");
  //   print("Getting url \n");

  //   var dowurl = await (await uploadTask.onComplete).ref.getDownloadURL();
  //   String _uploadedFileURL = dowurl.toString();

  //   // storageReference.getDownloadURL().then((fileURL) {
  //   //   setState(() async {
  //   //     _uploadedFileURL = await fileURL;
  //   //   });
  //   // });

  //   print("\n\n");
  //   print("image:  \n" + _uploadedFileURL);
  //   Firestore.instance
  //       .collection('Faculty')
  //       .document(globals.email)
  //       .collection('Lecture')
  //       .document(widget.subjectDropdownValue + widget.lectureDropdownValue)
  //       .setData({
  //     'imageURL': _uploadedFileURL,
  //     'division': widget.divisionDropdownValue,
  //     'lecture_num': widget.lectureDropdownValue,
  //     'subject': widget.subjectDropdownValue,
  //     'year': widget.yearDropdownValue,
  //   });

  //   await getResponse(_uploadedFileURL);
  //   print("pass kia");
  //   // print("b \n" + _uploadedFileURL);
  // }

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
              title: Text('Home'),
              onTap: () {
                Navigator.push(
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
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(
                  child: ReusableCard(
                    colour: Color(0xFFffc738),
                    cardChild: Padding(
                      padding: EdgeInsets.all(5),
                      child: Text(
                        widget.yearDropdownValue,
                        style: TextStyle(fontSize: 38.0),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    onPress: () {},
                  ),
                ),
                Expanded(
                  child: ReusableCard(
                    colour: Colors.blue,
                    cardChild: Padding(
                      padding: EdgeInsets.all(5),
                      child: Text(
                        widget.divisionDropdownValue,
                        style: TextStyle(fontSize: 38.0),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    onPress: () {},
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Expanded(
                  child: ReusableCard(
                    colour: Colors.blue,
                    cardChild: Padding(
                      padding: EdgeInsets.all(5),
                      child: Text(
                        widget.subjectDropdownValue,
                        style: TextStyle(fontSize: 38.0),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    onPress: () {},
                  ),
                ),
                Expanded(
                  child: ReusableCard(
                    colour: Color(0xFFffc738),
                    cardChild: Padding(
                      padding: EdgeInsets.all(5),
                      child: Text(
                        "LEC " + widget.lectureDropdownValue,
                        style: TextStyle(fontSize: 38.0),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    onPress: () {},
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 80,
              width: 50,
            ),
            Padding(
              padding: EdgeInsets.only(top: 80),
              child: Row(
                children: <Widget>[
                  Flexible(
                    child: Text("Track the Attendance by clicking below!",
                        textAlign: TextAlign.center,
                        softWrap: true,
                        style: GoogleFonts.montserrat(
                          textStyle: TextStyle(
                            fontSize: 32.0,
                          ),
                        )),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 100,
              width: 50,
            ),
            Container(
              // height: 50,
              // width: 200,
              child: RaisedButton.icon(
                label: Text(
                  "Open Camera",
                  style: TextStyle(fontSize: 25),
                ),
                padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
                textColor: Colors.white,
                icon: Icon(Icons.camera, color: Colors.white),
                color: Colors.blue,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(17)),
                onPressed: () async {
                  await getImage();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SelectPicture(
                              image: _image,
                              yearDropdownValue: widget.yearDropdownValue,
                              subjectDropdownValue: widget.subjectDropdownValue,
                              divisionDropdownValue:
                                  widget.divisionDropdownValue,
                              lectureDropdownValue:
                                  widget.lectureDropdownValue)));
                },
              ),
            ),
            SizedBox(
              height: 50,
              width: 50,
            ),
            Container(
              // height: 50,
              // width: 200,
              child: RaisedButton.icon(
                label: Text(
                  "Open Gallery",
                  style: TextStyle(fontSize: 26),
                ),
                padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
                textColor: Colors.white,
                icon: Icon(Icons.camera, color: Colors.white),
                color: Colors.blue,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(17)),
                onPressed: () async {
                  await pickImageFromGallery(ImageSource.gallery);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SelectPicture(
                                image: _image,
                                yearDropdownValue: widget.yearDropdownValue,
                                subjectDropdownValue:
                                    widget.subjectDropdownValue,
                                lectureDropdownValue:
                                    widget.lectureDropdownValue,
                                divisionDropdownValue:
                                    widget.divisionDropdownValue,
                              )));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
