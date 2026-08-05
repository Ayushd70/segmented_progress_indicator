import 'package:flutter/material.dart';
import 'package:segmented_progress_indicator/segmented_progress_indicator.dart';

void main() {
  runApp(const SegmentedProgressIndicatorDemo());
}

class SegmentedProgressIndicatorDemo extends StatelessWidget {
  const SegmentedProgressIndicatorDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'segmented_progress_indicator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1B4DFF),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF2F4F8),
      ),
      home: const DemoHomePage(),
    );
  }
}

class DemoHomePage extends StatelessWidget {
  const DemoHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Segmented Progress Indicator'),
        centerTitle: false,
        backgroundColor: scheme.surface,
        surfaceTintColor: Colors.transparent,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'Compact progress arcs and a larger fading spinner — both from '
            'the same segmented-trail painting approach.',
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: scheme.onSurfaceVariant),
          ),
          const SizedBox(height: 28),
          _DemoCard(
            title: 'SegmentedProgressIndicator',
            subtitle: 'Optional centerValue for step-style badges',
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SegmentedProgressIndicator(size: 36, color: scheme.primary),
                SegmentedProgressIndicator(
                  size: 48,
                  strokeWidth: 3.5,
                  color: scheme.primary,
                  centerValue: 3,
                ),
                SegmentedProgressIndicator(
                  size: 40,
                  segmentCount: 8,
                  color: scheme.tertiary,
                  centerValue: 12,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _DemoCard(
            title: 'FadingSegmentedSpinner',
            subtitle: 'Child overlay, visibleTrail, and showHeadDot',
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FadingSegmentedSpinner(
                  size: 72,
                  color: scheme.primary,
                  visibleTrail: 6,
                ),
                FadingSegmentedSpinner(
                  size: 80,
                  color: scheme.primary,
                  visibleTrail: 8,
                  child: Icon(Icons.hourglass_top, color: scheme.primary),
                ),
                FadingSegmentedSpinner(
                  size: 72,
                  color: scheme.tertiary,
                  showHeadDot: false,
                  visibleTrail: 4,
                  child: Text(
                    'Go',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: scheme.tertiary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DemoCard extends StatelessWidget {
  const _DemoCard({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Material(
      color: scheme.surface,
      elevation: 0,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
            ),
            const SizedBox(height: 28),
            SizedBox(height: 96, child: Center(child: child)),
          ],
        ),
      ),
    );
  }
}
