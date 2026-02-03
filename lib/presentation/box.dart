part of '../collect.dart';


class Box extends StatelessWidget {
  Box({
    super.key,
    this.alignment,
    this.padding,
    this.color,
    this.decoration,
    this.foregroundDecoration,
    double? width,
    double? height,
    BoxConstraints? constraints,
    this.margin,
    this.transform,
    this.transformAlignment,
    this.child,
    this.clipBehavior = Clip.none,
  }) : assert(margin == null || margin.isNonNegative),
        assert(padding == null || padding.isNonNegative),
        assert(decoration == null || decoration.debugAssertIsValid()),
        assert(constraints == null || constraints.debugAssertIsValid()),
        assert(decoration != null || clipBehavior == Clip.none),
        assert(
        color == null || decoration == null,
        'Cannot provide both a color and a decoration\n'
            'To provide both, use "decoration: BoxDecoration(color: color)".',
        ),
        constraints = (width != null || height != null)
            ? constraints?.tighten(width: width, height: height) ??
            BoxConstraints.tightFor(width: width, height: height)
            : constraints;

  final Widget? child;

  final AlignmentGeometry? alignment;

  final EdgeInsetsGeometry? padding;

  final Colour? color;

  final Decoration? decoration;

  final Decoration? foregroundDecoration;

  final BoxConstraints? constraints;

  final EdgeInsetsGeometry? margin;

  final Matrix4? transform;

  final AlignmentGeometry? transformAlignment;

  final Clip clipBehavior;

  EdgeInsetsGeometry? get _paddingIncludingDecoration {
    return switch ((padding, decoration?.padding)) {
      (null, final EdgeInsetsGeometry? padding) => padding,
      (final EdgeInsetsGeometry? padding, null) => padding,
      (_) => padding!.add(decoration!.padding),
    };
  }

  @override
  Widget build(BuildContext context) {
    Widget? current = child;

    if (child == null && (constraints == null || !constraints!.isTight)) {
      current = LimitedBox(
        maxWidth: 0.0,
        maxHeight: 0.0,
        child: ConstrainedBox(constraints: const BoxConstraints.expand()),
      );
    } else if (alignment != null) {
      current = Align(alignment: alignment!, child: current);
    }

    final EdgeInsetsGeometry? effectivePadding = _paddingIncludingDecoration;
    if (effectivePadding != null) {
      current = Padding(padding: effectivePadding, child: current);
    }

    if (color != null) {
      current = ColoredBox(color: color!.color, child: current);
    }

    if (clipBehavior != Clip.none) {
      assert(decoration != null);
      current = ClipPath(
        clipper: _DecorationClipper(
          textDirection: Directionality.maybeOf(context),
          decoration: decoration!,
        ),
        clipBehavior: clipBehavior,
        child: current,
      );
    }

    if (decoration != null) {
      current = StyledBox(decoration: decoration!, child: current);
    }

    if (foregroundDecoration != null) {
      current = StyledBox(
        decoration: foregroundDecoration!,
        position: DecorationPosition.foreground,
        child: current,
      );
    }

    if (constraints != null) {
      current = ConstrainedBox(constraints: constraints!, child: current);
    }

    if (margin != null) {
      current = Padding(padding: margin!, child: current);
    }

    if (transform != null) {
      current = Transform(
        transform: transform!,
        alignment: transformAlignment,
        child: current,
      );
    }

    return current!;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty<AlignmentGeometry>(
        'alignment',
        alignment,
        showName: false,
        defaultValue: null,
      ),
    );
    properties.add(
      DiagnosticsProperty<EdgeInsetsGeometry>(
        'padding',
        padding,
        defaultValue: null,
      ),
    );
    properties.add(
      DiagnosticsProperty<Clip>(
        'clipBehavior',
        clipBehavior,
        defaultValue: Clip.none,
      ),
    );
    if (color != null) {
      properties.add(DiagnosticsProperty<Colour>('bg', color));
    } else {
      properties.add(
        DiagnosticsProperty<Decoration>('bg', decoration, defaultValue: null),
      );
    }
    properties.add(
      DiagnosticsProperty<Decoration>(
        'fg',
        foregroundDecoration,
        defaultValue: null,
      ),
    );
    properties.add(
      DiagnosticsProperty<BoxConstraints>(
        'constraints',
        constraints,
        defaultValue: null,
      ),
    );
    properties.add(
      DiagnosticsProperty<EdgeInsetsGeometry>(
        'margin',
        margin,
        defaultValue: null,
      ),
    );
    properties.add(ObjectFlagProperty<Matrix4>.has('transform', transform));
  }
}

class StyledBox extends SingleChildRenderObjectWidget {
  const StyledBox({
    super.key,
    required this.decoration,
    this.position = DecorationPosition.background,
    super.child,
  });

  final Decoration decoration;

  final DecorationPosition position;

  @override
  RenderDecoratedBox createRenderObject(BuildContext context) {
    return RenderDecoratedBox(
      decoration: decoration,
      position: position,
      configuration: createLocalImageConfiguration(context),
    );
  }

  @override
  void updateRenderObject(
      BuildContext context,
      RenderDecoratedBox renderObject,
      ) {
    renderObject
      ..decoration = decoration
      ..configuration = createLocalImageConfiguration(context)
      ..position = position;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    final String label = switch (position) {
      DecorationPosition.background => 'bg',
      DecorationPosition.foreground => 'fg',
    };
    properties.add(
      EnumProperty<DecorationPosition>(
        'position',
        position,
        level: DiagnosticLevel.hidden,
      ),
    );
    properties.add(DiagnosticsProperty<Decoration>(label, decoration));
  }
}

class _DecorationClipper extends CustomClipper<Path> {
  _DecorationClipper({TextDirection? textDirection, required this.decoration})
      : textDirection = textDirection ?? TextDirection.ltr;

  final TextDirection textDirection;
  final Decoration decoration;

  @override
  Path getClip(Size size) {
    return decoration.getClipPath(Offset.zero & size, textDirection);
  }

  @override
  bool shouldReclip(_DecorationClipper oldClipper) {
    return oldClipper.decoration != decoration ||
        oldClipper.textDirection != textDirection;
  }
}

/// Use this class to define an inset box shadow that can be used inside the [InsetShadowShapeDecoration] shadows.
final class InsetBoxShadow extends BoxShadow {
  const InsetBoxShadow({
    super.color,
    super.offset,
    super.blurRadius,
    super.spreadRadius = 0.0,
    super.blurStyle = BlurStyle.normal,
  });

  const InsetBoxShadow.dip({
    super.color = Colours.black,
    super.offset = Offset.zero,
    super.blurStyle = BlurStyle.outer,
    super.blurRadius = 8,
    super.spreadRadius = 3,
  });
}

/// A shape decoration that supports inset shadows by adding [InsetBoxShadow] instances to the [shadows] prop.
class InsetShadowShapeDecoration extends ShapeDecoration {
  const InsetShadowShapeDecoration({
    super.shape = const RoundedRectangleBorder(),
    super.color,
    super.image,
    super.gradient,
    super.shadows,
  });

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _ShapeDecorationPainter(this, onChanged ?? () {});
  }
}

/// An object that paints a [InsetShadowShapeDecoration] into a canvas.
class _ShapeDecorationPainter extends BoxPainter {
  _ShapeDecorationPainter(this._decoration, VoidCallback onChanged)
      : super(onChanged);

  final InsetShadowShapeDecoration _decoration;

  Rect? _lastRect;
  TextDirection? _lastTextDirection;
  late Path _outerPath;
  Path? _innerPath;
  Paint? _interiorPaint;
  List<BoxShadow> _shadowsWithoutInset = [];
  List<BoxShadow> _insetShadows = [];
  late List<Rect> _shadowBounds;
  late List<Path> _shadowPaths;
  late List<Paint> _shadowPaints;

  @override
  VoidCallback get onChanged => super.onChanged!;

  void _precache(Rect rect, TextDirection? textDirection) {
    if (rect == _lastRect && textDirection == _lastTextDirection) {
      return;
    }

    // We reach here in two cases:
    //  - the very first time we paint, in which case everything except _decoration is null
    //  - subsequent times, if the rect has changed, in which case we only need to update
    //    the features that depend on the actual rect.
    if (_interiorPaint == null &&
        (_decoration.color != null || _decoration.gradient != null)) {
      _interiorPaint = Paint();
      if (_decoration.color != null) {
        _interiorPaint!.color = _decoration.color!;
      }
    }

    if (_decoration.gradient != null) {
      _interiorPaint!.shader = _decoration.gradient!.createShader(
        rect,
        textDirection: textDirection,
      );
    }

    if (_decoration.shadows != null) {
      _shadowsWithoutInset = [];
      _insetShadows = [];
      for (final shadow in _decoration.shadows!) {
        if (shadow is InsetBoxShadow) {
          _insetShadows.add(shadow);
        } else {
          _shadowsWithoutInset.add(shadow);
        }
      }

      if (_shadowsWithoutInset.isNotEmpty) {
        _shadowPaints = <Paint>[
          ..._shadowsWithoutInset.map((BoxShadow shadow) => shadow.toPaint()),
        ];
      }
      if (_decoration.shape.preferPaintInterior) {
        _shadowBounds = <Rect>[
          ..._shadowsWithoutInset.map((BoxShadow shadow) {
            return rect.shift(shadow.offset).inflate(shadow.spreadRadius);
          }),
        ];
      } else {
        _shadowPaths = <Path>[
          ..._shadowsWithoutInset.map((BoxShadow shadow) {
            return _decoration.shape.getOuterPath(
              rect.shift(shadow.offset).inflate(shadow.spreadRadius),
              textDirection: textDirection,
            );
          }),
        ];
      }
    }

    if (!_decoration.shape.preferPaintInterior &&
        (_interiorPaint != null || _shadowsWithoutInset.isNotEmpty)) {
      _outerPath = _decoration.shape.getOuterPath(
        rect,
        textDirection: textDirection,
      );
    }

    if (_decoration.image != null || _insetShadows.isNotEmpty) {
      _innerPath = _decoration.shape.getInnerPath(
        rect,
        textDirection: textDirection,
      );
    }

    _lastRect = rect;
    _lastTextDirection = textDirection;
  }

  void _paintShadows(Canvas canvas, Rect rect, TextDirection? textDirection) {
    if (_shadowsWithoutInset.isEmpty) {
      return;
    }

    // The debugHandleDisabledShadowStart and debugHandleDisabledShadowEnd
    // methods are used in debug mode only to support BlurStyle.outer when
    // debugDisableShadows is set. Without these clips, the shadows would extend
    // to the inside of the shape, which would likely obscure important
    // portions of the rendering and would cause unit tests of widgets that use
    // BlurStyle.outer to significantly diverge from the original intent.
    // It is assumed that [debugDisableShadows] will not change when calling
    // paintInterior or getOuterPath; if it does, the results are undefined.
    bool debugHandleDisabledShadowStart(
        Canvas canvas,
        BoxShadow boxShadow,
        Path path,
        ) {
      if (debugDisableShadows && boxShadow.blurStyle == BlurStyle.outer) {
        canvas.save();
        final Path clipPath = Path();
        clipPath.fillType = PathFillType.evenOdd;
        clipPath.addRect(Rect.largest);
        clipPath.addPath(path, Offset.zero);
        canvas.clipPath(clipPath);
      }
      return true;
    }

    bool debugHandleDisabledShadowEnd(Canvas canvas, BoxShadow boxShadow) {
      if (debugDisableShadows && boxShadow.blurStyle == BlurStyle.outer) {
        canvas.restore();
      }
      return true;
    }

    if (_decoration.shape.preferPaintInterior) {
      for (int index = 0; index < _shadowsWithoutInset.length; index += 1) {
        assert(
        debugHandleDisabledShadowStart(
          canvas,
          _shadowsWithoutInset[index],
          _decoration.shape.getOuterPath(
            _shadowBounds[index],
            textDirection: textDirection,
          ),
        ),
        );
        _decoration.shape.paintInterior(
          canvas,
          _shadowBounds[index],
          _shadowPaints[index],
          textDirection: textDirection,
        );
        assert(
        debugHandleDisabledShadowEnd(canvas, _shadowsWithoutInset[index]),
        );
      }
    } else {
      for (int index = 0; index < _shadowsWithoutInset.length; index += 1) {
        assert(
        debugHandleDisabledShadowStart(
          canvas,
          _shadowsWithoutInset[index],
          _shadowPaths[index],
        ),
        );
        canvas.drawPath(_shadowPaths[index], _shadowPaints[index]);
        assert(
        debugHandleDisabledShadowEnd(canvas, _shadowsWithoutInset[index]),
        );
      }
    }
  }

  void _paintInterior(Canvas canvas, Rect rect, TextDirection? textDirection) {
    if (_interiorPaint != null) {
      if (_decoration.shape.preferPaintInterior) {
        // When border is filled, the rect is reduced to avoid anti-aliasing
        // rounding error leaking the background color around the clipped shape.
        final Rect adjustedRect = _adjustedRectOnOutlinedBorder(rect);
        _decoration.shape.paintInterior(
          canvas,
          adjustedRect,
          _interiorPaint!,
          textDirection: textDirection,
        );
      } else {
        canvas.drawPath(_outerPath, _interiorPaint!);
      }
    }
  }

  Rect _adjustedRectOnOutlinedBorder(Rect rect) {
    if (_decoration.shape is OutlinedBorder && _decoration.color != null) {
      final BorderSide side = (_decoration.shape as OutlinedBorder).side;
      if (side.color.a == 1 && side.style == BorderStyle.solid) {
        return rect.deflate(side.strokeInset / 2);
      }
    }
    return rect;
  }

  DecorationImagePainter? _imagePainter;

  void _paintImage(Canvas canvas, ImageConfiguration configuration) {
    if (_decoration.image == null) {
      return;
    }
    _imagePainter ??= _decoration.image!.createPainter(onChanged);
    _imagePainter!.paint(canvas, _lastRect!, _innerPath, configuration);
  }

  void _paintInsetShadows(
      Canvas canvas,
      Rect rect,
      TextDirection? textDirection,
      ) {
    if (_insetShadows.isEmpty || _innerPath == null) {
      return;
    }

    for (final shadow in _insetShadows) {
      canvas.save();
      final shadowPaint = shadow.toPaint();
      canvas.clipPath(_innerPath!);

      // Calculate the center of the path bounds
      final center = rect.center;

      // To calculate the inset shadow area we need to take the biggest possible shadow outer bound (includes the spread and blur)
      // and cut-off the inner path transformed by the shadow offset and spread radius.
      final outerBound = rect.inflate(
        shadow.spreadRadius +
            shadow.blurRadius +
            max(shadow.offset.dx.abs(), shadow.offset.dy.abs()),
      );

      // Create a matrix to translate the path to origin for proportional scaling
      final translateToOrigin = Matrix4.identity()
        ..translateByDouble(-center.dx, -center.dy, 0, 1);

      // Scaling down the inner path according to the spread diameter (radius * 2)
      final scaleX = 1 - ((shadow.spreadRadius * 2) / rect.width);
      final scaleY = 1 - ((shadow.spreadRadius * 2) / rect.height);
      final scalingMatrix = Matrix4.identity()
        ..scaleByDouble(scaleX, scaleY, 1, 1);

      // Create a matrix to translate back to original center with applied shadow offset
      final translateX = center.dx + shadow.offset.dx;
      final translateY = center.dy + shadow.offset.dy;
      final translateBack = Matrix4.identity()
        ..translateByDouble(translateX, translateY, 0, 1);

      // Combine the matrices: translate back * scale * translate to origin
      final combinedMatrix = translateBack
          .multiplied(scalingMatrix)
          .multiplied(translateToOrigin);

      final innerPathOfTheInsetShadow = _innerPath!.transform(
        combinedMatrix.storage,
      );

      final path = Path.combine(
        PathOperation.difference,
        Path()..addRect(outerBound),
        innerPathOfTheInsetShadow,
      );

      canvas.drawPath(path, shadowPaint);

      canvas.restore();
    }
  }

  @override
  void dispose() {
    _imagePainter?.dispose();
    super.dispose();
  }

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    assert(configuration.size != null);
    final Rect rect = offset & configuration.size!;
    final TextDirection? textDirection = configuration.textDirection;
    _precache(rect, textDirection);
    _paintShadows(canvas, rect, textDirection);
    _paintInterior(canvas, rect, textDirection);
    _paintImage(canvas, configuration);
    _paintInsetShadows(canvas, rect, textDirection);
    _decoration.shape.paint(canvas, rect, textDirection: textDirection);
  }
}
