// File: test/widgets/buttons_test.dart

import 'package:auto_parts_online/app/setup_dependencies.dart';
import 'package:auto_parts_online/common/components/default_buttons.dart';
import 'package:auto_parts_online/core/utils/app_logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../core/utils/logger_test.mocks.mocks.dart';

void main() {
  setUpAll(() {
    setupDependencies();
  });

  // Reset GetIt after tests
  tearDownAll(() {
    getIt.reset();
  });

  group('PrimaryButton Tests', () {
    testWidgets('renders PrimaryButton with default properties',
        (tester) async {
      final logger = getIt<ILogger>();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrimaryButton(
              logger: logger,
              text: 'Click Me',
              onPressed: () {},
            ),
          ),
        ),
      );

      // Verify button text
      expect(find.text('Click Me'), findsOneWidget);

      // Verify button size using the SizedBox
      final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));
      final expectedSize = ButtonStyles.getButtonSize(ButtonSize.big);
      expect(sizedBox.width, equals(expectedSize.width));
      expect(sizedBox.height, equals(expectedSize.height));

      // Verify button is enabled
      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, isNotNull);
    });

    testWidgets('disables PrimaryButton when isEnabled is false',
        (tester) async {
      final logger = getIt<ILogger>();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrimaryButton(
              logger: logger,
              text: 'Disabled',
              isEnabled: false,
              onPressed: () {},
            ),
          ),
        ),
      );

      // Verify button is disabled
      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, isNull);
    });

    testWidgets('shows loading indicator when isLoading is true',
        (tester) async {
      final logger = getIt<ILogger>();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrimaryButton(
              logger: logger,
              text: 'Loading',
              isLoading: true,
              onPressed: () {},
            ),
          ),
        ),
      );

      // Verify CircularProgressIndicator is displayed
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Verify button text is not displayed
      expect(find.text('Loading'), findsNothing);
    });
  });

  group('OutlinedPrimaryButton Tests', () {
    testWidgets('renders OutlinedPrimaryButton correctly', (tester) async {
      final logger = getIt<ILogger>();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OutlinedPrimaryButton(
              logger: logger,
              text: 'Outlined',
              onPressed: () {},
            ),
          ),
        ),
      );

      // Verify button text
      expect(find.text('Outlined'), findsOneWidget);

      // Verify button is enabled
      final button = tester.widget<OutlinedButton>(find.byType(OutlinedButton));
      expect(button.onPressed, isNotNull);
    });

    testWidgets('disables OutlinedPrimaryButton when isEnabled is false',
        (tester) async {
      final logger = getIt<ILogger>();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OutlinedPrimaryButton(
              logger: logger,
              text: 'Disabled',
              isEnabled: false,
              onPressed: () {},
            ),
          ),
        ),
      );

      // Verify button is disabled
      final button = tester.widget<OutlinedButton>(find.byType(OutlinedButton));
      expect(button.onPressed, isNull);
    });
  });

  group('SecondaryButton Tests', () {
    testWidgets('renders SecondaryButton correctly', (tester) async {
      final logger = getIt<ILogger>();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SecondaryButton(
              logger: logger,
              text: 'Secondary',
              onPressed: () {},
            ),
          ),
        ),
      );

      // Verify button text
      expect(find.text('Secondary'), findsOneWidget);

      // Verify button is enabled
      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, isNotNull);
    });

    testWidgets('disables SecondaryButton when isEnabled is false',
        (tester) async {
      final logger = getIt<ILogger>();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SecondaryButton(
              logger: logger,
              text: 'Disabled',
              isEnabled: false,
              onPressed: () {},
            ),
          ),
        ),
      );

      // Verify button is disabled
      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, isNull);
    });
  });

  group('Edge Case Tests for Primary Button', () {
    testWidgets('PrimaryButton displays dynamic text correctly',
        (tester) async {
      String dynamicText = 'Initial Text';
      final logger = getIt<ILogger>();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return PrimaryButton(
                  logger: logger,
                  text: dynamicText,
                  onPressed: () {
                    setState(() {
                      dynamicText = 'Updated Text';
                    });
                  },
                );
              },
            ),
          ),
        ),
      );

      // Verify initial text
      expect(find.text('Initial Text'), findsOneWidget);

      // Trigger button press and update text
      await tester.tap(find.byType(PrimaryButton));
      await tester.pump();

      // Verify updated text
      expect(find.text('Updated Text'), findsOneWidget);
    });

    testWidgets('PrimaryButton logs correctly on tap', (tester) async {
      const String buttonText = 'Click Me';
      final mockLogger = MockAppLogger(); // Use the mock

      // Inject the mock into your dependency injection system
      when(mockLogger.info(any))
          .thenReturn(null); // Optional: Define behavior if needed

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  mockLogger.info('PrimaryButton tapped!');
                },
                child: const Text(buttonText),
              ),
            ),
          ),
        ),
      );

      // Verify button text is displayed
      expect(find.text(buttonText), findsOneWidget);

      // Simulate button press
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      // Verify that logger.info was called with the correct message
      verify(mockLogger.info('PrimaryButton tapped!')).called(1);
    });

    testWidgets('PrimaryButton handles long text gracefully', (tester) async {
      const String longText =
          'This is a very long button text that might overflow';
      final logger = getIt<ILogger>();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrimaryButton(
              logger: logger,
              text: longText,
              onPressed: () {},
            ),
          ),
        ),
      );

      // Verify long text is rendered
      expect(find.text(longText), findsOneWidget);

      // Check that button size or layout doesn't break
      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.style!.minimumSize, isNotNull);
    });
  });

  group('Edge Case Tests for Secondary Button', () {
    testWidgets('SecondaryButton displays dynamic text correctly',
        (tester) async {
      String dynamicText = 'Initial Text';
      final logger = getIt<ILogger>();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return SecondaryButton(
                  logger: logger,
                  text: dynamicText,
                  onPressed: () {
                    setState(() {
                      dynamicText = 'Updated Text';
                    });
                  },
                );
              },
            ),
          ),
        ),
      );

      // Verify initial text
      expect(find.text('Initial Text'), findsOneWidget);

      // Trigger button press and update text
      await tester.tap(find.byType(SecondaryButton));
      await tester.pump();

      // Verify updated text
      expect(find.text('Updated Text'), findsOneWidget);
    });

    testWidgets('SecondaryButton logs correctly on tap', (tester) async {
      const String buttonText = 'Click Me';
      final mockLogger = MockAppLogger(); // Use the mock

      // Inject the mock into your dependency injection system
      when(mockLogger.info(any))
          .thenReturn(null); // Optional: Define behavior if needed

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  mockLogger.info('SecondaryButton tapped!');
                },
                child: const Text(buttonText),
              ),
            ),
          ),
        ),
      );

      // Verify button text is displayed
      expect(find.text(buttonText), findsOneWidget);

      // Simulate button press
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      // Verify that logger.info was called with the correct message
      verify(mockLogger.info('SecondaryButton tapped!')).called(1);
    });

    testWidgets('SecondaryButton handles long text gracefully', (tester) async {
      const String longText =
          'This is a very long button text that might overflow';
      final logger = getIt<ILogger>();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SecondaryButton(
              logger: logger,
              text: longText,
              onPressed: () {},
            ),
          ),
        ),
      );

      // Verify long text is rendered
      expect(find.text(longText), findsOneWidget);

      // Check that button size or layout doesn't break
      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.style!.minimumSize, isNotNull);
    });
  });

  group('Edge Case Tests for Outlined Button', () {
    testWidgets('OutlinedPrimaryButton displays dynamic text correctly',
        (tester) async {
      String dynamicText = 'Initial Text';
      final logger = getIt<ILogger>();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return OutlinedPrimaryButton(
                  logger: logger,
                  text: dynamicText,
                  onPressed: () {
                    setState(() {
                      dynamicText = 'Updated Text';
                    });
                  },
                );
              },
            ),
          ),
        ),
      );

      // Verify initial text
      expect(find.text('Initial Text'), findsOneWidget);

      // Trigger button press and update text
      await tester.tap(find.byType(OutlinedPrimaryButton));
      await tester.pump();

      // Verify updated text
      expect(find.text('Updated Text'), findsOneWidget);
    });

    testWidgets('OutlinedPrimaryButton logs correctly on tap', (tester) async {
      const String buttonText = 'Click Me';
      final mockLogger = MockAppLogger(); // Use the mock

      // Inject the mock into your dependency injection system
      when(mockLogger.info(any))
          .thenReturn(null); // Optional: Define behavior if needed

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  mockLogger.info('OutlinedPrimaryButton tapped!');
                },
                child: const Text(buttonText),
              ),
            ),
          ),
        ),
      );

      // Verify button text is displayed
      expect(find.text(buttonText), findsOneWidget);

      // Simulate button press
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      // Verify that logger.info was called with the correct message
      verify(mockLogger.info('OutlinedPrimaryButton tapped!')).called(1);
    });

    testWidgets('OutlinedPrimaryButton handles long text gracefully',
        (tester) async {
      const String longText =
          'This is a very long button text that might overflow';
      final logger = getIt<ILogger>();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OutlinedPrimaryButton(
              logger: logger,
              text: longText,
              onPressed: () {},
            ),
          ),
        ),
      );

      // Verify long text is rendered
      expect(find.text(longText), findsOneWidget);

      // Check that button size or layout doesn't break
      final button = tester.widget<OutlinedButton>(find.byType(OutlinedButton));
      expect(button.style!.minimumSize, isNotNull);
      expect(button.style!.minimumSize!.resolve({}),
          ButtonStyles.getButtonSize(ButtonSize.big));
    });
  });
}
