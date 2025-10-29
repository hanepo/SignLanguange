import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
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
          // Show warning message on web platform
          if (kIsWeb)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.warning_amber_rounded,
                      color: Colors.orange,
                      size: 80,
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Camera Hand Tracking Not Available on Web',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'This feature requires native camera access and hand tracking, which is only available on Android and iOS devices.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Please use the mobile app to access real-time sign language translation.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                  ],
                ),
              ),
            )
          else ...[
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
          ],
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
