import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  final String profilePicUrl = '';
  final String name = 'name test';
  final String phoneNumber = '008923';
  final String address = 'depok';

  const Profile({super.key});

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
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              children: <Widget>[
                const Icon(Icons.phone),
                const SizedBox(width: 10),
                Text(
                  phoneNumber,
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: <Widget>[
                const Icon(Icons.home),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    address,
                    style: const TextStyle(fontSize: 18),
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