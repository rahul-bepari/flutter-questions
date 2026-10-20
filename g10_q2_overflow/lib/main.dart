import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ProfilePage(),
    ));

const String bio =
    'I am a computer science student who loves building apps with Flutter. '
    'I enjoy solving problems, learning new tools, and sharing what I learn '
    'with my classmates.';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Overflow fixes')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Fix 1: Expanded around the Text',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                CircleAvatar(radius: 30, child: Icon(Icons.person)),
                SizedBox(width: 12),
                Expanded(child: Text(bio)), // text now wraps to the free width
              ],
            ),
            const SizedBox(height: 32),
            const Text('Fix 2: Change the layout (Column)',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(radius: 30, child: Icon(Icons.person)),
                SizedBox(height: 12),
                Text(bio), // a Column gives the text the full width
              ],
            ),
          ],
        ),
      ),
    );
  }
}
