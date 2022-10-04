import 'package:flutter/material.dart';

class BottomSheetProps {
  final ShapeBorder? shape;
  final BoxConstraints? constraints;
  final Color? backgroundColor;
  final Clip clipBehavior;
  final AnimationController? animation;
  final bool enableDrag;
  final double? elevation;

  const BottomSheetProps({
    this.elevation,
    this.shape,
    this.backgroundColor,
    this.animation,
    this.enableDrag = true,
    this.clipBehavior = Clip.none,
    this.constraints,
  });
}
