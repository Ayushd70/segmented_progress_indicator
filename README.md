# segmented_progress_indicator

[![CI](https://github.com/Ayushd70/segmented_progress_indicator/actions/workflows/ci.yml/badge.svg)](https://github.com/Ayushd70/segmented_progress_indicator/actions/workflows/ci.yml)
[![pub package](https://img.shields.io/pub/v/segmented_progress_indicator.svg)](https://pub.dev/packages/segmented_progress_indicator)

Segmented arc **progress** and **spinner** widgets for Flutter.

![Demo](https://raw.githubusercontent.com/Ayushd70/segmented_progress_indicator/main/doc/demo.gif)

## Features

- `SegmentedProgressIndicator` — compact rotating arc trail with optional center value
- `FadingSegmentedSpinner` — larger spinner with configurable trail, head dot, and child overlay
- Smooth exponential fade along the trailing segments
- Customize size, stroke, color, segment count, and duration
- Zero third-party dependencies beyond Flutter

## Install

```yaml
dependencies:
  segmented_progress_indicator: ^0.1.0
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
| `centerValue` | progress | Optional integer in the center |
| `visibleTrail` | spinner | How many segments behind the head stay visible |
| `showHeadDot` | spinner | Draw a solid leading-edge dot |
| `child` | spinner | Optional centered overlay widget |

## Example

See the [`example/`](example/) app for side-by-side demos of both widgets.

## License

MIT
