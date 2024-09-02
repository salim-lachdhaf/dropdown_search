import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

class DropdownButtonProps extends IconButtonProps {
  final Widget iconOpened;

  const DropdownButtonProps({
    this.iconOpened = const Icon(Icons.arrow_drop_up, size: 24),
    Widget iconClosed = const Icon(Icons.arrow_drop_down, size: 24),
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
    super.onPressed,
  }) : super(icon: iconClosed);
}

class ClickProps extends InkWell {
  const ClickProps({
    super.borderRadius,
    super.customBorder,
    super.enableFeedback,
    super.excludeFromSemantics,
    super.splashFactory,
    super.autofocus,
    super.canRequestFocus,
    super.focusColor,
    super.highlightColor,
    super.hoverColor,
    super.hoverDuration,
    super.mouseCursor,
    super.onDoubleTap,
    super.onHover,
    super.onSecondaryTap,
    super.onLongPress,
    super.onSecondaryTapCancel,
    super.onSecondaryTapDown,
    super.onSecondaryTapUp,
    super.overlayColor,
    super.radius,
    super.splashColor,
    super.onHighlightChanged,
    super.onTapCancel,
    super.onTapUp,
    super.onTapDown,
  });
}

class DropDownDecoratorProps {
  final InputDecoration? dropdownSearchDecoration;
  final TextStyle? baseStyle;
  final TextAlign? textAlign;
  final TextAlignVertical? textAlignVertical;
  final bool expands;
  final bool isHovering;

  const DropDownDecoratorProps({
    this.dropdownSearchDecoration,
    this.baseStyle,
    this.textAlign,
    this.textAlignVertical,
    this.expands = false,
    this.isHovering = false,
  });
}