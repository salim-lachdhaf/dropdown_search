import 'package:flutter/material.dart';

class DropDownDecoratorProps {
  final InputDecoration? dropdownSearchDecoration;
  final TextStyle? baseStyle;
  final TextAlign? textAlign;
  final TextAlignVertical? textAlignVertical;

  /// Defaults to the value of [ThemeData.splashColor] or the nearest [Theme].
  final Color? searchSplashColor;

  /// Defaults to the value of [ThemeData.highlightColor] or the nearest [Theme].
  final Color? searchHighlightColor;

  /// Defaults to the value of [ThemeData.hoverColor] or the nearest [Theme].
  final Color? searchHoverColor;

  /// Defaults to the value of [ThemeData.focusColor] or the nearest [Theme].
  final Color? searchFocusColor;

  final bool autofocus;

  final bool canRequestFocus;

  final FocusNode? focusNode;

  const DropDownDecoratorProps({
    this.dropdownSearchDecoration,
    this.baseStyle,
    this.textAlign,
    this.textAlignVertical,
    this.searchSplashColor,
    this.searchHighlightColor,
    this.searchHoverColor,
    this.searchFocusColor,
    this.autofocus = false,
    this.canRequestFocus = true,
    this.focusNode,
  });
}
