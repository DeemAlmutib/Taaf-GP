import 'dart:math';

import 'package:body_part_selector/src/model/body_parts.dart';
import 'package:body_part_selector/src/model/body_side.dart';
import 'package:body_part_selector/src/service/successSave.dart';
import 'package:body_part_selector/src/service/svg_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taaf/SymptomsPages/headSy.dart';
import 'package:taaf/SymptomsPages/neckSy.dart';
import 'package:taaf/navigator_keys.dart';
import 'package:touchable/touchable.dart';
import 'package:taaf/SymptomsPages/upperBoday.dart';
import 'package:taaf/SymptomsPages/Knee.dart';
import 'package:taaf/SymptomsPages/abdomen.dart';
import 'package:taaf/SymptomsPages/back.dart';
import 'package:taaf/SymptomsPages/lowerBody.dart';
import 'package:taaf/SymptomsPages/muscle.dart';
import 'package:taaf/SymptomsPages/handFoot.dart';

class BodyPartSelector extends StatelessWidget {
  BodyPartSelector({
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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
    // dependOnInheritedWidgetOfExactType();
    final colorScheme = Theme.of(context).colorScheme;
    return AnimatedSwitcher(
      //key: myGlobals.scaffoldKey,
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
                  onSelectionUpdated
                      ?.call(bodyParts.withToggledId(s, mirror: mirrored));

                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                          title: Text(" هل  تعاني من ألم في منطقة الرأس؟ ",
                              style: GoogleFonts.tajawal(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                              textAlign: TextAlign.right),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                "لا",
                                style: GoogleFonts.tajawal(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                // Navigator.pushReplacement(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) => HeadSymptoms()));
                                  Navigation.mainNavigation.currentState!.pushNamed("/main/7");
                                        Navigator.of(context).pop();
                              },
                              child: Text(
                                "نعم",
                                style: GoogleFonts.tajawal(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                            ),
                          ]);
                    },
                  );
                } else if (s == "neck") {
                  onSelectionUpdated
                      ?.call(bodyParts.withToggledId(s, mirror: mirrored));

                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                          title: Text(" هل  تعاني من ألم في منطقة الرقبة ",
                              style: GoogleFonts.tajawal(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                              textAlign: TextAlign.right),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                "لا",
                                style: GoogleFonts.tajawal(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                // Navigator.pushReplacement(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) => neckSymptoms()));
                                  Navigation.mainNavigation.currentState!.pushNamed("/main/8");
                                        Navigator.of(context).pop();
                              },
                              child: Text(
                                "نعم",
                                style: GoogleFonts.tajawal(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                            ),
                          ]);
                    },
                  );
                } else if (s == "upperBody") {
                  onSelectionUpdated
                      ?.call(bodyParts.withToggledId(s, mirror: mirrored));

                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                          title: Text(" هل تعاني من ألم في منطقة الصدر؟    ",
                              style: GoogleFonts.tajawal(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                              textAlign: TextAlign.right),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                "لا",
                                style: GoogleFonts.tajawal(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                //Navigator.pushReplacement(
                                    //context,
                                    // MaterialPageRoute(
                                    //     builder: (context) => upperBoday()));
                                        //Navigation.mainNavigation
                                        Navigation.mainNavigation.currentState!.pushNamed("/main/6");
                                        Navigator.of(context).pop();
                              },
                              child: Text(
                                "نعم",
                                style: GoogleFonts.tajawal(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                            ),
                          ]);
                    },
                  );
                } else if (s == "leftKnee" || s == "rightKnee") {
                  onSelectionUpdated
                      ?.call(bodyParts.withToggledId(s, mirror: mirrored));

                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                          title: Text(" هل تعاني من ألم في ركبتك؟     ",
                              style: GoogleFonts.tajawal(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                              textAlign: TextAlign.right),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                "لا",
                                style: GoogleFonts.tajawal(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                // Navigator.pushReplacement(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) => Knee()));
                                          Navigation.mainNavigation.currentState!.pushNamed("/main/9");
                                        Navigator.of(context).pop();
                              },
                              child: Text(
                                "نعم",
                                style: GoogleFonts.tajawal(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                            ),
                          ]);
                    },
                  );
                } else if (s == "abdomen") {
                  onSelectionUpdated
                      ?.call(bodyParts.withToggledId(s, mirror: mirrored));

                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                          title: Text(
                              " هل تعاني من ألم في أسفل منطقة البطن ؟     ",
                              style: GoogleFonts.tajawal(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                              textAlign: TextAlign.right),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                "لا",
                                style: GoogleFonts.tajawal(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                // Navigator.pushReplacement(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) => abdomen()));
                                  Navigation.mainNavigation.currentState!.pushNamed("/main/10");
                                        Navigator.of(context).pop();
                              },
                              child: Text(
                                "نعم",
                                style: GoogleFonts.tajawal(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                            ),
                          ]);
                    },
                  );
                } else if (s == "lowerBody") {
                  onSelectionUpdated
                      ?.call(bodyParts.withToggledId(s, mirror: mirrored));

                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                          title: Text(" هل تعاني من ألم في بطنك  ؟     ",
                              style: GoogleFonts.tajawal(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                              textAlign: TextAlign.right),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                "لا",
                                style: GoogleFonts.tajawal(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                // Navigator.pushReplacement(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) => lowerBody()));
                                 Navigation.mainNavigation.currentState!.pushNamed("/main/11");
                                  Navigator.of(context).pop();
                                
                              },
                              child: Text(
                                "نعم",
                                style: GoogleFonts.tajawal(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                            ),
                          ]);
                    },
                  );
                } else if (s == "leftShoulder" || s == "rightShoulder") {
                  onSelectionUpdated
                      ?.call(bodyParts.withToggledId(s, mirror: mirrored));

                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                          title: Text(" هل تعاني من ألم في كتفك  ؟     ",
                              style: GoogleFonts.tajawal(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                              textAlign: TextAlign.right),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                "لا",
                                style: GoogleFonts.tajawal(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                // Navigator.pushReplacement(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) => muscle()));
                                Navigation.mainNavigation.currentState!.pushNamed("/main/12");
                                  Navigator.of(context).pop();
                              },
                              child: Text(
                                "نعم",
                                style: GoogleFonts.tajawal(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                            ),
                          ]);
                    },
                  );
                } else if (s == "leftUpperArm" || s == "rightUpperArm") {
                  onSelectionUpdated
                      ?.call(bodyParts.withToggledId(s, mirror: mirrored));

                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                          title: Text(
                              " هل تعاني من ألم في الذراع العلوي  ؟     ",
                              style: GoogleFonts.tajawal(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                              textAlign: TextAlign.right),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                "لا",
                                style: GoogleFonts.tajawal(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                // Navigator.pushReplacement(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) => muscle()));
                                Navigation.mainNavigation.currentState!.pushNamed("/main/12");
                                  Navigator.of(context).pop();


                              },
                              child: Text(
                                "نعم",
                                style: GoogleFonts.tajawal(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                            ),
                          ]);
                    },
                  );
                } else if (s == "rightLowerArm" || s == "leftLowerArm") {
                  onSelectionUpdated
                      ?.call(bodyParts.withToggledId(s, mirror: mirrored));

                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                          title: Text(
                              " هل تعاني من ألم في الذراع السفلي  ؟     ",
                              style: GoogleFonts.tajawal(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                              textAlign: TextAlign.right),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                "لا",
                                style: GoogleFonts.tajawal(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                // Navigator.pushReplacement(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) => muscle()));
                                Navigation.mainNavigation.currentState!.pushNamed("/main/12");
                                  Navigator.of(context).pop();
                              },
                              child: Text(
                                "نعم",
                                style: GoogleFonts.tajawal(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                            ),
                          ]);
                    },
                  );
                } else if (s == "leftElbow" || s == "rightElbow") {
                  onSelectionUpdated
                      ?.call(bodyParts.withToggledId(s, mirror: mirrored));

                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                          title: Text(" هل تعاني من ألم في  المرفق  ؟     ",
                              style: GoogleFonts.tajawal(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                              textAlign: TextAlign.right),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                "لا",
                                style: GoogleFonts.tajawal(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                // Navigator.pushReplacement(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) => muscle()));
                                Navigation.mainNavigation.currentState!.pushNamed("/main/12");
                                  Navigator.of(context).pop();
                              },
                              child: Text(
                                "نعم",
                                style: GoogleFonts.tajawal(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                            ),
                          ]);
                    },
                  );
                } else if (s == "leftUpperLeg" || s == "rightUpperLeg") {
                  onSelectionUpdated
                      ?.call(bodyParts.withToggledId(s, mirror: mirrored));

                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                          title: Text(
                              " هل تعاني من ألم في الجزء العلوي من الساق (الفخذ) ؟     ",
                              style: GoogleFonts.tajawal(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                              textAlign: TextAlign.right),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                "لا",
                                style: GoogleFonts.tajawal(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                // Navigator.pushReplacement(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) => muscle()));
                                Navigation.mainNavigation.currentState!.pushNamed("/main/12");
                                  Navigator.of(context).pop();
                              },
                              child: Text(
                                "نعم",
                                style: GoogleFonts.tajawal(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                            ),
                          ]);
                    },
                  );
                } else if (s == "leftLowerLeg" || s == "rightLowerLeg") {
                  onSelectionUpdated
                      ?.call(bodyParts.withToggledId(s, mirror: mirrored));

                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                          title: Text(" هل تعاني من ألم في  الساق؟ ؟     ",
                              style: GoogleFonts.tajawal(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                              textAlign: TextAlign.right),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                "لا",
                                style: GoogleFonts.tajawal(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                // Navigator.pushReplacement(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) => muscle()));
                                Navigation.mainNavigation.currentState!.pushNamed("/main/12");
                                  Navigator.of(context).pop();
                              },
                              child: Text(
                                "نعم",
                                style: GoogleFonts.tajawal(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                            ),
                          ]);
                    },
                  );
                } else if (s == "leftHand" || s == "rightHand") {
                  onSelectionUpdated
                      ?.call(bodyParts.withToggledId(s, mirror: mirrored));

                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                          title: Text(" هل تعاني من ألم في  يدك ؟     ",
                              style: GoogleFonts.tajawal(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                              textAlign: TextAlign.right),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                "لا",
                                style: GoogleFonts.tajawal(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                // Navigator.pushReplacement(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) => handFoot()));
                                 Navigation.mainNavigation.currentState!.pushNamed("/main/13");
                                  Navigator.of(context).pop();
                              },
                              child: Text(
                                "نعم",
                                style: GoogleFonts.tajawal(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                            ),
                          ]);
                    },
                  );
                } else if (s == "leftFoot" || s == "rightFoot") {
                  onSelectionUpdated
                      ?.call(bodyParts.withToggledId(s, mirror: mirrored));

                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                          title: Text(" هل تعاني من ألم في  قدمك ؟     ",
                              style: GoogleFonts.tajawal(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                              textAlign: TextAlign.right),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                "لا",
                                style: GoogleFonts.tajawal(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                // Navigator.pushReplacement(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) => handFoot()));
                                 Navigation.mainNavigation.currentState!.pushNamed("/main/13");
                                  Navigator.of(context).pop();
                              },
                              child: Text(
                                "نعم",
                                style: GoogleFonts.tajawal(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                            ),
                          ]);
                    },
                  );
                } else if (s == "back") {
                  onSelectionUpdated
                      ?.call(bodyParts.withToggledId(s, mirror: mirrored));

                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                          title: Text(" هل تعاني من ألم في  ظهرك ؟     ",
                              style: GoogleFonts.tajawal(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                              textAlign: TextAlign.right),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                "لا",
                                style: GoogleFonts.tajawal(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                // Navigator.pushReplacement(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) => back()));
                                 Navigation.mainNavigation.currentState!.pushNamed("/main/14");
                                  Navigator.of(context).pop();
                              },
                              child: Text(
                                "نعم",
                                style: GoogleFonts.tajawal(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                            ),
                          ]);
                    },
                  );
                }
                //muscle
                /* else if (
                    //s == "leftShoulder" ||
                    // s == "leftUpperArm" ||
                    // s == "rightShoulder" ||
                    // s == "rightLowerArm" ||
                    //   s == "leftLowerArm" ||
                    // s == "leftElbow" ||
                    //   s == "leftUpperLeg" ||
                    // s == "rightUpperArm" ||
                 //   s == "leftLowerLeg" ||
                        //    s == "rightUpperLeg" ||
                      //  s == "rightLowerLeg") {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => (muscle()), //all muscles
                      ));
                }
                else if (s == "leftHand" ||
                    s == "leftFoot" ||
                    s == "rightFoot" ||
                    s == "rightHand") {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => (handFoot()), //hand and foot only
                      ));
                }*/
              },
              context: context,
              selectedColor: selectedColor ?? colorScheme.inversePrimary,
              unselectedColor:
                  unselectedColor ?? Color.fromARGB(255, 155, 155, 155),
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
