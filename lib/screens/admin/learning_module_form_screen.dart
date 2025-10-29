import 'package:flutter/material.dart';
import '../../services/firebase_service.dart';
import '../../models/learning_module.dart';

class LearningModuleFormScreen extends StatefulWidget {
  final LearningModule? module;

  const LearningModuleFormScreen({super.key, this.module});

  @override
  State<LearningModuleFormScreen> createState() =>
      _LearningModuleFormScreenState();
}

class _LearningModuleFormScreenState extends State<LearningModuleFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _orderIndexController = TextEditingController();
  String _selectedDifficulty = 'beginner';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.module != null) {
      _titleController.text = widget.module!.title;
      _contentController.text = widget.module!.content;
      _orderIndexController.text = widget.module!.orderIndex.toString();
      _selectedDifficulty = widget.module!.difficulty;
    } else {
      _orderIndexController.text = '0';
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _orderIndexController.dispose();
    super.dispose();
  }

  Future<void> _saveModule() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final firebaseService = FirebaseService.instance;

    if (widget.module == null) {
      // Create new module
      final newModule = LearningModule(
        title: _titleController.text.trim(),
        content: _contentController.text.trim(),
        difficulty: _selectedDifficulty,
        orderIndex: int.tryParse(_orderIndexController.text) ?? 0,
        createdAt: DateTime.now(),
      );
      await firebaseService.createLearningModule(newModule);
    } else {
      // Update existing module
      final updatedModule = widget.module!.copyWith(
        title: _titleController.text.trim(),
        content: _contentController.text.trim(),
        difficulty: _selectedDifficulty,
        orderIndex: int.tryParse(_orderIndexController.text) ?? 0,
        updatedAt: DateTime.now(),
      );
      await firebaseService.updateLearningModule(updatedModule);
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
        title: Text(isEdit ? 'Edit Learning Module' : 'Add Learning Module'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
                hintText: 'e.g., Introduction to BIM',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _contentController,
              decoration: const InputDecoration(
                labelText: 'Content',
                border: OutlineInputBorder(),
                hintText: 'Detailed lesson content',
              ),
              maxLines: 8,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter content';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _selectedDifficulty,
              decoration: const InputDecoration(
                labelText: 'Difficulty',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'beginner', child: Text('Beginner')),
                DropdownMenuItem(
                    value: 'intermediate', child: Text('Intermediate')),
                DropdownMenuItem(value: 'advanced', child: Text('Advanced')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedDifficulty = value);
                }
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _orderIndexController,
              decoration: const InputDecoration(
                labelText: 'Order Index',
                border: OutlineInputBorder(),
                hintText: '0',
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an order index';
                }
                if (int.tryParse(value) == null) {
                  return 'Please enter a valid number';
                }
                return null;
              },
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
