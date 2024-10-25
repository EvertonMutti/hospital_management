import 'package:hospital_management/app/modules/global/core/model/signup_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SignupService {
  static final SignupService _instance = SignupService._internal();
  factory SignupService() => _instance;

  SignupService._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'app_database.db');
    
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          '''
          CREATE TABLE IF NOT EXISTS signup(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            password TEXT,
            email TEXT,
            phone TEXT,
            tax_number TEXT,
            hospital_unique_code TEXT,
            position TEXT
          )
          ''',
        );
      },
    );
  }

  Future<int> insertSignup(SignupModel signup) async {
    final db = await database;
    return await db.insert(
      'signup',
      signup.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<SignupModel>> getAllSignups() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('signup');

    return List.generate(maps.length, (i) {
      return SignupModel.fromJson(maps[i]);
    });
  }
}
