import 'package:flutter/material.dart';

import '../../collect.dart';
import 'common.dart';

class Indicator extends StatefulWidget {
  final double size;
  final HSVColour colour;
  final bool displayThumbColour;
  final ValueChanged<HSVColour> onChanged;

  const Indicator({
    super.key,
    required this.colour,
    required this.size,
    required this.displayThumbColour,
    required this.onChanged,
  });

  @override
  State<Indicator> createState() => _IndicatorState();
}

class _IndicatorState extends State<Indicator> {
  @override
  Widget build(BuildContext context) {
    HSVColour currentHSVColour = widget.colour.toHSVColour;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        ColorIndicator(
          currentHSVColour,
          height: widget.size * 0.5,
          width: widget.size * 0.5,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: widget.size * 0.3,
              width: widget.size * 2.4,
              child: ColourPickerSlider(
                TrackType.value,
                currentHSVColour,
                (colour) {
                  widget.onChanged(colour);
                },
                displayThumbColor: widget.displayThumbColour,
              ),
            ),
              SizedBox(
                height: widget.size * 0.3,
                width: widget.size * 2.4,
                child: ColourPickerSlider(
                  TrackType.alpha,
                  currentHSVColour,
                  (colour) {
                    widget.onChanged(colour);
                  },
                  displayThumbColor: widget.displayThumbColour,
                ),
              ),
          ],
        ),
      ],
    );
  }
}
