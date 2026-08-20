import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:example/main.dart';

void main() {
  testWidgets('demo shows both indicator widgets', (tester) async {
    await tester.pumpWidget(const SegmentedProgressIndicatorDemo());

    expect(find.text('Segmented Progress Indicator'), findsOneWidget);
    expect(find.text('SegmentedProgressIndicator'), findsOneWidget);
    expect(find.text('3'), findsOneWidget);

    // Later ListView sections are off-stage until scrolled into view.
    await tester.scrollUntilVisible(
      find.text('FadingSegmentedSpinner'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('FadingSegmentedSpinner'), findsOneWidget);
    expect(find.text('Go'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 200));
    expect(tester.takeException(), isNull);
  });
}
