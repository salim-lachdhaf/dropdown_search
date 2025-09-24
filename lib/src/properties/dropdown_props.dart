import 'package:dropdown_search/dropdown_search.dart';
import 'package:dropdown_search/src/widgets/props/icon_button_props.dart';
import 'package:flutter/material.dart';

typedef DropdownButtonAnimationBuilder = Widget Function(Widget child, bool isOpen);

Widget defaultAnimationBuilder(child, isOpen) {
  return AnimatedRotation(
    turns: isOpen ? .5 : 1,
    duration: Duration(milliseconds: 300),
    child: child,
  );
}

class DropdownButtonProps extends IconButtonProps {
  final Widget? iconOpened;
  final DropdownButtonAnimationBuilder animationBuilder;

  const DropdownButtonProps({
    this.iconOpened,
    Widget? iconClosed,
    this.animationBuilder = defaultAnimationBuilder,
    super.isVisible = true,
    super.iconSize,
    super.visualDensity,
    super.padding,
    super.alignment,
    super.splashRadius,
    super.color,
    super.focusColor,
    super.hoverColor,
    super.highlightColor,
    super.splashColor,
    super.disabledColor,
    super.mouseCursor,
    super.focusNode,
    super.autofocus,
    super.tooltip,
    super.enableFeedback,
    super.constraints,
    super.style,
    super.isSelected,
    super.selectedIcon,
    super.onHover,
  }) : super(icon: iconClosed);
}

class DropDownDecoratorProps {
  final InputDecoration? decoration;
  final TextStyle? baseStyle;
  final TextAlign? textAlign;
  final TextAlignVertical? textAlignVertical;
  final bool expands;
  final bool? isHovering;

  const DropDownDecoratorProps({
    this.decoration,
    this.baseStyle,
    this.textAlign,
    this.textAlignVertical,
    this.expands = false,
    this.isHovering,
  });
}
