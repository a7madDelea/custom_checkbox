// ignore_for_file: deprecated_member_use

import 'dart:ui';
import 'package:custom_checkbox_plus/custom_checkbox.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('CustomCheckBox', () {
    testWidgets('toggles value when tapped 🟢', (tester) async {
      var value = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomCheckBox(
              value: value,
              onChanged: (v) => value = v,
            ),
          ),
        ),
      );

      expect(value, isFalse);
      await tester.tap(find.byType(CustomCheckBox));
      await tester.pumpAndSettle();
      expect(value, isTrue);
    });

    testWidgets('does not toggle when disabled 🚫', (tester) async {
      var value = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomCheckBox(
              value: value,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(CustomCheckBox));
      await tester.pumpAndSettle();
      expect(value, isFalse);
    });

    testWidgets('renders correct icon when checked ✅', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CustomCheckBox(
              value: true,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.check_rounded), findsOneWidget);
    });

    testWidgets('renders no icon when unchecked ⬜', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CustomCheckBox(
              value: false,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.check_rounded), findsNothing);
    });

    testWidgets('supports custom shape (circle) ⚪', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CustomCheckBox(
              value: true,
              shape: BoxShape.circle,
            ),
          ),
        ),
      );

      final container = tester.widget<AnimatedContainer>(
        find.byType(AnimatedContainer),
      );
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.shape, equals(BoxShape.circle));
    });

    testWidgets('shows tooltip when hovered or long pressed 💬',
        (tester) async {
      const tooltipText = 'Check me!';
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: CustomCheckBox(
                value: false,
                tooltip: tooltipText,
              ),
            ),
          ),
        ),
      );

      final tooltipFinder = find.byType(Tooltip);
      expect(tooltipFinder, findsOneWidget);

      final dynamic tooltip = tester.firstWidget(tooltipFinder);
      expect(tooltip.message, equals(tooltipText));
    });

    testWidgets('animates between states smoothly 🎞️', (tester) async {
      var value = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) => CustomCheckBox(
                value: value,
                onChanged: (v) => setState(() => value = v),
                animationDuration: const Duration(milliseconds: 200),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(CustomCheckBox));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(AnimatedSwitcher), findsOneWidget);
      await tester.pumpAndSettle();
    });

    testWidgets('applies disabledOpacity correctly 🔆', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CustomCheckBox(
              value: true,
              disabledOpacity: 0.3,
              fillColor: Colors.black,
            ),
          ),
        ),
      );

      final container = tester.widget<AnimatedContainer>(
        find.byType(AnimatedContainer),
      );
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color!.opacity, closeTo(0.3, 0.05));
    });

    testWidgets('triggers haptic feedback when enabled 🔔', (tester) async {
      var value = false;
      bool feedbackCalled = false;

      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(SystemChannels.platform, (call) async {
        if (call.method == 'HapticFeedback.vibrate') {
          feedbackCalled = true;
        }
        return null;
      });

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomCheckBox(
              value: value,
              enableHapticFeedback: true,
              onChanged: (v) => value = v,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(CustomCheckBox));
      await tester.pumpAndSettle();

      expect(feedbackCalled, isTrue);
    });

    testWidgets('has semantics for screen readers ♿', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomCheckBox(
              value: true,
              onChanged: (_) {},
              semanticsLabel: 'Accept terms',
            ),
          ),
        ),
      );

      final semantics = tester.getSemantics(find.byType(CustomCheckBox));

      if ((semantics.toString()).contains('flagsCollection')) {
        // ignore: avoid_dynamic_calls
        final flags = (semantics as dynamic).flagsCollection as Iterable;
        expect(flags.contains(SemanticsFlag.hasCheckedState), isTrue);
        expect(flags.contains(SemanticsFlag.isChecked), isTrue);
      } else {
        expect(semantics.hasFlag(SemanticsFlag.hasCheckedState), isTrue);
        expect(semantics.hasFlag(SemanticsFlag.isChecked), isTrue);
      }
    });
  });
}
