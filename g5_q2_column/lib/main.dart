import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('Column')),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('First', style: TextStyle(fontSize: 24)),
              Text('Second', style: TextStyle(fontSize: 24)),
              Text('Third', style: TextStyle(fontSize: 24)),
            ],
          ),
        ),
      ),
    ));
