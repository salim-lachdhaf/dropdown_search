import 'package:flutter/material.dart';

///see [IconButton] props for more details
class IconButtonProps {
  final double iconSize;
  final VisualDensity? visualDensity;
  final EdgeInsetsGeometry padding;
  final AlignmentGeometry alignment;
  final double? splashRadius;
  final Widget? icon;
  final Color? focusColor;
  final Color? hoverColor;
  final Color? color;
  final Color? splashColor;
  final Color? highlightColor;
  final Color? disabledColor;
  final MouseCursor mouseCursor;
  final FocusNode? focusNode;
  final bool autofocus;
  final String? tooltip;
  final bool enableFeedback;
  final BoxConstraints? constraints;
  final bool isVisible;
  final ButtonStyle? style;
  final bool? isSelected;
  final Widget? selectedIcon;
  final ValueChanged<bool>? onHover;

  const IconButtonProps({
    this.icon,
    this.isVisible = false,
    this.iconSize = 24.0,
    this.visualDensity,
    this.padding = const EdgeInsets.all(8.0),
    this.alignment = Alignment.center,
    this.splashRadius,
    this.color,
    this.focusColor,
    this.hoverColor,
    this.highlightColor,
    this.splashColor,
    this.disabledColor,
    this.mouseCursor = SystemMouseCursors.click,
    this.focusNode,
    this.autofocus = false,
    this.tooltip,
    this.enableFeedback = false,
    this.constraints,
    this.style,
    this.isSelected,
    this.selectedIcon,
    this.onHover,
  }) : assert(splashRadius == null || splashRadius > 0);
}
