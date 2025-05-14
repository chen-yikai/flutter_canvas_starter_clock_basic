import 'package:flutter/material.dart';
import 'package:flutter_canvas_starter/painter.dart';

void main() {
  runApp(Entry());
}

class Entry extends StatefulWidget {
  const Entry({super.key});

  @override
  State<Entry> createState() => _EntryState();
}

class _EntryState extends State<Entry> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("Flutter Canvas")),
        body: Center(
          child: SizedBox(
            width: 250,
            height: 250,
            child: CustomPaint(painter: CanvasPainter(), child: Container()),
          ),
        ),
      ),
    );
  }
}
