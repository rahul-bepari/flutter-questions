import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CardsPage(),
    ));

class InfoCard extends StatelessWidget {
  final String title;
  final Color color;
  const InfoCard({super.key, required this.title, required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      child: SizedBox(
        height: 120,
        child: Center(
          child: Text(title, style: const TextStyle(fontSize: 22)),
        ),
      ),
    );
  }
}

class CardsPage extends StatelessWidget {
  const CardsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('LayoutBuilder')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          const card1 = InfoCard(title: 'Card 1', color: Colors.lightBlue);
          const card2 = InfoCard(title: 'Card 2', color: Colors.orange);

          if (constraints.maxWidth >= 600) {
            // Enough width: side by side
            return const Row(
              children: [
                Expanded(child: card1),
                Expanded(child: card2),
              ],
            );
          } else {
            // Small width: vertical
            return const Column(
              children: [card1, card2],
            );
          }
        },
      ),
    );
  }
}
