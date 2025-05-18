import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_canvas_starter/painter.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Entry(),
  ));
}

class Entry extends StatefulWidget {
  const Entry({super.key});

  @override
  State<Entry> createState() => _EntryState();
}

class _EntryState extends State<Entry> {
  int seconds = 0;
  bool pause = true;
  late Timer timer;
  late AnimationController shakeController;
  late Animation<Offset> shakeAnimation;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  String timeFormatter(int seconds) {
    final mm = seconds ~/ 60;
    final ss = seconds % 60;
    return "${mm.toString().padLeft(2, "0")}:${ss.toString().padLeft(2, "0")}";
  }

  void startTimer() {
    setState(() {
      pause = false;
    });
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (seconds > 0) {
        setState(() {
          seconds--;
        });
      } else {
        setState(() {
          timer.cancel();
          pause = true;
        });
      }
    });
  }

  void pauseTimer() {
    timer.cancel();
    setState(() {
      pause = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Canvas Timer")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: SizedBox(
              width: 300,
              height: 300,
              child: CustomPaint(
                  painter: CanvasPainter(seconds: seconds), child: Container()),
            ),
          ),
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    int mm = 0;
                    int ss = 0;
                    return Container(
                      width: double.infinity,
                      height: double.infinity,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Container(
                              width: 50,
                              height: 5,
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(50),
                              ),
                            ),
                          ),
                          const Text("Set the time",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 30)),
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    decoration: const InputDecoration(
                                        hintText: "Minutes"),
                                    keyboardType: TextInputType.number,
                                    onChanged: (text) {
                                      mm = int.tryParse(text) ?? 0;
                                    },
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: TextField(
                                    decoration: const InputDecoration(
                                        hintText: "Seconds"),
                                    keyboardType: TextInputType.number,
                                    onChanged: (text) {
                                      ss = int.tryParse(text) ?? 0;
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  seconds = mm * 60 + ss;
                                });
                                Navigator.pop(context);
                              },
                              child: const Text("Done"))
                        ],
                      ),
                    );
                  });
            },
            child: Text(timeFormatter(seconds),
                style:
                    const TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 40),
          FloatingActionButton(
            onPressed: () {
              if (pause) {
                startTimer();
              } else {
                pauseTimer();
              }
            },
            child: Icon(pause ? Icons.play_arrow : Icons.pause),
          )
        ],
      ),
    );
  }
}
