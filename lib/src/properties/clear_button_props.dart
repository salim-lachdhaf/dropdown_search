import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

class ClearButtonProps extends IconButtonProps {
  const ClearButtonProps({
    super.icon = const Icon(Icons.clear, size: 24),
    super.isVisible = false,
    super.iconSize = 24.0,
    super.visualDensity,
    super.padding = const EdgeInsets.all(8.0),
    super.alignment = Alignment.center,
    super.splashRadius,
    super.color,
    super.focusColor,
    super.hoverColor,
    super.highlightColor,
    super.splashColor,
    super.disabledColor,
    super.mouseCursor = SystemMouseCursors.click,
    super.focusNode,
    super.autofocus = false,
    super.tooltip,
    super.enableFeedback = false,
    super.constraints,
  });
}
