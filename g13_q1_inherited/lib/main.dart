import 'package:flutter/material.dart';

// 1) The InheritedWidget that holds shared data
class AppColor extends InheritedWidget {
  final Color color;

  const AppColor({super.key, required this.color, required super.child});

  // Read it from any descendant (a map lookup, not a tree walk)
  static AppColor of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<AppColor>();
    assert(result != null, 'No AppColor found above this context');
    return result!;
  }

  // Rebuild dependents only when the color really changed
  @override
  bool updateShouldNotify(AppColor oldWidget) => color != oldWidget.color;
}

void main() => runApp(const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Root(),
    ));

class Root extends StatefulWidget {
  const Root({super.key});

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  Color color = Colors.blue;

  @override
  Widget build(BuildContext context) {
    return AppColor(
      color: color,
      child: Scaffold(
        appBar: AppBar(title: const Text('InheritedWidget')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const DeepChild(), // reads the color without constructor passing
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => setState(() {
                  color = color == Colors.blue ? Colors.red : Colors.blue;
                }),
                child: const Text('Change color'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DeepChild extends StatelessWidget {
  const DeepChild({super.key});

  @override
  Widget build(BuildContext context) {
    final Color c = AppColor.of(context).color; // registers a dependency
    return Container(width: 120, height: 120, color: c);
  }
}
