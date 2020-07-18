import 'package:flutter/material.dart';
import 'globals.dart' as globals;
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as Path;
import 'api.dart';
import 'dart:convert';
import 'result.dart';
import 'package:google_fonts/google_fonts.dart';

class SelectPicture extends StatefulWidget {
  final File image;
  final String yearDropdownValue;
  final String divisionDropdownValue;
  final String subjectDropdownValue;
  final String lectureDropdownValue;
  SelectPicture({
    this.yearDropdownValue,
    this.divisionDropdownValue,
    this.subjectDropdownValue,
    this.lectureDropdownValue,
    this.image,
  });
  @override
  _SelectPictureState createState() => _SelectPictureState();
}

class _SelectPictureState extends State<SelectPicture> {
  var data;
  List studentsList = new List();

  Future getResponse(String uploadedFileURL) async {
    print("Andar Aaya!");
    print("URL Dekho:\n" + uploadedFileURL);
    // xxxxxxxxxxxx.ngrok.io
    var url = 'http://a82868d8e61a.ngrok.io/home?Query=' + uploadedFileURL;
    print("aaya");

    data = await getImageData(url);
    print("lavkar");
    var output = jsonDecode(data);
    print("output mila  \n");
    print(output.toString());
    // output = output.sort();
    print("Type\n" + output.runtimeType.toString());
    Navigator.pop(context);
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => Result(userdetails: output)));
  }

  Future uploadFile() async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Detecting Faces..."),
            backgroundColor: Colors.black,
            content: Row(
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CircularProgressIndicator(),
                SizedBox(
                  width: 15,
                  height: 5,
                ),
                Text(
                  "Please wait for a moment!",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          );
        });
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('Images/${Path.basename(widget.image.path)}');
    StorageUploadTask uploadTask = storageReference.putFile(widget.image);
    print("Upload Done  \n");
    print("Getting url \n");

    var dowurl = await (await uploadTask.onComplete).ref.getDownloadURL();
    String _uploadedFileURL = dowurl.toString();

    // storageReference.getDownloadURL().then((fileURL) {
    //   setState(() async {
    //     _uploadedFileURL = await fileURL;
    //   });
    // });

    print("\n\n");
    print("image:  \n" + _uploadedFileURL);
    Firestore.instance
        .collection('Faculty')
        .document(globals.email)
        .collection('Lecture')
        .document(widget.subjectDropdownValue + widget.lectureDropdownValue)
        .setData({
      'imageURL': _uploadedFileURL,
      'division': widget.divisionDropdownValue,
      'lecture_num': widget.lectureDropdownValue,
      'subject': widget.subjectDropdownValue,
      'year': widget.yearDropdownValue,
    });

    await getResponse(_uploadedFileURL);
    print("pass kia");
    // print("b \n" + _uploadedFileURL);
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
                  globals.name[0] ?? "U",
                  style: TextStyle(fontSize: 40.0),
                ),
              ),
            ),
            Divider(
              height: 1,
              color: Colors.white,
            ),
            // ListTile(
            //   title: Text('Home'),
            //   onTap: () {},
            // ),
            // ListTile(
            //   title: Text('Profile'),
            //   onTap: () {},
            // ),
          ],
        ),
      ),
      body: Container(
        child: Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                        padding: EdgeInsets.fromLTRB(7, 50, 7, 0),
                        // height: 350,
                        // width: 300,

                        child: Image.file(
                          widget.image,
                          // height: 350,
                          // width: 300,
                        )),
                    SizedBox(
                      height: 60,
                      // width: 20,
                    ),
                    Flexible(
                      fit: FlexFit.loose,
                      child: Text(
                          "Want to know how many students are present in your class? Click below to get the answer!",
                          textAlign: TextAlign.center,
                          softWrap: true,
                          style: GoogleFonts.montserrat(
                            textStyle: TextStyle(
                              fontSize: 25.0,
                            ),
                          )),
                    ),
                    SizedBox(
                      height: 50,
                      width: 20,
                    ),
                    RaisedButton.icon(
                      label: Text(
                        "Present Students",
                        style: TextStyle(fontSize: 25),
                      ),
                      padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
                      textColor: Colors.white,
                      icon: Icon(Icons.camera, color: Colors.white),
                      color: Colors.blue,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(17)),
                      onPressed: () async {
                        await uploadFile();
                        // Navigator.push(context,
                        //     MaterialPageRoute(builder: (context) => Predict()));
                      },
                    ),
                    SizedBox(
                      height: 60,
                      // width: 20,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
