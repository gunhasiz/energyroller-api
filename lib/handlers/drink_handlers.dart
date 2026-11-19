import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../models/energy_drink.dart';
import '../repositories/drink_repository.dart';
import '../utils/json_response.dart';

class DrinkHandlers {
  final DrinkRepository _repository;

  const DrinkHandlers(this._repository);

  Router get router {
    return Router()
      ..get('/api/drinks/roll', _rollDrinks)
      ..get('/api/drinks', _listDrinks)
      ..post('/api/drinks', _addDrink);
  }

  Future<Response> _rollDrinks(Request request) async {
    final drinks = _repository.rollRandom(limit: 3);
    return jsonOk(drinks.map((d) => d.toJson()).toList());
  }

  Future<Response> _listDrinks(Request request) async {
    final drinks = _repository.findAll();
    return jsonOk(drinks.map((d) => d.toJson()).toList());
  }

  Future<Response> _addDrink(Request request) async {
    try {
      final payload = await request.readAsString();
      if (payload.trim().isEmpty) {
        return jsonBadRequest('Payload can\'t be empty.');
      }

      final decoded = jsonDecode(payload);
      if (decoded is! Map<String, dynamic>) {
        return jsonBadRequest('Expected JSON.');
      }

      final input = CreateDrinkInput.fromJson(decoded);
      final insertedId = _repository.insert(input);

      return jsonCreated({'id': insertedId, 'status': 'created'});
    } on FormatException {
      return jsonBadRequest('Invalid JSON format.');
    } on ValidationException catch (e) {
      return jsonBadRequest(e.message);
    } catch (e) {
      return jsonServerError('Internal server error: $e');
    }
  }
}