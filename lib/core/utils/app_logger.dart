import 'package:logger/logger.dart';

abstract class ILogger {
  void debug(dynamic message, StackTrace? stackTrace);
  void info(dynamic message, StackTrace? stackTrace);
  void warning(dynamic message, StackTrace? stackTrace);
  void error(dynamic message, StackTrace? stackTrace);
  void trace(dynamic message, StackTrace? stackTrace);
}

class AppLogger implements ILogger {
  final Logger _logger;

  AppLogger({required Logger logger}) : _logger = logger;

  void log(Level level, dynamic message, StackTrace? stackTrace) {
    _logger.log(level, message, stackTrace: stackTrace);
  }

  @override
  void debug(dynamic message, StackTrace? stackTrace) =>
      log(Level.debug, message, stackTrace);

  @override
  void info(dynamic message, StackTrace? stackTrace) =>
      log(Level.info, message, stackTrace);

  @override
  void warning(dynamic message, StackTrace? stackTrace) =>
      log(Level.warning, message, stackTrace);

  @override
  void error(dynamic message, StackTrace? stackTrace) =>
      log(Level.error, message, stackTrace);

  @override
  void trace(dynamic message, StackTrace? stackTrace) =>
      log(Level.trace, message, stackTrace);
}
