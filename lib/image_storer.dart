// import 'dart:async';
// import 'package:flutter/material.dart';
import 'dart:io';

class ImageStorer
{
  static File storedimage;

  void setImage(File image) 
  {
    storedimage = image;
    print(storedimage);
  }
  
  File getImage()
  {
    return storedimage;
  }

  
}
