import 'dart:async';
import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SearchPage(),
    ));

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;
  String _result = 'Type to search';
  int _searchCount = 0;

  void _onChanged(String text) {
    _debounce?.cancel(); // cancel the previous timer
    _debounce = Timer(const Duration(milliseconds: 500), () {
      // runs only if the user stopped typing for 500 ms
      setState(() {
        _searchCount++;
        _result = 'Searched for: "$text"';
      });
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Debounced Search')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              onChanged: _onChanged,
              decoration: const InputDecoration(
                labelText: 'Search',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Text(_result, style: const TextStyle(fontSize: 20)),
            Text('Searches executed: $_searchCount'),
          ],
        ),
      ),
    );
  }
}
