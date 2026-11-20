import 'package:sqlite3/sqlite3.dart';

class ValidationException implements Exception {
  final String message;
  const ValidationException(this.message);

  @override
  String toString() => message;
}

class EnergyDrink {
  final int id;
  final String name;
  final String brand;
  final String? flavor;
  final int caffeineMg;
  final int volume;
  final String createdAt;

  const EnergyDrink({
    required this.id,
    required this.name,
    required this.brand,
    this.flavor,
    required this.caffeineMg,
    required this.volume,
    required this.createdAt,
  });

  factory EnergyDrink.fromRow(Row row) {
    return EnergyDrink(
      id: row['id'] as int,
      name: row['name'] as String,
      brand: row['brand'] as String,
      flavor: row['flavor'] as String?,
      caffeineMg: (row['caffeine_mg'] as num?)?.toInt() ?? 80,
      volume: (row['volume_ml'] as num?)?.toInt() ?? 250,
      createdAt: row['created_at'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'brand': brand,
      'flavor': flavor,
      'caffeine_mg': caffeineMg,
      'volume': volume,
      'created_at': createdAt,
    };
  }
}

class CreateDrinkInput {
  final String name;
  final String brand;
  final String? flavor;
  final int caffeineMg;
  final int volume;

  const CreateDrinkInput({
    required this.name,
    required this.brand,
    this.flavor,
    required this.caffeineMg,
    required this.volume,
  });

  factory CreateDrinkInput.fromJson(Map<String, dynamic> json) {
    final name = (json['name'] as String?)?.trim() ?? '';
    final brand = (json['brand'] as String?)?.trim() ?? '';
    final rawFlavor = (json['flavor'] as String?)?.trim();
    final caffeine = int.tryParse(json['caffeine_mg']?.toString() ?? '') ?? 80;
    final volume = int.tryParse(json['volume']?.toString() ?? '') ?? 250;

    if (name.isEmpty || brand.isEmpty) {
      throw const ValidationException('Fields "name" and "brand" are required.');
    }

    if (caffeine < 0 || volume <= 0) {
      throw const ValidationException(
        'Caffeine cannot be negative and volume must be greater than zero.',
      );
    }

    return CreateDrinkInput(
      name: name,
      brand: brand,
      flavor: (rawFlavor != null && rawFlavor.isNotEmpty) ? rawFlavor : null,
      caffeineMg: caffeine,
      volume: volume,
    );
  }
}