import 'package:flutter/material.dart';

class ScrollbarProps {
  final ScrollController? controller;

  final bool? isAlwaysShown;

  final bool? showTrackOnHover;

  final double? hoverThickness;

  final double? thickness;

  final Radius? radius;

  final bool? interactive;

  final ScrollNotificationPredicate? notificationPredicate;

  ScrollbarProps({
    this.controller,
    this.isAlwaysShown,
    this.showTrackOnHover,
    this.hoverThickness,
    this.thickness,
    this.radius,
    this.interactive,
    this.notificationPredicate,
  });
}
