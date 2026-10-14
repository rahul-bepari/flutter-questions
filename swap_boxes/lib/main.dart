import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SwapPage(),
    ));

class CounterBox extends StatefulWidget {
  final String label;
  final Color color;

  const CounterBox({super.key, required this.label, required this.color});

  @override
  State<CounterBox> createState() => _CounterBoxState();
}

class _CounterBoxState extends State<CounterBox> {
  int taps = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => taps++),
      child: Container(
        width: 100,
        height: 100,
        color: widget.color,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(widget.label,
                style: const TextStyle(
                    fontSize: 28,
                    color: Colors.white,
                    fontWeight: FontWeight.bold)),
            Text('$taps',
                style: const TextStyle(fontSize: 22, color: Colors.white)),
          ],
        ),
      ),
    );
  }
}

class SwapPage extends StatefulWidget {
  const SwapPage({super.key});

  @override
  State<SwapPage> createState() => _SwapPageState();
}

class _SwapPageState extends State<SwapPage> {
  List<Widget> boxes = const [
    CounterBox(key: ValueKey('A'), label: 'A', color: Colors.red),
    CounterBox(key: ValueKey('B'), label: 'B', color: Colors.blue),
  ];

  void swap() {
    setState(() {
      boxes = boxes.reversed.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Swap the Boxes')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: boxes,
            ),
            const SizedBox(height: 30),
            ElevatedButton(onPressed: swap, child: const Text('Swap')),
          ],
        ),
      ),
    );
  }
}