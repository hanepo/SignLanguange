import 'package:flutter/material.dart';
import '../../services/firebase_service.dart';
import '../../models/sign_language_module.dart';
import 'sign_module_form_screen.dart';

class ManageSignModulesScreen extends StatefulWidget {
  const ManageSignModulesScreen({super.key});

  @override
  State<ManageSignModulesScreen> createState() =>
      _ManageSignModulesScreenState();
}

class _ManageSignModulesScreenState extends State<ManageSignModulesScreen> {
  final _firebaseService = FirebaseService.instance;
  List<SignLanguageModule> _modules = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadModules();
  }

  Future<void> _loadModules() async {
    setState(() => _isLoading = true);
    final modules = await _firebaseService.getAllSignModules();
    setState(() {
      _modules = modules;
      _isLoading = false;
    });
  }

  Future<void> _deleteModule(SignLanguageModule module) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Module'),
        content: Text('Are you sure you want to delete "${module.word}"?'),
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
      await _firebaseService.deleteSignModule(module.id!);
      _loadModules();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Module deleted')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Language Modules'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const SignModuleFormScreen()),
          );
          _loadModules();
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Module'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _modules.isEmpty
              ? const Center(child: Text('No sign modules found'))
              : ListView.separated(
                  itemCount: _modules.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final module = _modules[index];
                    return ListTile(
                      leading: module.assetPath.isNotEmpty
                          ? Image.asset(
                              module.assetPath,
                              width: 56,
                              height: 56,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
                                  const Icon(Icons.sign_language, size: 40),
                            )
                          : const Icon(Icons.sign_language, size: 40),
                      title: Text(
                        module.word,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(module.description),
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
                                      SignModuleFormScreen(module: module),
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
