import 'dart:io';

class AppConfig {
  final InternetAddress host;
  final int port;
  final String dbPath;
  final String webDir;
  final String adminUser;
  final String adminPassword;

  const AppConfig({
    required this.host,
    required this.port,
    required this.dbPath,
    required this.webDir,
    required this.adminUser,
    required this.adminPassword,
  });

  factory AppConfig.fromEnvironment({String envFilePath = '.env'}) {
    final fileEnv = _loadDotEnv(envFilePath);
    final sysEnv = Platform.environment;

    String? readVar(String key) => sysEnv[key] ?? fileEnv[key];

    final adminUser = readVar('ADMIN_USER')?.trim() ?? '';
    final adminPassword = readVar('ADMIN_PASSWORD') ?? '';

    if (adminUser.isEmpty || adminPassword.isEmpty) {
      throw StateError(
        'Missing required credentials: ADMIN_USER and ADMIN_PASSWORD must be set in $envFilePath or system environment.',
      );
    }

    return AppConfig(
      host: InternetAddress.anyIPv4,
      port: int.tryParse(readVar('PORT') ?? '') ?? 8080,
      dbPath: readVar('DB_PATH') ?? 'data/drinks.db',
      webDir: readVar('WEB_DIR') ?? '../build/web',
      adminUser: adminUser,
      adminPassword: adminPassword,
    );
  }

  static Map<String, String> _loadDotEnv(String path) {
    final file = File(path);
    if (!file.existsSync()) return const {};

    final result = <String, String>{};
    for (final rawLine in file.readAsLinesSync()) {
      final line = rawLine.trim();
      if (line.isEmpty || line.startsWith('#')) continue;

      final separatorIndex = line.indexOf('=');
      if (separatorIndex <= 0) continue;

      final key = line.substring(0, separatorIndex).trim();
      var value = line.substring(separatorIndex + 1).trim();

      if (value.length >= 2 &&
          ((value.startsWith('"') && value.endsWith('"')) ||
              (value.startsWith("'") && value.endsWith("'")))) {
        value = value.substring(1, value.length - 1);
      }

      result[key] = value;
    }

    return result;
  }
}