
import 'package:flutter/material.dart';

import '../../collect.dart';
import 'common.dart';

class Indicator extends StatefulWidget {
  final double size;
  final HSVColour colour;
  final bool displayThumbColour;
  final bool alphaEnabled;
  final ValueChanged<HSVColour> onChanged;

  const Indicator({
    super.key,
    required this.colour,
    required this.size,
    required this.displayThumbColour,
    required this.alphaEnabled,
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
      children: <Widget>[
        ColorIndicator(currentHSVColour),
        Column(
          children: <Widget>[
            SizedBox(
              height: widget.size * 0.3,
              width: widget.size * 2,
              child: ColourPickerSlider(
                TrackType.value,
                currentHSVColour,
                    (colour) {
                  widget.onChanged(colour);
                },
                displayThumbColor: widget.displayThumbColour,
              ),
            ),
            if (widget.alphaEnabled)
              SizedBox(
                height: widget.size * 0.3,
                width: widget.size * 2,
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
