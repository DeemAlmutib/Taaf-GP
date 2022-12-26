import 'dart:math';

import 'package:body_part_selector/src/model/body_parts.dart';
import 'package:body_part_selector/src/model/body_side.dart';
import 'package:body_part_selector/src/service/successSave.dart';
import 'package:body_part_selector/src/service/svg_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:taaf/SymptomsPages/headSy.dart';
import 'package:taaf/SymptomsPages/neckSy.dart';
import 'package:touchable/touchable.dart';
import 'package:taaf/SymptomsPages/upperBoday.dart';
import 'package:taaf/SymptomsPages/Knee.dart';
import 'package:taaf/SymptomsPages/abdomen.dart';
import 'package:taaf/SymptomsPages/back.dart';
import 'package:taaf/SymptomsPages/lowerBody.dart';
import 'package:taaf/SymptomsPages/muscle.dart';
import 'package:taaf/SymptomsPages/handFoot.dart';

class BodyPartSelector extends StatelessWidget {
  const BodyPartSelector({
    super.key,
    required this.side,
    required this.bodyParts,
    required this.onSelectionUpdated,
    this.mirrored = false,
    this.selectedColor,
    this.unselectedColor,
    this.selectedOutlineColor,
    this.unselectedOutlineColor,
  });

  final BodySide side;
  final BodyParts bodyParts;
  final void Function(BodyParts bodyParts)? onSelectionUpdated;

  final bool mirrored;

  final Color? selectedColor;
  final Color? unselectedColor;
  final Color? selectedOutlineColor;
  final Color? unselectedOutlineColor;

  @override
  Widget build(BuildContext context) {
    final notifier = SvgService.instance.getSide(side);
    return ValueListenableBuilder<DrawableRoot?>(
        valueListenable: notifier,
        builder: (context, value, _) {
          if (value == null) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          } else {
            return _buildBody(context, value);
          }
        });
  }

  Widget _buildBody(BuildContext context, DrawableRoot drawable) {
    final colorScheme = Theme.of(context).colorScheme;
    return AnimatedSwitcher(
      duration: kThemeAnimationDuration,
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeOutCubic,
      child: SizedBox.expand(
        key: ValueKey(bodyParts),
        child: CanvasTouchDetector(
          gesturesToOverride: const [GestureType.onTapDown],
          builder: (context) => CustomPaint(
            painter: _BodyPainter(
              root: drawable,
              bodyParts: bodyParts,
              onTap: (s) {
                if (s == "head") {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (contex) => (HeadSymptoms()),
                      ));
                } else if (s == "neck") {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => (neckSymptoms()),
                      ));
                } else if (s == "upperBody") {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => (upperBoday()),
                      ));
                } else if (s == "leftKnee" || s == "rightKnee") {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => (Knee()),
                      ));
                } else if (s == "abdomen") {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            (abdomen()), //abdomen under stomach
                      ));
                } else if (s == "lowerBody") {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            (lowerBody()), //lower boday (stomach) i think
                      ));
                } //muscle
                else if (s == "leftShoulder" ||
                    s == "leftUpperArm" ||
                    s == "rightShoulder" ||
                    s == "rightLowerArm" ||
                    s == "leftLowerArm" ||
                    s == "leftElbow" ||
                    s == "leftUpperLeg" ||
                    s == "rightUpperArm" ||
                    s == "leftLowerLeg" ||
                    s == "rightUpperLeg" ||
                    s == "rightLowerLeg") {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => (muscle()), //all muscles
                      ));
                } else if (s == "leftHand" ||
                    s == "leftFoot" ||
                    s == "rightFoot" ||
                    s == "rightHand") {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => (handFoot()), //hand and foot only
                      ));
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => (success2(title: "title"))),
                  );
                }
              },
              context: context,
              selectedColor: selectedColor ?? colorScheme.inversePrimary,
              unselectedColor: unselectedColor ?? Color.fromARGB(255, 155, 155, 155),
              selectedOutlineColor: selectedOutlineColor ?? colorScheme.primary,
              unselectedOutlineColor:
                  unselectedOutlineColor ?? colorScheme.onInverseSurface,
            ),
          ),
        ),
      ),
    );
  }
}

class _BodyPainter extends CustomPainter {
  _BodyPainter({
    required this.root,
    required this.bodyParts,
    required this.onTap,
    required this.context,
    required this.selectedColor,
    required this.unselectedColor,
    required this.unselectedOutlineColor,
    required this.selectedOutlineColor,
  });

  final DrawableRoot root;
  final BuildContext context;
  final void Function(String) onTap;
  final BodyParts bodyParts;
  final Color selectedColor;
  final Color unselectedColor;
  final Color unselectedOutlineColor;

  final Color selectedOutlineColor;

  bool isSelected(String key) {
    final selections = bodyParts.toJson();
    if (selections.containsKey(key) && selections[key]!) {
      return true;
    }
    return false;
  }

  void drawBodyParts({
    required TouchyCanvas touchyCanvas,
    required Canvas plainCanvas,
    required Size size,
    required Iterable<Drawable> drawables,
    required Matrix4 fittingMatrix,
  }) {
    for (final element in drawables) {
      final id = element.id;
      if (id == null) {
        debugPrint("Found a drawable element without an ID. Skipping $element");
        continue;
      }
      touchyCanvas.drawPath(
        (element as DrawableShape).path.transform(fittingMatrix.storage),
        Paint()
          ..color = isSelected(id) ? selectedColor : unselectedColor
          ..style = PaintingStyle.fill,
        onTapDown: (_) => onTap(id),
      );
      plainCanvas.drawPath(
        element.path.transform(fittingMatrix.storage),
        Paint()
          ..color =
              isSelected(id) ? selectedOutlineColor : unselectedOutlineColor
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke,
      );
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (size != root.viewport.viewBoxRect.size) {
      final double scale = min(
        size.width / root.viewport.viewBoxRect.width,
        size.height / root.viewport.viewBoxRect.height,
      );
      final Size scaledHalfViewBoxSize =
          root.viewport.viewBoxRect.size * scale / 2.0;
      final Size halfDesiredSize = size / 2.0;
      final Offset shift = Offset(
        halfDesiredSize.width - scaledHalfViewBoxSize.width,
        halfDesiredSize.height - scaledHalfViewBoxSize.height,
      );

      final bodyPartsCanvas = TouchyCanvas(context, canvas);

      final Matrix4 fittingMatrix = Matrix4.identity()
        ..translate(shift.dx, shift.dy)
        ..scale(scale);

      final drawables =
          root.children.where((element) => element.hasDrawableContent);

      drawBodyParts(
        touchyCanvas: bodyPartsCanvas,
        plainCanvas: canvas,
        size: size,
        drawables: drawables,
        fittingMatrix: fittingMatrix,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
