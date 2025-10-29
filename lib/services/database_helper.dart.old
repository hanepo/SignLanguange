import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/user.dart';
import '../models/sign_language_module.dart';
import '../models/learning_module.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('signlink.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const intType = 'INTEGER NOT NULL';

    // Users table
    await db.execute('''
      CREATE TABLE users (
        id $idType,
        email $textType UNIQUE,
        password $textType,
        fullName $textType,
        role $textType,
        createdAt $textType,
        updatedAt TEXT
      )
    ''');

    // Sign Language Modules table
    await db.execute('''
      CREATE TABLE sign_language_modules (
        id $idType,
        word $textType,
        description $textType,
        assetPath $textType,
        videoPath TEXT,
        createdAt $textType,
        updatedAt TEXT
      )
    ''');

    // Learning Modules table
    await db.execute('''
      CREATE TABLE learning_modules (
        id $idType,
        title $textType,
        content $textType,
        difficulty $textType,
        orderIndex $intType,
        signLanguageModuleIds TEXT,
        createdAt $textType,
        updatedAt TEXT
      )
    ''');

    // Create default admin account
    await db.insert('users', {
      'email': 'admin@signlink.com',
      'password': 'admin123', // In production, hash this!
      'fullName': 'System Administrator',
      'role': 'admin',
      'createdAt': DateTime.now().toIso8601String(),
    });

    // Insert default sign language modules
    final defaultSigns = [
      {
        'word': 'HELLO',
        'description': 'Open hand, gentle wave.',
        'assetPath': 'assets/hello.png'
      },
      {
        'word': 'THANK YOU',
        'description': 'Fingers from chin outward.',
        'assetPath': 'assets/thankyou.png'
      },
      {
        'word': 'YES',
        'description': 'Fist nodding motion.',
        'assetPath': 'assets/yes.png'
      },
      {
        'word': 'NO',
        'description': 'Index & middle extended.',
        'assetPath': 'assets/no.png'
      },
      {
        'word': 'I LOVE YOU',
        'description': 'Thumb, index, pinky extended.',
        'assetPath': 'assets/ily.png'
      },
      {
        'word': 'EAT',
        'description': 'Fingertips move to mouth.',
        'assetPath': 'assets/eat.png'
      },
    ];

    for (var sign in defaultSigns) {
      await db.insert('sign_language_modules', {
        ...sign,
        'createdAt': DateTime.now().toIso8601String(),
      });
    }
  }

  // ==================== USER CRUD ====================

  Future<User> createUser(User user) async {
    final db = await database;
    final id = await db.insert('users', user.toMap());
    return user.copyWith(id: id);
  }

  Future<User?> getUserById(int id) async {
    final db = await database;
    final maps = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  Future<User?> getUserByEmail(String email) async {
    final db = await database;
    final maps = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );

    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  Future<List<User>> getAllUsers() async {
    final db = await database;
    final result = await db.query('users', orderBy: 'createdAt DESC');
    return result.map((map) => User.fromMap(map)).toList();
  }

  Future<int> updateUser(User user) async {
    final db = await database;
    return db.update(
      'users',
      user.copyWith(updatedAt: DateTime.now()).toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  Future<int> deleteUser(int id) async {
    final db = await database;
    return db.delete(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // ==================== SIGN LANGUAGE MODULE CRUD ====================

  Future<SignLanguageModule> createSignModule(SignLanguageModule module) async {
    final db = await database;
    final id = await db.insert('sign_language_modules', module.toMap());
    return module.copyWith(id: id);
  }

  Future<SignLanguageModule?> getSignModuleById(int id) async {
    final db = await database;
    final maps = await db.query(
      'sign_language_modules',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return SignLanguageModule.fromMap(maps.first);
    }
    return null;
  }

  Future<List<SignLanguageModule>> getAllSignModules() async {
    final db = await database;
    final result = await db.query('sign_language_modules', orderBy: 'word ASC');
    return result.map((map) => SignLanguageModule.fromMap(map)).toList();
  }

  Future<int> updateSignModule(SignLanguageModule module) async {
    final db = await database;
    return db.update(
      'sign_language_modules',
      module.copyWith(updatedAt: DateTime.now()).toMap(),
      where: 'id = ?',
      whereArgs: [module.id],
    );
  }

  Future<int> deleteSignModule(int id) async {
    final db = await database;
    return db.delete(
      'sign_language_modules',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // ==================== LEARNING MODULE CRUD ====================

  Future<LearningModule> createLearningModule(LearningModule module) async {
    final db = await database;
    final id = await db.insert('learning_modules', module.toMap());
    return module.copyWith(id: id);
  }

  Future<LearningModule?> getLearningModuleById(int id) async {
    final db = await database;
    final maps = await db.query(
      'learning_modules',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return LearningModule.fromMap(maps.first);
    }
    return null;
  }

  Future<List<LearningModule>> getAllLearningModules() async {
    final db = await database;
    final result =
        await db.query('learning_modules', orderBy: 'orderIndex ASC');
    return result.map((map) => LearningModule.fromMap(map)).toList();
  }

  Future<int> updateLearningModule(LearningModule module) async {
    final db = await database;
    return db.update(
      'learning_modules',
      module.copyWith(updatedAt: DateTime.now()).toMap(),
      where: 'id = ?',
      whereArgs: [module.id],
    );
  }

  Future<int> deleteLearningModule(int id) async {
    final db = await database;
    return db.delete(
      'learning_modules',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // ==================== AUTHENTICATION ====================

  Future<User?> login(String email, String password) async {
    final user = await getUserByEmail(email);
    if (user != null && user.password == password) {
      return user;
    }
    return null;
  }

  Future<void> close() async {
    final db = await database;
    db.close();
  }
}
