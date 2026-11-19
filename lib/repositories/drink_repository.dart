import 'package:sqlite3/sqlite3.dart';
import '../models/energy_drink.dart';

class DrinkRepository {
  final Database _db;

  const DrinkRepository(this._db);

  List<EnergyDrink> rollRandom({int limit = 3}) {
    final result = _db.select(
      'SELECT * FROM energy_drinks ORDER BY RANDOM() LIMIT ?;',
      [limit],
    );
    return result.map(EnergyDrink.fromRow).toList();
  }

  List<EnergyDrink> findAll() {
    final result = _db.select(
      'SELECT * FROM energy_drinks ORDER BY id DESC;',
    );
    return result.map(EnergyDrink.fromRow).toList();
  }

  int insert(CreateDrinkInput input) {
    final stmt = _db.prepare('''
      INSERT INTO energy_drinks (name, brand, flavor, caffeine_mg, volume_ml)
      VALUES (?, ?, ?, ?, ?);
    ''');

    try {
      stmt.execute([
        input.name,
        input.brand,
        input.flavor,
        input.caffeineMg,
        input.volume,
      ]);
      return _db.lastInsertRowId;
    } finally {
      stmt.close();
    }
  }
}