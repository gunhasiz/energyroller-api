import 'dart:io';

class AppConfig {
  final InternetAddress host;
  final int port;
  final String dbPath;
  final String webDir;

  const AppConfig({
    required this.host,
    required this.port,
    required this.dbPath,
    required this.webDir,
  });

  factory AppConfig.fromEnvironment() {
    final env = Platform.environment;
    return AppConfig(
      host: InternetAddress.anyIPv4,
      port: int.tryParse(env['PORT'] ?? '') ?? 8080,
      dbPath: env['DB_PATH'] ?? 'db/drinks.db',
      webDir: env['WEB_DIR'] ?? '../build/web',
    );
  }
}