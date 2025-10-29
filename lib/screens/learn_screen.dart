import 'package:flutter/material.dart';
import '../services/firebase_service.dart';
import '../models/sign_language_module.dart';

class LearnScreen extends StatefulWidget {
  const LearnScreen({super.key});

  @override
  State<LearnScreen> createState() => _LearnScreenState();
}

class _LearnScreenState extends State<LearnScreen> {
  final _firebaseService = FirebaseService.instance;
  List<SignLanguageModule> _signs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSigns();
  }

  Future<void> _loadSigns() async {
    setState(() => _isLoading = true);
    final signs = await _firebaseService.getAllSignModules();
    setState(() {
      _signs = signs;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Learn BIM Basics")),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _signs.isEmpty
              ? const Center(child: Text('No sign modules available'))
              : ListView.separated(
                  itemCount: _signs.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, i) {
                    final sign = _signs[i];
                    return ListTile(
                      leading: sign.assetPath.isNotEmpty
                          ? Image.asset(
                              sign.assetPath,
                              width: 56,
                              height: 56,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
                                  const Icon(Icons.sign_language, size: 40),
                            )
                          : const Icon(Icons.sign_language, size: 40),
                      title: Text(sign.word),
                      subtitle: Text(sign.description),
                    );
                  },
                ),
    );
  }
}
