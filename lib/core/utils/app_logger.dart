import 'package:logger/logger.dart';

class AppLogger {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      // Customize the logger's output
      methodCount: 2,
      errorMethodCount: 5,
      lineLength: 120,
      colors: true,
      printEmojis: true,
      dateTimeFormat: DateTimeFormat.dateAndTime,
    ),
  );

  static void log(dynamic message, {Level level = Level.info}) {
    _logger.log(level, message);
  }

  static void debug(dynamic message) => log(message, level: Level.debug);
  static void info(dynamic message) => log(message, level: Level.info);
  static void warning(dynamic message) => log(message, level: Level.warning);
  static void error(dynamic message) => log(message, level: Level.error);
}
