import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: EditorPage(),
    ));

class EditorPage extends StatefulWidget {
  const EditorPage({super.key});

  @override
  State<EditorPage> createState() => _EditorPageState();
}

class _EditorPageState extends State<EditorPage> {
  final TextEditingController controller = TextEditingController();
  final List<String> undoStack = [];
  final List<String> redoStack = [];
  String current = '';

  void onChanged(String value) {
    setState(() {
      undoStack.add(current); // save the old text
      current = value;
      redoStack.clear();      // a new edit removes the redo history
    });
  }

  void undo() {
    if (undoStack.isEmpty) return;
    setState(() {
      redoStack.add(current);
      current = undoStack.removeLast();
      _showText();
    });
  }

  void redo() {
    if (redoStack.isEmpty) return;
    setState(() {
      undoStack.add(current);
      current = redoStack.removeLast();
      _showText();
    });
  }

  void _showText() {
    controller.text = current;
    controller.selection = TextSelection.collapsed(offset: current.length);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Undo / Redo')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: controller,
              onChanged: onChanged,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'Type here...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: undoStack.isEmpty ? null : undo,
                  icon: const Icon(Icons.undo),
                  label: const Text('Undo'),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: redoStack.isEmpty ? null : redo,
                  icon: const Icon(Icons.redo),
                  label: const Text('Redo'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text('Undo stack: ${undoStack.length}   Redo stack: ${redoStack.length}'),
          ],
        ),
      ),
    );
  }
}
