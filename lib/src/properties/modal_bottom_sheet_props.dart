import 'package:flutter/material.dart';

class ModalBottomSheetProps {
  final ShapeBorder? shape;
  final bool useRootNavigator;
  final BoxConstraints? constraints;
  final double? elevation;
  final Color? barrierColor;
  final Color? backgroundColor;
  final bool barrierDismissible;
  final Clip clipBehavior;
  final AnimationController? animation;
  final bool enableDrag;
  final Offset? anchorPoint;
  final bool isScrollControlled;
  final EdgeInsets? padding; 

  const ModalBottomSheetProps({
    this.anchorPoint,
    this.elevation,
    this.shape,
    this.barrierColor,
    this.backgroundColor,
    this.barrierDismissible = true,
    this.animation,
    this.enableDrag = true,
    this.clipBehavior = Clip.none,
    this.useRootNavigator = false,
    this.constraints,
    this.isScrollControlled = true,
    this.padding
  });
}
