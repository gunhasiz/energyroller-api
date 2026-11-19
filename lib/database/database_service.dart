import 'dart:io';
import 'package:sqlite3/sqlite3.dart';

class DatabaseService {
  final Database db;

  DatabaseService._(this.db);

  factory DatabaseService.open(String dbPath) {
    final file = File(dbPath);
    file.parent.createSync(recursive: true);

    final database = sqlite3.open(dbPath);
    database.execute('PRAGMA journal_mode = WAL;');
    database.execute('PRAGMA busy_timeout = 5000;');

    database.execute('''
      CREATE TABLE IF NOT EXISTS energy_drinks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        brand TEXT NOT NULL,
        flavor TEXT,
        caffeine_mg INTEGER DEFAULT 80,
        volume_ml INTEGER DEFAULT 250,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP
      );
    ''');

    return DatabaseService._(database);
  }

  void close() {
    db.close();
  }
}