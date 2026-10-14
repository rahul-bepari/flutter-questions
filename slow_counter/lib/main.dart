import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    ));

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SlowCounterPage()),
            );
          },
          child: const Text('Open Counter'),
        ),
      ),
    );
  }
}

class SlowCounterPage extends StatefulWidget {
  const SlowCounterPage({super.key});

  @override
  State<SlowCounterPage> createState() => _SlowCounterPageState();
}

class _SlowCounterPageState extends State<SlowCounterPage> {
  int counter = 0;      // Trap 1: must be here, NOT inside build()
  bool running = false; // Trap 2: stops duplicate loops

  Future<void> addSlowly() async {
    setState(() => running = true);
    for (int i = 0; i < 3; i++) {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return; // Trap 3: screen may be closed by now
      setState(() => counter++);
    }
    setState(() => running = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Slow Counter')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('$counter',
                style: const TextStyle(
                    fontSize: 56,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => setState(() => counter++),
              child: const Text('+1'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: running ? null : addSlowly,
              child: Text(running ? 'Running...' : '+3 Slowly'),
            ),
          ],
        ),
      ),
    );
  }
}