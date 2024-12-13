import 'package:logger/logger.dart';

abstract class ILogger {
  void log(Level level, dynamic message);
  void debug(dynamic message);
  void info(dynamic message);
  void warning(dynamic message);
  void error(dynamic message);
}

class AppLogger implements ILogger {
  final Logger _logger;

  AppLogger({required Logger logger}) : _logger = logger;

  @override
  void log(Level level, dynamic message) {
    _logger.log(level, message);
  }

  @override
  void debug(dynamic message) => log(Level.debug, message);

  @override
  void info(dynamic message) => log(Level.info, message);

  @override
  void warning(dynamic message) => log(Level.warning, message);

  @override
  void error(dynamic message) => log(Level.error, message);
}
