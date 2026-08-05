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
}
