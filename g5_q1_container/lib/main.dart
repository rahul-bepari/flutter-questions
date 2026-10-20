import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('Container')),
        body: Center(
          child: Container(
            color: Colors.blue,
            padding: const EdgeInsets.all(24),
            child: const Text(
              'Hello Flutter',
              style: TextStyle(fontSize: 28, color: Colors.white),
            ),
          ),
        ),
      ),
    ));
