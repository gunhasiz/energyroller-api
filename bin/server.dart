import 'dart:io';

import 'package:energyroller_api/config/app_config.dart';
import 'package:energyroller_api/database/database_service.dart';
import 'package:energyroller_api/handlers/drink_handlers.dart';
import 'package:energyroller_api/repositories/drink_repository.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_cors_headers/shelf_cors_headers.dart';
import 'package:shelf_static/shelf_static.dart';

Future<void> main() async {
  final config = AppConfig.fromEnvironment();
  final dbService = DatabaseService.open(config.dbPath);
  final drinkRepository = DrinkRepository(dbService.db);
  final drinkHandlers = DrinkHandlers(drinkRepository);

  var cascade = Cascade().add(drinkHandlers.router.call);

  if (Directory(config.webDir).existsSync()) {
    final staticHandler = createStaticHandler(
      config.webDir,
      defaultDocument: 'index.html',
    );
    cascade = cascade.add(staticHandler);
  }

  final handler = const Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(corsHeaders())
      .addHandler(cascade.handler);

  final server = await serve(handler, config.host, config.port);
  stdout.writeln(
    'EnergyRoller API działa na http://${server.address.host}:${server.port}',
  );

  Future<void> shutdown(ProcessSignal signal) async {
    stdout.writeln('\nOtrzymano sygnał ${signal.name}, zamykanie serwera...');
    await server.close();
    dbService.close();
    exit(0);
  }

  ProcessSignal.sigint.watch().listen(shutdown);
  if (!Platform.isWindows) {
    ProcessSignal.sigterm.watch().listen(shutdown);
  }
}