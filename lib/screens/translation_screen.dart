import 'package:flutter/material.dart';
import '../services/hand_stream.dart';
import '../services/gesture_rules.dart';
import '../services/smoother.dart';

class TranslationScreen extends StatefulWidget {
  const TranslationScreen({super.key});
  @override
  State<TranslationScreen> createState() => _TranslationScreenState();
}

class _TranslationScreenState extends State<TranslationScreen> {
  final hand = HandStream();
  final smoother = GestureSmoother(threshold: 5);
  String stableText = '—';
  String rawText = '';

  @override
  void initState() {
    super.initState();
    hand.stream.listen((pts) {
      final guess = GestureRules.classify(pts);
      final stable = smoother.update(guess);
      setState(() {
        rawText = guess;
        if (stable.isNotEmpty) stableText = stable;
      });
    });
    hand.start();
  }

  @override
  void dispose() {
    hand.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Dark background; native analyzer runs hidden.
          Positioned(
            left: 0, right: 0, bottom: 120,
            child: Center(
              child: Text(
                stableText,
                style: const TextStyle(color: Colors.white, fontSize: 42, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Positioned(
            left: 0, right: 0, bottom: 60,
            child: Center(
              child: Text(
                rawText.isEmpty ? '' : 'detecting: $rawText',
                style: const TextStyle(color: Colors.white70, fontSize: 16),
              ),
            ),
          ),
          Positioned(
            top: 48, left: 16,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: ()=> Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
}
