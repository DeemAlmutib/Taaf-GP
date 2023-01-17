# rotation_stage

![Demo GIF](https://raw.githubusercontent.com/fyzio/rotation_stage/main/example/demo.gif)

A simple and beautiful way to display a four sided widget with a basic 3D effect.

## Usage

The simplest way is to use the ``RotationStage`` widget.
You only have to provide a ``contentBuilder``, everything else is preconfigured.

```dart
Widget build(BuildContext context) {
  return RotationStage(
    contentBuilder: (int index,
        RotationStageSide side,
        double currentPage,) =>
        Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              side.map(
                front: "Front",
                left: "Left",
                back: "Back",
                right: "Right",
              ),
            ),
          ),
        ),
  );
}
```

You can rotate the widget by swiping on the bottom bar. The top part is purposfully not swipeable,
so you can listen to whatever gestures you want there.

If you want more fine-grained control, check out the other parameters of the constructor, or
``RotationStageBar``, ``RotationStageHandle`` and ``RotationStageContent``.

The source code for ``RotationStage`` should be a good starting point.

## Example

To run the example open the ``example`` folder and run ``flutter create .``