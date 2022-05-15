import 'package:flutter/material.dart';

class ScrollbarProps {
  final bool? thumbVisibility;
  final bool? trackVisibility;
  final double? thickness;
  final Radius? radius;
  final bool? interactive;
  final ScrollNotificationPredicate? notificationPredicate;
  final ScrollbarOrientation? scrollbarOrientation;

  const ScrollbarProps({
    this.scrollbarOrientation,
    this.thumbVisibility,
    this.trackVisibility,
    this.thickness,
    this.radius,
    this.interactive,
    this.notificationPredicate,
  });
}
