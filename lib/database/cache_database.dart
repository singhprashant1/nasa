import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class CacheDatabase {
  static final CacheDatabase instance = CacheDatabase._init();
  static Database? _database;

  CacheDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('cache.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE cache (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        endpoint TEXT NOT NULL,
        response TEXT NOT NULL,
        timestamp INTEGER NOT NULL
      )
    ''');
  }

  Future<void> saveCache(String endpoint, String response) async {
    final db = await instance.database;
    await db.insert(
      'cache',
      {
        'endpoint': endpoint,
        'response': response,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<String?> getCache(String endpoint) async {
    final db = await instance.database;
    final result = await db.query(
      'cache',
      where: 'endpoint = ?',
      whereArgs: [endpoint],
      orderBy: 'timestamp DESC',
      limit: 1,
    );

    if (result.isNotEmpty) {
      return result.first['response'] as String;
    }
    return null;
  }

  Future<void> clearCache() async {
    final db = await instance.database;
    await db.delete('cache');
  }

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}
