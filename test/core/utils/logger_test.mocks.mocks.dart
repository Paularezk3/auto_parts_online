// Mocks generated by Mockito 5.4.4 from annotations
// in auto_parts_online/test/logger_test.mocks.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_parts_online/core/utils/app_logger.dart' as _i2;
import 'package:logger/logger.dart' as _i3;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

/// A class which mocks [AppLogger].
///
/// See the documentation for Mockito's code generation for more information.
class MockAppLogger extends _i1.Mock implements _i2.AppLogger {
  MockAppLogger() {
    _i1.throwOnMissingStub(this);
  }

  @override
  void log(
    _i3.Level? level,
    dynamic message,
  ) =>
      super.noSuchMethod(
        Invocation.method(
          #log,
          [
            level,
            message,
          ],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void debug(dynamic message) => super.noSuchMethod(
        Invocation.method(
          #debug,
          [message],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void info(dynamic message) => super.noSuchMethod(
        Invocation.method(
          #info,
          [message],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void warning(dynamic message) => super.noSuchMethod(
        Invocation.method(
          #warning,
          [message],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void error(dynamic message) => super.noSuchMethod(
        Invocation.method(
          #error,
          [message],
        ),
        returnValueForMissingStub: null,
      );
}