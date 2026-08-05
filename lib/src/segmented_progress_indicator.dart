import 'dart:math' as math;

import 'package:flutter/material.dart';

/// A compact segmented arc progress indicator with an optional center value.
///
/// Draws a short fading trail of arc segments that rotate continuously.
/// Useful for indeterminate loading states where a small numeric badge
/// (for example a step count) can appear in the center.
///
/// ```dart
/// SegmentedProgressIndicator(
///   size: 36,
///   centerValue: 3,
/// )
/// ```
class SegmentedProgressIndicator extends StatefulWidget {
  /// Creates a segmented arc progress indicator.
  const SegmentedProgressIndicator({
    super.key,
    this.segmentCount = 6,
    this.size = 30,
    this.strokeWidth = 3,
    this.color = Colors.black,
    this.duration = const Duration(milliseconds: 1000),
    this.centerValue,
  });

  /// Number of arc slots around the circle.
  final int segmentCount;

  /// Width and height of the indicator.
  final double size;

  /// Stroke width of each arc segment.
  final double strokeWidth;

  /// Color of the arcs, head dot, and optional center text.
  final Color color;

  /// Duration of one full rotation.
  final Duration duration;

  /// Optional integer drawn in the center of the indicator.
  final int? centerValue;

  @override
  State<SegmentedProgressIndicator> createState() =>
      _SegmentedProgressIndicatorState();
}

class _SegmentedProgressIndicatorState extends State<SegmentedProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..repeat();
  }

  @override
  void didUpdateWidget(covariant SegmentedProgressIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.duration != widget.duration) {
      _controller.duration = widget.duration;
      if (!_controller.isAnimating) {
        _controller.repeat();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final centerChild = widget.centerValue == null
        ? null
        : Text(
            widget.centerValue.toString(),
            style: TextStyle(fontSize: widget.size * 0.7, color: widget.color),
          );

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        child: centerChild,
        builder: (context, child) {
          final headPosition = _controller.value * widget.segmentCount;

          return Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: Size.square(widget.size),
                painter: _SegmentedArcPainter(
                  segmentCount: widget.segmentCount,
                  fractionalIndex: headPosition,
                  strokeWidth: widget.strokeWidth,
                  color: widget.color,
                ),
              ),
              ?child,
            ],
          );
        },
      ),
    );
  }
}

class _SegmentedArcPainter extends CustomPainter {
  _SegmentedArcPainter({
    required this.segmentCount,
    required this.fractionalIndex,
    required this.strokeWidth,
    required this.color,
  });

  final int segmentCount;
  final double fractionalIndex;
  final double strokeWidth;
  final Color color;

  static const double _trailLength = 4;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width / 2 - strokeWidth;
    final segmentAngle = 2 * math.pi / segmentCount;
    final arcLength = segmentAngle * 0.6;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    for (var i = 0; i < segmentCount; i++) {
      final distanceFromHead =
          (fractionalIndex - i + segmentCount) % segmentCount;

      if (distanceFromHead >= 0 && distanceFromHead <= _trailLength) {
        final fade = (1.0 - (distanceFromHead / _trailLength)).clamp(0.0, 1.0);
        final opacity = math.pow(fade, 1.5).toDouble();
        paint.color = color.withValues(alpha: opacity);

        final startAngle = i * segmentAngle - math.pi / 2;
        canvas.drawArc(
          Rect.fromCircle(center: center, radius: radius),
          startAngle,
          arcLength,
          false,
          paint,
        );
      }
    }

    final headAngle =
        (fractionalIndex * segmentAngle) - math.pi / 2 + arcLength;
    final dotOffset = Offset(
      center.dx + radius * math.cos(headAngle),
      center.dy + radius * math.sin(headAngle),
    );

    canvas.drawCircle(dotOffset, strokeWidth * 1.2, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant _SegmentedArcPainter oldDelegate) {
    return oldDelegate.segmentCount != segmentCount ||
        oldDelegate.fractionalIndex != fractionalIndex ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.color != color;
  }
}

/// A larger segmented spinner with a configurable fading trail.
///
/// Supports an optional [child] overlay (for icons or short labels) and
/// toggles for [visibleTrail] length and the leading [showHeadDot].
///
/// ```dart
/// FadingSegmentedSpinner(
///   size: 72,
///   visibleTrail: 6,
///   child: Icon(Icons.hourglass_top),
/// )
/// ```
class FadingSegmentedSpinner extends StatefulWidget {
  /// Creates a fading segmented spinner.
  const FadingSegmentedSpinner({
    super.key,
    this.segmentCount = 20,
    this.visibleTrail = 5,
    this.size = 60,
    this.strokeWidth = 4,
    this.color = Colors.black,
    this.duration = const Duration(milliseconds: 1000),
    this.child,
    this.showHeadDot = true,
  });

  /// Number of arc slots around the circle.
  final int segmentCount;

  /// How many segments behind the head remain visible.
  final int visibleTrail;

  /// Width and height of the spinner.
  final double size;

  /// Stroke width of each arc segment.
  final double strokeWidth;

  /// Color of the arcs and optional head dot.
  final Color color;

  /// Duration of one full rotation.
  final Duration duration;

  /// Optional widget centered over the spinner.
  final Widget? child;

  /// When `true`, draws a solid dot at the leading edge of the trail.
  final bool showHeadDot;

  @override
  State<FadingSegmentedSpinner> createState() => _FadingSegmentedSpinnerState();
}

class _FadingSegmentedSpinnerState extends State<FadingSegmentedSpinner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..repeat();
  }

  @override
  void didUpdateWidget(covariant FadingSegmentedSpinner oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.duration != widget.duration) {
      _controller.duration = widget.duration;
      if (!_controller.isAnimating) {
        _controller.repeat();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        child: widget.child,
        builder: (context, child) {
          final fractionalIndex = _controller.value * widget.segmentCount;

          return Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: Size.square(widget.size),
                painter: _FadingSegmentedPainter(
                  segmentCount: widget.segmentCount,
                  visibleTrail: widget.visibleTrail,
                  fractionalIndex: fractionalIndex,
                  strokeWidth: widget.strokeWidth,
                  color: widget.color,
                  showHeadDot: widget.showHeadDot,
                ),
              ),
              ?child,
            ],
          );
        },
      ),
    );
  }
}

class _FadingSegmentedPainter extends CustomPainter {
  _FadingSegmentedPainter({
    required this.segmentCount,
    required this.visibleTrail,
    required this.fractionalIndex,
    required this.strokeWidth,
    required this.color,
    required this.showHeadDot,
  });

  final int segmentCount;
  final int visibleTrail;
  final double fractionalIndex;
  final double strokeWidth;
  final Color color;
  final bool showHeadDot;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = (size.width / 2) - strokeWidth / 2;
    final segmentAngle = 2 * math.pi / segmentCount;
    final arcLength = segmentAngle * 0.6;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    for (var i = 0; i < segmentCount; i++) {
      final distance = (fractionalIndex - i + segmentCount) % segmentCount;

      if (distance >= 0 && distance <= visibleTrail) {
        final fade = (1.0 - (distance / visibleTrail)).clamp(0.0, 1.0);
        final opacity = math.pow(fade, 1.5).toDouble();
        paint.color = color.withValues(alpha: opacity);

        final startAngle = i * segmentAngle - math.pi / 2;
        canvas.drawArc(rect, startAngle, arcLength, false, paint);
      }
    }

    if (showHeadDot) {
      final headAngle =
          (fractionalIndex * segmentAngle) - math.pi / 2 + arcLength;
      final dotOffset = Offset(
        center.dx + radius * math.cos(headAngle),
        center.dy + radius * math.sin(headAngle),
      );

      canvas.drawCircle(dotOffset, strokeWidth * 1.1, Paint()..color = color);
    }
  }

  @override
  bool shouldRepaint(covariant _FadingSegmentedPainter oldDelegate) {
    return oldDelegate.segmentCount != segmentCount ||
        oldDelegate.visibleTrail != visibleTrail ||
        oldDelegate.fractionalIndex != fractionalIndex ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.color != color ||
        oldDelegate.showHeadDot != showHeadDot;
  }
}
