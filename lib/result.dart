import 'package:flutter/material.dart';
import 'userwidget.dart';

class Result extends StatelessWidget {
  final List userdetails;
  Result({this.userdetails});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF121212),
      appBar: AppBar(
        title: Text("Attendance Tracker"),
        backgroundColor: Color(0xFF323232),
      ),
      body: new ListView.builder(
        padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
        itemBuilder: (BuildContext context, int index) {
          return new UserWidget(
            // firstName: userdetails[index]['first_name'],
            // lastName: userdetails[index]['last_name'],
            rollNum: userdetails[index],
          );
        },
        itemCount: userdetails.length,
      ),
    );
  }
}
