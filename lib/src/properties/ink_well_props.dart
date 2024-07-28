import 'package:flutter/material.dart';

class InkWellProps {
  final BoxShape? highlightShape;
  final double? radius;
  final BorderRadius? borderRadius;
  final ShapeBorder? customBorder;
  final Color? focusColor;
  final Color? hoverColor;
  final Color? highlightColor;
  final WidgetStateProperty<Color?>? overlayColor;
  final Color? splashColor;
  final InteractiveInkFeatureFactory? splashFactory;
  final bool? enableFeedback;
  final bool excludeFromSemantics;
  final bool autofocus;
  final bool canRequestFocus;
  final Duration? hoverDuration;

  const InkWellProps({
    this.highlightShape,
    this.radius,
    this.borderRadius,
    this.customBorder,
    this.focusColor,
    this.hoverColor,
    this.highlightColor,
    this.overlayColor,
    this.splashColor,
    this.splashFactory,
    this.enableFeedback,
    this.excludeFromSemantics = false,
    this.canRequestFocus = true,
    this.autofocus = false,
    this.hoverDuration,
  });

  InkWellProps copyWith({
    BoxShape? highlightShape,
    double? radius,
    BorderRadius? borderRadius,
    ShapeBorder? customBorder,
    Color? focusColor,
    Color? hoverColor,
    Color? highlightColor,
    WidgetStateProperty<Color?>? overlayColor,
    Color? splashColor,
    InteractiveInkFeatureFactory? splashFactory,
    bool? enableFeedback,
    bool? excludeFromSemantics,
    bool? autofocus,
    bool? canRequestFocus,
    Duration? hoverDuration,
  }) {
    return InkWellProps(
      highlightShape: highlightShape ?? this.highlightShape,
      radius: radius ?? this.radius,
      borderRadius: borderRadius ?? this.borderRadius,
      customBorder: customBorder ?? this.customBorder,
      focusColor: focusColor ?? this.focusColor,
      hoverColor: hoverColor ?? this.hoverColor,
      highlightColor: highlightColor ?? this.highlightColor,
      overlayColor: overlayColor ?? this.overlayColor,
      splashColor: splashColor ?? this.splashColor,
      splashFactory: splashFactory ?? this.splashFactory,
      enableFeedback: enableFeedback ?? this.enableFeedback,
      excludeFromSemantics: excludeFromSemantics ?? this.excludeFromSemantics,
      canRequestFocus: canRequestFocus ?? this.canRequestFocus,
      autofocus: autofocus ?? this.autofocus,
      hoverDuration: hoverDuration ?? this.hoverDuration,
    );
  }

  InkWellProps applyDefaults(InkWellProps defaults) {
    return copyWith(
      highlightShape: this.highlightShape ?? defaults.highlightShape,
      radius: this.radius ?? defaults.radius,
      borderRadius: this.borderRadius ?? defaults.borderRadius,
      customBorder: this.customBorder ?? defaults.customBorder,
      focusColor: this.focusColor ?? defaults.focusColor,
      hoverColor: this.hoverColor ?? defaults.hoverColor,
      highlightColor: this.highlightColor ?? defaults.highlightColor,
      overlayColor: this.overlayColor ?? defaults.overlayColor,
      splashColor: this.splashColor ?? defaults.splashColor,
      splashFactory: this.splashFactory ?? defaults.splashFactory,
      enableFeedback: this.enableFeedback ?? defaults.enableFeedback,
      excludeFromSemantics: this.excludeFromSemantics,
      canRequestFocus: this.canRequestFocus,
      autofocus: this.autofocus,
      hoverDuration: this.hoverDuration ?? defaults.hoverDuration,
    );
  }
}

const defautlInkWellProps = InkWellProps(
  focusColor: Colors.transparent,
  hoverColor: Colors.transparent,
  highlightColor: Colors.transparent,
  overlayColor: WidgetStatePropertyAll(Colors.transparent),
  splashColor: Colors.transparent,
  enableFeedback: true,
  excludeFromSemantics: true,
  canRequestFocus: false,
);
