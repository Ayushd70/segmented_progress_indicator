import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:segmented_progress_indicator/segmented_progress_indicator.dart';

void main() {
  testWidgets('SegmentedProgressIndicator renders', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: Center(child: SegmentedProgressIndicator())),
      ),
    );

    expect(find.byType(SegmentedProgressIndicator), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 100));
    expect(tester.takeException(), isNull);
  });

  testWidgets('SegmentedProgressIndicator shows centerValue', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(child: SegmentedProgressIndicator(centerValue: 7)),
        ),
      ),
    );

    expect(find.text('7'), findsOneWidget);
  });

  testWidgets(
    'SegmentedProgressIndicator prefers centerChild over centerValue',
    (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: SegmentedProgressIndicator(
                centerValue: 7,
                centerChild: Text('custom'),
              ),
            ),
          ),
        ),
      );

      expect(find.text('custom'), findsOneWidget);
      expect(find.text('7'), findsNothing);
    },
  );

  testWidgets('SegmentedProgressIndicator determinate progress freezes head', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(
            child: SegmentedProgressIndicator(progress: 0.5, centerValue: 50),
          ),
        ),
      ),
    );

    expect(find.text('50'), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 500));
    expect(tester.takeException(), isNull);
    expect(find.byType(SegmentedProgressIndicator), findsOneWidget);
  });

  testWidgets('SegmentedProgressIndicator animate false does not rotate', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(child: SegmentedProgressIndicator(animate: false)),
        ),
      ),
    );

    await tester.pump(const Duration(milliseconds: 500));
    expect(tester.takeException(), isNull);
    expect(find.byType(SegmentedProgressIndicator), findsOneWidget);
  });

  testWidgets('FadingSegmentedSpinner renders', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: Center(child: FadingSegmentedSpinner())),
      ),
    );

    expect(find.byType(FadingSegmentedSpinner), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 100));
    expect(tester.takeException(), isNull);
  });

  testWidgets('FadingSegmentedSpinner shows child overlay', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(
            child: FadingSegmentedSpinner(
              showHeadDot: false,
              visibleTrail: 4,
              child: Text('Loading'),
            ),
          ),
        ),
      ),
    );

    expect(find.text('Loading'), findsOneWidget);
    expect(find.byType(FadingSegmentedSpinner), findsOneWidget);
  });

  testWidgets('FadingSegmentedSpinner determinate progress freezes head', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: FadingSegmentedSpinner(
              progress: 0.25,
              backgroundTrackColor: Colors.grey.withValues(alpha: 0.2),
              child: const Text('25%'),
            ),
          ),
        ),
      ),
    );

    expect(find.text('25%'), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 500));
    expect(tester.takeException(), isNull);
  });

  testWidgets('FadingSegmentedSpinner animate false does not rotate', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(child: FadingSegmentedSpinner(animate: false)),
        ),
      ),
    );

    await tester.pump(const Duration(milliseconds: 500));
    expect(tester.takeException(), isNull);
    expect(find.byType(FadingSegmentedSpinner), findsOneWidget);
  });
}
