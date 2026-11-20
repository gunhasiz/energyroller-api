import 'dart:convert';
import 'package:shelf/shelf.dart';

// 200-299
Response jsonOk(Object data) => _json(200, data);
Response jsonCreated(Object data) => _json(201, data);

// 300-399

// 400-499
Response jsonBadRequest(String message) => _json(400, {'error': message});
Response jsonUnauthorized(String message) => _json(401, {'error': message});

// 500-599
Response jsonServerError(String message) => _json(500, {'error': message});

Response _json(int statusCode, Object data) {
  return Response(
    statusCode,
    body: jsonEncode(data),
    headers: const {'Content-Type': 'application/json; charset=utf-8'},
  );
}