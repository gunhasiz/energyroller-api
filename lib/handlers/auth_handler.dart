import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../services/auth_service.dart';
import '../utils/json_response.dart';

class AuthHandler {
  final AuthService _authService;

  const AuthHandler(this._authService);

  Router get router {
    return Router()
      ..post('/api/auth/login', _login)
      ..post('/api/auth/logout', _logout);
  }

  Future<Response> _login(Request request) async {
    try {
      final payload = await request.readAsString();
      if (payload.trim().isEmpty) {
        return jsonBadRequest('Username and password are required.');
      }

      final decoded = jsonDecode(payload);
      if (decoded is! Map<String, dynamic>) {
        return jsonBadRequest('Expected a JSON object.');
      }

      final username = (decoded['username'] as String?)?.trim() ?? '';
      final password = (decoded['password'] as String?) ?? '';

      final token = _authService.login(username, password);
      if (token == null) {
        return jsonUnauthorized('Invalid username or password.');
      }

      return jsonOk({'token': token});
    } on FormatException {
      return jsonBadRequest('Invalid JSON format.');
    }
  }

  Future<Response> _logout(Request request) async {
    _authService.logout(request.headers['authorization']);
    return jsonOk({'status': 'logged_out'});
  }
}