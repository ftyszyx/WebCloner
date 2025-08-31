import 'dart:developer' as developer;

class Logger {
  static final Logger _instance = Logger._internal();
  factory Logger() => _instance;
  Logger._internal();

  void info(String message, {Object? error, StackTrace? stackTrace}) {
    developer.log(
      message,
      name: 'WebCloner',
      level: 800,
      error: error,
      stackTrace: stackTrace,
    );
  }

  void warning(String message, {Object? error, StackTrace? stackTrace}) {
    developer.log(
      message,
      name: 'WebCloner',
      level: 900,
      error: error,
      stackTrace: stackTrace,
    );
  }

  void error(String message, {Object? error, StackTrace? stackTrace}) {
    developer.log(
      message,
      name: 'WebCloner',
      level: 1000,
      error: error,
      stackTrace: stackTrace,
    );
  }

  void debug(String message, {Object? error, StackTrace? stackTrace}) {
    developer.log(
      message,
      name: 'WebCloner',
      level: 500,
      error: error,
      stackTrace: stackTrace,
    );
  }

  Future<void> initialize() async {
    info('Logger initialized');
  }
}

final logger = Logger();
