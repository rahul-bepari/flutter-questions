import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ApiPage(),
    ));

class ApiPage extends StatefulWidget {
  const ApiPage({super.key});

  @override
  State<ApiPage> createState() => _ApiPageState();
}

class _ApiPageState extends State<ApiPage> {
  bool loading = false;
  String message = 'Press the button';

  Future<void> loadData() async {
    setState(() {
      loading = true;
      message = '';
    });
    try {
      final res = await http
          .get(Uri.parse('https://jsonplaceholder.typicode.com/posts/1'))
          .timeout(const Duration(seconds: 10));

      if (res.statusCode != 200) {
        throw Exception('Server error: ${res.statusCode}');
      }
      final data = jsonDecode(res.body);
      if (!mounted) return;
      setState(() => message = data['title']);
    } on TimeoutException {
      if (mounted) setState(() => message = 'Request timed out. Try again.');
    } catch (e) {
      if (mounted) setState(() => message = 'Error: $e');
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Future / async / await')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (loading) const CircularProgressIndicator(),
              Text(message, textAlign: TextAlign.center),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: loading ? null : loadData,
                child: const Text('Load Data'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
