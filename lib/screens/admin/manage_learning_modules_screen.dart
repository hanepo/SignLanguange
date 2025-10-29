import 'package:flutter/material.dart';
import '../../services/database_helper.dart';
import '../../models/learning_module.dart';
import 'learning_module_form_screen.dart';

class ManageLearningModulesScreen extends StatefulWidget {
  const ManageLearningModulesScreen({super.key});

  @override
  State<ManageLearningModulesScreen> createState() =>
      _ManageLearningModulesScreenState();
}

class _ManageLearningModulesScreenState
    extends State<ManageLearningModulesScreen> {
  final _db = DatabaseHelper.instance;
  List<LearningModule> _modules = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadModules();
  }

  Future<void> _loadModules() async {
    setState(() => _isLoading = true);
    final modules = await _db.getAllLearningModules();
    setState(() {
      _modules = modules;
      _isLoading = false;
    });
  }

  Future<void> _deleteModule(LearningModule module) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Module'),
        content: Text('Are you sure you want to delete "${module.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true && module.id != null) {
      await _db.deleteLearningModule(module.id!);
      _loadModules();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Module deleted')),
        );
      }
    }
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'beginner':
        return Colors.green;
      case 'intermediate':
        return Colors.orange;
      case 'advanced':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Learning Modules'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const LearningModuleFormScreen()),
          );
          _loadModules();
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Module'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _modules.isEmpty
              ? const Center(child: Text('No learning modules found'))
              : ListView.separated(
                  itemCount: _modules.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final module = _modules[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: _getDifficultyColor(module.difficulty),
                        child: Text(
                          module.orderIndex.toString(),
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                      title: Text(
                        module.title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            module.content.length > 50
                                ? '${module.content.substring(0, 50)}...'
                                : module.content,
                          ),
                          const SizedBox(height: 4),
                          Chip(
                            label: Text(
                              module.difficulty.toUpperCase(),
                              style: const TextStyle(fontSize: 10),
                            ),
                            backgroundColor:
                                _getDifficultyColor(module.difficulty)
                                    .withValues(alpha: 0.2),
                            padding: EdgeInsets.zero,
                            visualDensity: VisualDensity.compact,
                          ),
                        ],
                      ),
                      isThreeLine: true,
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      LearningModuleFormScreen(module: module),
                                ),
                              );
                              _loadModules();
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => _deleteModule(module),
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}
