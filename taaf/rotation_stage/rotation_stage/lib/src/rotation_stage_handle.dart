import 'package:flutter/material.dart';
import 'package:rotation_stage/src/model/rotation_stage_side.dart';
import 'package:rotation_stage/src/rotation_stage_labels.dart';
import 'package:flutter/cupertino.dart';

class RotationStageHandle extends StatelessWidget {
  RotationStageHandle({
    super.key,
    required this.side,
    required this.active,
    required this.onTap,
    required this.backgroundTransparent,
  });

  final RotationStageSide side;
  final bool active;
  final bool backgroundTransparent;
  final VoidCallback onTap;
  final controllerOne = ScrollController();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final labels = RotationStageLabels.of(context);
    final name = labels.getForSide(side);
    return Center(
        child: Icon(
      CupertinoIcons.arrow_left,
      color: Color.fromARGB(255, 11, 1, 63),
      size: 50,
    ));

    /*
        Slider(
            value: 1,
            max: 100,
            divisions: 5,
            onChanged: (double value) {
              print("change");
            }));

  }
}
      */
/*
      child: ChoiceChip(
        //  Icon(Icons.noise_aware_rounded),
        onSelected: (_) => onTap(),
        label: Text(
          name.toUpperCase(),
          style: Theme.of(context).textTheme.button?.copyWith(
                color: active
                    ? colorScheme.onSecondary
                    : colorScheme.onSecondaryContainer,
              ),
        ),
        selected: active,
        disabledColor: Colors.transparent,
        shadowColor:
            backgroundTransparent ? Colors.transparent : colorScheme.shadow,
        selectedShadowColor:
            backgroundTransparent ? Colors.transparent : colorScheme.primary,
        backgroundColor: backgroundTransparent
            ? Colors.transparent
            : colorScheme.primaryContainer,
        selectedColor:
            backgroundTransparent ? Colors.transparent : colorScheme.primary,
      ),
    );
  }
}


*/

    /*Scrollbar(
            showTrackOnHover: true,
            thumbVisibility: true,
            //thickness: 20,
            controller: controllerOne, // Here
            child: ListView(

              scrollDirection: Axis.horizontal,
              controller: controllerOne, // AND Here
            ))

        // This next line does the trick.

        /* children: <Widget>[
          Container(
            width: 160.0,
            color: Colors.red,
          ),
          Container(
            width: 160.0,
            color: Colors.blue,
          ),
          Container(
            width: 160.0,
            color: Colors.green,
          ),
          Container(
            width: 160.0,
            color: Colors.yellow,
          ),
          Container(
            width: 160.0,
            color: Colors.orange,
          ),
        ],*/
        // ),
        //  ),
        // ),
        //);
       
*/
  }
}
