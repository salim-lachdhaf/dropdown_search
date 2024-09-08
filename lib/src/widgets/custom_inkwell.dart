import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

Widget customInkWell(ClickProps clickProps, GestureTapCallback? onTap, Widget child) {
  return InkWell(
    autofocus: clickProps.autofocus,
    borderRadius: clickProps.borderRadius,
    customBorder: clickProps.customBorder,
    enableFeedback: clickProps.enableFeedback,
    focusColor: clickProps.focusColor,
    excludeFromSemantics: clickProps.excludeFromSemantics,
    hoverColor: clickProps.hoverColor,
    mouseCursor: clickProps.mouseCursor,
    onHover: clickProps.onHover,
    onDoubleTap: clickProps.onDoubleTap,
    onHighlightChanged: clickProps.onHighlightChanged,
    onLongPress: clickProps.onLongPress,
    onSecondaryTap: clickProps.onSecondaryTap,
    onSecondaryTapCancel: clickProps.onSecondaryTapCancel,
    onSecondaryTapUp: clickProps.onSecondaryTapUp,
    onSecondaryTapDown: clickProps.onSecondaryTapDown,
    onTapCancel: clickProps.onTapCancel,
    onTapDown: clickProps.onTapDown,
    onTapUp: clickProps.onTapUp,
    overlayColor: clickProps.overlayColor,
    radius: clickProps.radius,
    splashColor: clickProps.splashColor,
    splashFactory: clickProps.splashFactory,
    statesController: clickProps.statesController,
    hoverDuration: clickProps.hoverDuration,
    canRequestFocus: clickProps.canRequestFocus,
    highlightColor: clickProps.highlightColor,
    onFocusChange: clickProps.onFocusChange,
    onTap: onTap,
    child: child,
  );
}
