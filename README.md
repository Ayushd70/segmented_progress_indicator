# segmented_progress_indicator

[![CI](https://github.com/Ayushd70/segmented_progress_indicator/actions/workflows/ci.yml/badge.svg)](https://github.com/Ayushd70/segmented_progress_indicator/actions/workflows/ci.yml)
[![pub package](https://img.shields.io/pub/v/segmented_progress_indicator.svg)](https://pub.dev/packages/segmented_progress_indicator)

Segmented arc **progress** and **spinner** widgets for Flutter.

![Demo](https://raw.githubusercontent.com/Ayushd70/segmented_progress_indicator/main/doc/demo.gif)

## Features

- `SegmentedProgressIndicator` — compact rotating arc trail with optional center value or custom center widget
- `FadingSegmentedSpinner` — larger spinner with configurable trail, head dot, child overlay, and optional background track
- Indeterminate (repeating) or determinate (`progress` 0.0–1.0) modes
- Freeze animation with `animate: false`
- Smooth exponential fade along the trailing segments
- Customize size, stroke, color, segment count, trail, and duration
- Zero third-party dependencies beyond Flutter

## Install

```yaml
dependencies:
  segmented_progress_indicator: ^0.2.0
```

```dart
import 'package:segmented_progress_indicator/segmented_progress_indicator.dart';
```

## Usage

### Progress with center value

```dart
const SegmentedProgressIndicator(
  size: 40,
  strokeWidth: 3.5,
  color: Colors.indigo,
  centerValue: 3,
)
```

### Custom center child

```dart
SegmentedProgressIndicator(
  size: 48,
  color: Colors.indigo,
  centerChild: Icon(Icons.check, size: 20, color: Colors.indigo),
)
```

### Determinate progress

```dart
const SegmentedProgressIndicator(
  size: 48,
  progress: 0.65,
  centerValue: 65,
)

FadingSegmentedSpinner(
  size: 72,
  progress: 0.4,
  backgroundTrackColor: Colors.indigo.withValues(alpha: 0.15),
)
```

### Fading spinner with overlay

```dart
FadingSegmentedSpinner(
  size: 72,
  segmentCount: 20,
  visibleTrail: 6,
  showHeadDot: true,
  color: Colors.indigo,
  child: Icon(Icons.hourglass_top, color: Colors.indigo.shade700),
)
```

### Customization

| Parameter | Widget | Description |
| --- | --- | --- |
| `segmentCount` | both | Arc slots around the circle |
| `size` | both | Width and height |
| `strokeWidth` | both | Arc stroke thickness |
| `color` | both | Arc / head / center text color |
| `duration` | both | One full rotation |
| `animate` | both | When `false`, freeze at current / progress |
| `progress` | both | Determinate head position (`0.0`–`1.0`); `null` = indeterminate |
| `centerValue` | progress | Optional integer in the center |
| `centerChild` | progress | Optional center widget (wins over `centerValue`) |
| `centerTextStyle` | progress | Style for `centerValue` text |
| `trailLength` | progress | How far the fading trail extends (default `4`) |
| `showHeadDot` | both | Draw a solid leading-edge dot |
| `visibleTrail` | spinner | How many segments behind the head stay visible |
| `child` | spinner | Optional centered overlay widget |
| `backgroundTrackColor` | spinner | Optional faint full-circle track |

## Example

See the [`example/`](example/) app for side-by-side demos of both widgets.

## License

MIT
