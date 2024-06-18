import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomTheme {
  static const Color textPrimaryColor = Color.fromRGBO(52, 63, 82, 1);
  static const Color textSecondaryColor = Color.fromRGBO(149, 156, 169, 1);
  static const Color textActiveColor = Color.fromRGBO(100, 163, 84, 1.0);
  static const Color textWhiteColor = Color.fromRGBO(237, 245, 239, 1.0);

  static const TextStyle primaryTextStyle = TextStyle(color: textPrimaryColor);
  static const TextStyle secondaryTextStyle = TextStyle(color: textSecondaryColor);
  static const TextStyle activeTextStyle = TextStyle(color: textActiveColor);
  static const TextStyle whiteTextStyle = TextStyle(color: textWhiteColor);

  static Text primaryText(String text) {
    return Text(text, style: primaryTextStyle);
  }

  static Text secondaryText(String text) {
    return Text(text, style: secondaryTextStyle);
  }

  static Text activeText(String text) {
    return Text(text, style: activeTextStyle);
  }

  static Text whiteText(String text) {
    return Text(text, style: whiteTextStyle);
  }

  static String formatDate(String dateStr) {
    // Parse the date string
    DateTime dateTime = DateFormat("yyyy-MM-dd HH:mm:ss").parse(dateStr);
    // Format the date to the desired format
    String formattedDate = DateFormat("dd MMM yyyy").format(dateTime).toUpperCase();
    return formattedDate;  // Output: 18 MAY 2024
  }
}
