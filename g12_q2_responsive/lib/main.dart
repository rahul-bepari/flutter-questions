import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ResponsivePage(),
    ));

class ResponsivePage extends StatelessWidget {
  const ResponsivePage({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(title: Text('Width: ${screenWidth.toStringAsFixed(0)} px')),
      // 1) SingleChildScrollView: tall content scrolls instead of being cut off
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 2) LayoutBuilder: Row on wide screens, Column on narrow screens
            LayoutBuilder(
              builder: (context, constraints) {
                final panels = [
                  Container(
                      height: 100,
                      color: Colors.lightBlue,
                      alignment: Alignment.center,
                      child: const Text('Panel 1')),
                  Container(
                      height: 100,
                      color: Colors.orange,
                      alignment: Alignment.center,
                      child: const Text('Panel 2')),
                ];
                if (constraints.maxWidth > 600) {
                  return Row(
                    children: panels.map((p) => Expanded(child: p)).toList(),
                  );
                }
                return Column(children: panels);
              },
            ),
            const SizedBox(height: 24),
            // 3) Wrap: chips flow to the next line when space runs out
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: List.generate(
                12,
                (i) => Chip(label: Text('Chip ${i + 1}')),
              ),
            ),
            const SizedBox(height: 24),
            // 4) More content than the screen height: scrolls thanks to (1)
            ...List.generate(
              10,
              (i) => ListTile(title: Text('Item ${i + 1}')),
            ),
          ],
        ),
      ),
    );
  }
}
