import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class Helper {
  static String formatDate(String dateStr, {String format = "dd MMM yyyy", String fromFormat="yyyy-MM-dd HH:mm:ss"}) {
    // Parse the date string
    DateTime dateTime = DateFormat(fromFormat).parse(dateStr);
    // Format the date to the desired format
    String formattedDate = DateFormat(format).format(dateTime).toUpperCase();
    return formattedDate;  // Output: 18 MAY 2024
  }

  static Widget badge({String text = '', String type = 'success'}) {
    Color bgColor = Colors.green;
    if(type == 'warning') {
      bgColor = Color.fromRGBO(255, 170, 5, 1);
    }
    else if(type == 'error'){
      bgColor = Colors.red;
    }
    else if(type == 'info'){
      bgColor = Colors.blueAccent;
    }

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(10.0), bottom: Radius.circular(10.0)),
      child: Container(
        color: bgColor,
        padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
        child: Text(text, style: const TextStyle(color: Colors.white),),
      ),
    );
  }
  static Widget button(String text, {required Function() callback, String type = 'success', IconData? icon,}) {
    Color bgColor = Colors.green;
    if (type == 'warning') {
      bgColor = Color.fromRGBO(255, 170, 5, 1);
    } else if (type == 'error') {
      bgColor = Colors.red;
    } else if (type == 'info') {
      bgColor = Colors.blueAccent;
    }
    Widget child = Text(text, style: const TextStyle(color: Colors.white));
    if(icon != null) {
      child = Row(
        children: [
          Text(text, style: const TextStyle(color: Colors.white)),
          FaIcon(icon, color: Colors.white, size: 14,)
        ],
      );
    }


    return ElevatedButton(
      onPressed: callback,
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor,
        padding: EdgeInsets.all(0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),

      ),
      child: child,
    );
  }
  static Widget circleIndicator() {
    return Container(
      color: Colors.white, // Set the background color to white
      child: const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue), // Example color
        ),
      ),
    );
  }

}