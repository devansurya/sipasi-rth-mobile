import 'package:flutter/material.dart';

class AlertWidget extends StatelessWidget {
  final String message;
  final Color backgroundColor;
  final Color textColor;
  final IconData? icon;
  final VoidCallback? onClose;

  const AlertWidget({
    super.key,
    required this.message,
    this.backgroundColor = Colors.blue,
    this.textColor = Colors.white,
    this.icon,
    this.onClose = null,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      padding: EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          if (icon != null) Icon(icon, color: textColor),
          SizedBox(width: 8.0),
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: textColor),
            ),
          ),
          if (onClose != null)
            IconButton(
              icon: Icon(Icons.close, color: textColor),
              onPressed: onClose,
            ),
        ],
      ),
    );
  }
}