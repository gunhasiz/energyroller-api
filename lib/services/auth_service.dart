import 'dart:convert';
import 'dart:math';

class AuthService {
  final String _adminUser;
  final String _adminPassword;
  final Set<String> _activeTokens = {};
  final Random _random = Random.secure();

  AuthService({
    required this._adminUser,
    required this._adminPassword,
  });

  String? login(String username, String password) {
    if (username != _adminUser || password != _adminPassword) {
      return null;
    }

    final bytes = List<int>.generate(32, (_) => _random.nextInt(256));
    final token = base64UrlEncode(bytes);
    _activeTokens.add(token);
    return token;
  }

  void logout(String? authHeader) {
    final token = _extractBearerToken(authHeader);
    if (token != null) {
      _activeTokens.remove(token);
    }
  }

  bool isAuthorized(String? authHeader) {
    final token = _extractBearerToken(authHeader);
    return token != null && _activeTokens.contains(token);
  }

  String? _extractBearerToken(String? authHeader) {
    if (authHeader == null || !authHeader.startsWith('Bearer ')) {
      return null;
    }
    final token = authHeader.substring(7).trim();
    return token.isEmpty ? null : token;
  }
}