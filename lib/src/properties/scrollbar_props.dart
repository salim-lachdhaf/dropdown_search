import 'package:flutter/material.dart';

class ScrollbarProps {
  final ScrollController? controller;
  final bool? thumbVisibility;
  final bool? trackVisibility;
  final double? thickness;
  final Radius? radius;
  final bool? interactive;
  final ScrollNotificationPredicate? notificationPredicate;

  const ScrollbarProps({
    this.controller,
    this.thumbVisibility,
    this.trackVisibility,
    this.thickness,
    this.radius,
    this.interactive,
    this.notificationPredicate,
  });
}
