A customizable segmented progress bar.



## Installation

In the `pubspec.yaml` of your flutter project, add the following dependency:

```yaml
dependencies:
  flutter:
    sdk:
  segmented_progress_bar: any
```

Import the segmented progress bar package like this:

```dart
  import 'package:segmented_progress_bar/segmented_progress_bar.dart';
```

## Usage

Simply create a SegmentedProgressBar widget, and pass the required params:

```dart
      List<ProgressSegment> get socialSegments => [
          ProgressSegment(value: 5, color: Colors.pink, label: 'Instagram \n 50%'),
          ProgressSegment(
              value: 3, color: Colors.indigo, label: 'Facebook \n 30%', isAbove: true, labelPadding: 20),
          ProgressSegment(value: 1, color: Colors.redAccent, label: 'Threads \n 10%'),
          ProgressSegment(
              value: 3, color: Colors.lightBlue, label: 'Tweeter \n 20%', isAbove: true, labelPadding: 20),
        ];

        
        @override
        Widget build(BuildContext context) {
          return Center(
            child: SegmentedProgressBar(
              segments: socialSegments,
            ),
          );
        }
```

## Customization

Customize the SegmentedProgressBar widget with these parameters:

```dart


    /// List of segments in the progress bar
    final List<ProgressSegment> segments;
    
    /// Height of progress bar
    /// Defaults to 20
    final double height;
    
    /// Border radius of progress bar
    /// Defaults to 5
    final double borderRadius;
```
