import 'dart:convert';
import 'package:shelf/shelf.dart';

Response jsonOk(Object data) => _json(200, data);

Response jsonCreated(Object data) => _json(201, data);

Response jsonBadRequest(String message) => _json(400, {'error': message});

Response jsonServerError(String message) => _json(500, {'error': message});

Response _json(int statusCode, Object data) {
  return Response(
    statusCode,
    body: jsonEncode(data),
    headers: const {'Content-Type': 'application/json; charset=utf-8'},
  );
}