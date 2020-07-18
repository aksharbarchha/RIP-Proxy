import 'package:flutter/material.dart';

class UserWidget extends StatelessWidget {
  final String rollNum;

  const UserWidget({Key key, this.rollNum}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Container(
      decoration: new BoxDecoration(
          border: new Border.all(width: 1.0, color: Colors.blue),
          borderRadius: BorderRadius.circular(10),
          color: Colors.blue),
      margin: new EdgeInsets.symmetric(vertical: 5.0),
      child: new ListTile(
        title: new Text(
          rollNum,
          textAlign: TextAlign.left,
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
