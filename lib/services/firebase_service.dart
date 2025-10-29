import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../models/sign_language_module.dart';
import '../models/learning_module.dart';

class FirebaseService {
  static final FirebaseService instance = FirebaseService._init();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  FirebaseService._init();

  // Collections
  CollectionReference get _usersCollection => _firestore.collection('users');
  CollectionReference get _signModulesCollection =>
      _firestore.collection('sign_language_modules');
  CollectionReference get _learningModulesCollection =>
      _firestore.collection('learning_modules');

  // ==================== USER OPERATIONS ====================

  Future<User?> getUserByEmail(String email) async {
    try {
      final querySnapshot = await _usersCollection
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) return null;

      final doc = querySnapshot.docs.first;
      return User.fromMap({
        'id': doc.id,
        ...doc.data() as Map<String, dynamic>,
      });
    } catch (e) {
      debugPrint('Error getting user by email: $e');
      return null;
    }
  }

  Future<User?> getUserById(String userId) async {
    try {
      final doc = await _usersCollection.doc(userId).get();
      if (!doc.exists) return null;

      return User.fromMap({
        'id': doc.id,
        ...doc.data() as Map<String, dynamic>,
      });
    } catch (e) {
      debugPrint('Error getting user by ID: $e');
      return null;
    }
  }

  Future<List<User>> getAllUsers() async {
    try {
      final querySnapshot = await _usersCollection.get();
      return querySnapshot.docs
          .map((doc) => User.fromMap({
                'id': doc.id,
                ...doc.data() as Map<String, dynamic>,
              }))
          .toList();
    } catch (e) {
      debugPrint('Error getting all users: $e');
      return [];
    }
  }

  Future<String?> createUser(User user) async {
    try {
      final docRef = await _usersCollection.add(user.toMap());
      return docRef.id;
    } catch (e) {
      debugPrint('Error creating user: $e');
      return null;
    }
  }

  Future<bool> updateUser(User user) async {
    try {
      if (user.id == null) return false;
      await _usersCollection.doc(user.id).update(user.toMap());
      return true;
    } catch (e) {
      debugPrint('Error updating user: $e');
      return false;
    }
  }

  Future<bool> deleteUser(String userId) async {
    try {
      await _usersCollection.doc(userId).delete();
      return true;
    } catch (e) {
      debugPrint('Error deleting user: $e');
      return false;
    }
  }

  // ==================== SIGN LANGUAGE MODULE OPERATIONS ====================

  Future<List<SignLanguageModule>> getAllSignModules() async {
    try {
      final querySnapshot =
          await _signModulesCollection.orderBy('word', descending: false).get();
      return querySnapshot.docs
          .map((doc) => SignLanguageModule.fromMap({
                'id': doc.id,
                ...doc.data() as Map<String, dynamic>,
              }))
          .toList();
    } catch (e) {
      debugPrint('Error getting all sign modules: $e');
      return [];
    }
  }

  Future<SignLanguageModule?> getSignModuleById(String moduleId) async {
    try {
      final doc = await _signModulesCollection.doc(moduleId).get();
      if (!doc.exists) return null;

      return SignLanguageModule.fromMap({
        'id': doc.id,
        ...doc.data() as Map<String, dynamic>,
      });
    } catch (e) {
      debugPrint('Error getting sign module by ID: $e');
      return null;
    }
  }

  Future<List<SignLanguageModule>> searchSignModules(String query) async {
    try {
      final querySnapshot = await _signModulesCollection
          .where('word', isGreaterThanOrEqualTo: query.toUpperCase())
          .where('word', isLessThanOrEqualTo: '${query.toUpperCase()}\uf8ff')
          .get();

      return querySnapshot.docs
          .map((doc) => SignLanguageModule.fromMap({
                'id': doc.id,
                ...doc.data() as Map<String, dynamic>,
              }))
          .toList();
    } catch (e) {
      debugPrint('Error searching sign modules: $e');
      return [];
    }
  }

  Future<String?> createSignModule(SignLanguageModule module) async {
    try {
      final docRef = await _signModulesCollection.add(module.toMap());
      return docRef.id;
    } catch (e) {
      debugPrint('Error creating sign module: $e');
      return null;
    }
  }

  Future<bool> updateSignModule(SignLanguageModule module) async {
    try {
      if (module.id == null) return false;
      await _signModulesCollection.doc(module.id).update(module.toMap());
      return true;
    } catch (e) {
      debugPrint('Error updating sign module: $e');
      return false;
    }
  }

  Future<bool> deleteSignModule(String moduleId) async {
    try {
      await _signModulesCollection.doc(moduleId).delete();
      return true;
    } catch (e) {
      debugPrint('Error deleting sign module: $e');
      return false;
    }
  }

  // ==================== LEARNING MODULE OPERATIONS ====================

  Future<List<LearningModule>> getAllLearningModules() async {
    try {
      final querySnapshot = await _learningModulesCollection
          .orderBy('orderIndex', descending: false)
          .get();
      return querySnapshot.docs
          .map((doc) => LearningModule.fromMap({
                'id': doc.id,
                ...doc.data() as Map<String, dynamic>,
              }))
          .toList();
    } catch (e) {
      debugPrint('Error getting all learning modules: $e');
      return [];
    }
  }

  Future<LearningModule?> getLearningModuleById(String moduleId) async {
    try {
      final doc = await _learningModulesCollection.doc(moduleId).get();
      if (!doc.exists) return null;

      return LearningModule.fromMap({
        'id': doc.id,
        ...doc.data() as Map<String, dynamic>,
      });
    } catch (e) {
      debugPrint('Error getting learning module by ID: $e');
      return null;
    }
  }

  Future<String?> createLearningModule(LearningModule module) async {
    try {
      final docRef = await _learningModulesCollection.add(module.toMap());
      return docRef.id;
    } catch (e) {
      debugPrint('Error creating learning module: $e');
      return null;
    }
  }

  Future<bool> updateLearningModule(LearningModule module) async {
    try {
      if (module.id == null) return false;
      await _learningModulesCollection.doc(module.id).update(module.toMap());
      return true;
    } catch (e) {
      debugPrint('Error updating learning module: $e');
      return false;
    }
  }

  Future<bool> deleteLearningModule(String moduleId) async {
    try {
      await _learningModulesCollection.doc(moduleId).delete();
      return true;
    } catch (e) {
      debugPrint('Error deleting learning module: $e');
      return false;
    }
  }

  // ==================== INITIALIZATION ====================

  Future<void> initializeDefaultData() async {
    try {
      // Check if admin exists
      final adminExists = await getUserByEmail('admin@signlink.com');

      if (adminExists == null) {
        // Create default admin account
        await createUser(User(
          email: 'admin@signlink.com',
          password: 'admin123', // In production, this should be hashed
          fullName: 'System Administrator',
          role: 'admin',
          createdAt: DateTime.now(),
        ));
        debugPrint('Default admin account created');
      }

      // Check if sign modules exist
      final existingModules = await getAllSignModules();

      if (existingModules.isEmpty) {
        // Create default sign language modules
        final defaultSigns = [
          SignLanguageModule(
            word: 'HELLO',
            description: 'Open hand, gentle wave.',
            assetPath: 'assets/hello.png',
            createdAt: DateTime.now(),
          ),
          SignLanguageModule(
            word: 'THANK YOU',
            description: 'Fingers from chin outward.',
            assetPath: 'assets/thankyou.png',
            createdAt: DateTime.now(),
          ),
          SignLanguageModule(
            word: 'YES',
            description: 'Fist nodding motion.',
            assetPath: 'assets/yes.png',
            createdAt: DateTime.now(),
          ),
          SignLanguageModule(
            word: 'NO',
            description: 'Index and middle finger snap.',
            assetPath: 'assets/no.png',
            createdAt: DateTime.now(),
          ),
          SignLanguageModule(
            word: 'PLEASE',
            description: 'Flat hand circles on chest.',
            assetPath: 'assets/please.png',
            createdAt: DateTime.now(),
          ),
          SignLanguageModule(
            word: 'SORRY',
            description: 'Fist circles on chest.',
            assetPath: 'assets/sorry.png',
            createdAt: DateTime.now(),
          ),
        ];

        for (var sign in defaultSigns) {
          await createSignModule(sign);
        }
        debugPrint('Default sign modules created');
      }
    } catch (e) {
      debugPrint('Error initializing default data: $e');
    }
  }
}
