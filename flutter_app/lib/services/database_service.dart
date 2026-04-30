import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';
import '../models/calculation.dart';

class DatabaseService {
  DatabaseService._();
  static final DatabaseService instance = DatabaseService._();

  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _open();
    return _db!;
  }

  Future<Database> _open() async {
    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, 'calculator.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE calculations (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            expression TEXT NOT NULL,
            result TEXT NOT NULL,
            created_at TEXT NOT NULL
          )
        ''');
      },
    );
  }

  Future<int> insert(Calculation calc) async {
    final db = await database;
    return db.insert('calculations', {
      'expression': calc.expression,
      'result': calc.result,
      'created_at': calc.createdAt.toIso8601String(),
    });
  }

  Future<List<Calculation>> getAll({int limit = 100}) async {
    final db = await database;
    final rows = await db.query(
      'calculations',
      orderBy: 'created_at DESC',
      limit: limit,
    );
    return rows.map(Calculation.fromMap).toList();
  }

  Future<void> delete(int id) async {
    final db = await database;
    await db.delete('calculations', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> clearAll() async {
    final db = await database;
    await db.delete('calculations');
  }
}
