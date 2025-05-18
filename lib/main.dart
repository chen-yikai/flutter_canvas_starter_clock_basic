import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
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

class _EntryState extends State<Entry> with SingleTickerProviderStateMixin {
  int seconds = 0;
  bool pause = true;
  bool done = false;
  late Timer timer;
  late AnimationController shakeController;
  late Animation<double> shakeAnimation;

  @override
  void initState() {
    super.initState();
    shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100), // Total for 4 rotation steps
    );
    shakeAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0, end: 1 * pi / 180),
        weight: 25, // 100ms
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1 * pi / 180, end: 0),
        weight: 25, // 100ms
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0, end: -1 * pi / 180),
        weight: 25, // 100ms
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: -1 * pi / 180, end: 0),
        weight: 25, // 100ms
      ),
    ]).animate(CurvedAnimation(
      parent: shakeController,
      curve: Curves.linear,
    ));
  }

  void _triggerShake() {
    shakeController.repeat();
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
      done = false;
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
          done = true;
          _triggerShake();
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
            child: RotationTransition(
              turns: shakeAnimation,
              child: SizedBox(
                width: 300,
                height: 300,
                child: CustomPaint(
                    painter: CanvasPainter(seconds: seconds),
                    child: Container()),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    TextEditingController mm = TextEditingController(),
                        ss = TextEditingController();
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
                                    controller: mm,
                                    decoration: const InputDecoration(
                                        hintText: "Minutes"),
                                    keyboardType: TextInputType.number,
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: TextField(
                                    decoration: const InputDecoration(
                                        hintText: "Seconds"),
                                    keyboardType: TextInputType.number,
                                    controller: ss,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  seconds = (int.tryParse(mm.text) ?? 0) * 60 +
                                      (int.tryParse(ss.text) ?? 0);
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
                if (done) {
                  setState(() {
                    done = false;
                  });
                  shakeController.reset();
                } else {
                  startTimer();
                }
              } else {
                pauseTimer();
              }
            },
            child: Icon(pause
                ? done
                    ? Icons.stop
                    : Icons.play_arrow
                : Icons.pause),
          )
        ],
      ),
    );
  }
}
