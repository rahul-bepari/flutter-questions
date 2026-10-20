import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(body: Center(child: LikeButton())),
    ));

class LikeButton extends StatefulWidget {
  const LikeButton({super.key});

  @override
  State<LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  int likes = 0; // lives in the State, so it survives rebuilds

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        setState(() {
          likes++;
        });
      },
      icon: const Icon(Icons.thumb_up),
      label: Text('Likes: $likes'),
    );
  }
}
