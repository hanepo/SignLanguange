import 'package:flutter/material.dart';
import '../../services/database_helper.dart';
import '../../models/sign_language_module.dart';

class SignModuleFormScreen extends StatefulWidget {
  final SignLanguageModule? module;

  const SignModuleFormScreen({super.key, this.module});

  @override
  State<SignModuleFormScreen> createState() => _SignModuleFormScreenState();
}

class _SignModuleFormScreenState extends State<SignModuleFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _wordController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _assetPathController = TextEditingController();
  final _videoPathController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.module != null) {
      _wordController.text = widget.module!.word;
      _descriptionController.text = widget.module!.description;
      _assetPathController.text = widget.module!.assetPath;
      _videoPathController.text = widget.module!.videoPath ?? '';
    }
  }

  @override
  void dispose() {
    _wordController.dispose();
    _descriptionController.dispose();
    _assetPathController.dispose();
    _videoPathController.dispose();
    super.dispose();
  }

  Future<void> _saveModule() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final db = DatabaseHelper.instance;

    if (widget.module == null) {
      // Create new module
      final newModule = SignLanguageModule(
        word: _wordController.text.trim(),
        description: _descriptionController.text.trim(),
        assetPath: _assetPathController.text.trim(),
        videoPath: _videoPathController.text.trim().isEmpty
            ? null
            : _videoPathController.text.trim(),
      );
      await db.createSignModule(newModule);
    } else {
      // Update existing module
      final updatedModule = widget.module!.copyWith(
        word: _wordController.text.trim(),
        description: _descriptionController.text.trim(),
        assetPath: _assetPathController.text.trim(),
        videoPath: _videoPathController.text.trim().isEmpty
            ? null
            : _videoPathController.text.trim(),
      );
      await db.updateSignModule(updatedModule);
    }

    setState(() => _isLoading = false);

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.module != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Sign Module' : 'Add Sign Module'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _wordController,
              decoration: const InputDecoration(
                labelText: 'Word/Phrase',
                border: OutlineInputBorder(),
                hintText: 'e.g., HELLO',
              ),
              textCapitalization: TextCapitalization.characters,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a word or phrase';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
                hintText: 'Describe the gesture',
              ),
              maxLines: 3,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a description';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _assetPathController,
              decoration: const InputDecoration(
                labelText: 'Image Asset Path',
                border: OutlineInputBorder(),
                hintText: 'assets/hello.png',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an asset path';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _videoPathController,
              decoration: const InputDecoration(
                labelText: 'Video Path (Optional)',
                border: OutlineInputBorder(),
                hintText: 'assets/hello.mp4',
              ),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _isLoading ? null : _saveModule,
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(isEdit ? 'Update Module' : 'Create Module'),
            ),
          ],
        ),
      ),
    );
  }
}
