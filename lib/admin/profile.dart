import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  final String profilePicUrl = '';
  final String name = 'name test';
  final String phoneNumber = '008923';
  final String address = 'depok';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Center(
              child: CircleAvatar(
                radius: 100,
                backgroundImage: AssetImage('images/default-card.jpg'),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              name,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Row(
              children: <Widget>[
                Icon(Icons.phone),
                SizedBox(width: 10),
                Text(
                  phoneNumber,
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: <Widget>[
                Icon(Icons.home),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    address,
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}