import 'package:body_part_selector/src/body_part_selector.dart';
import 'package:body_part_selector/src/model/body_parts.dart';
import 'package:body_part_selector/src/model/body_side.dart';
import 'package:flutter/material.dart';
import 'package:rotation_stage/rotation_stage.dart';
import 'package:arrow_pad/arrow_pad.dart';
export 'package:rotation_stage/rotation_stage.dart';

class BodyPartSelectorTurnable extends StatelessWidget {
  const BodyPartSelectorTurnable({
    super.key,
    required this.bodyParts,
    this.onSelectionUpdated,
    this.mirrored = false,
    this.padding = EdgeInsets.zero,
    //  required this.arrowPad,
    this.labelData,
  });

  final BodyParts bodyParts;
  final Function(BodyParts)? onSelectionUpdated;
  final bool mirrored;
  final EdgeInsets padding;
  final RotationStageLabelData? labelData;
  //final ArrowPad arrowPad;

  // final Padding arrow;
  //final viewHandleBuilder?arrow;
// default usage

  @override
  Widget build(BuildContext context) {
    return RotationStage(
      contentBuilder: (index, side, page) => Padding(
        padding: padding,
        child: Padding(
          padding: const EdgeInsets.only(top: 170.0, bottom: 50),
          child: BodyPartSelector(
            side: side.map(
              front: BodySide.front,
              left: BodySide.left,
              back: BodySide.back,
              right: BodySide.right,
            ),
            bodyParts: bodyParts,
            onSelectionUpdated: onSelectionUpdated,
            mirrored: mirrored,
          ),
        ),
      ),
      labels: labelData,

      //  controller:controller ,

      /*  viewHandleBuilder: (index, side, page) => Padding(
          //trying another way

          padding: padding,
          child: Padding(
              padding: const EdgeInsets.only(top: 150.0, bottom: 90),

              //  arrow:

              child: ArrowPad(
                  height: 80.0,
                  width: 80.0,
                  innerColor: Colors.blue,
                  arrowPadIconStyle: ArrowPadIconStyle.arrow,
                  onPressedUp: () => print('up'),
                  onPressedLeft: () => print('left'),
                  onPressedRight: () => print('right'),
                  onPressedDown: () => print('down')))),*/
      // )
      // barHeight: 200,
      //  child:
    );
  }
}
//          padding: const EdgeInsets.only(top: 130.0, bottom: 50),
