import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ImagePage(),
    ));

class ImagePage extends StatelessWidget {
  const ImagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Image.asset vs Image.network')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text('Image.asset (works offline)'),
            const SizedBox(height: 8),
            Image.asset(
              'assets/logo.png',
              height: 120,
              errorBuilder: (context, error, stack) =>
                  const Text('Add assets/logo.png and list it in pubspec.yaml'),
            ),
            const SizedBox(height: 32),
            const Text('Image.network (needs internet)'),
            const SizedBox(height: 8),
            Image.network(
              'https://flutter.dev/assets/lockup_flutter_horizontal.d0515092173211776ceed19b39c2a041.png',
              height: 120,
              loadingBuilder: (context, child, progress) {
                if (progress == null) return child;
                return const CircularProgressIndicator();
              },
              errorBuilder: (context, error, stack) =>
                  const Text('Could not load the image'),
            ),
          ],
        ),
      ),
    );
  }
}
