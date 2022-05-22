import 'package:flutter/material.dart';

///check [RawScrollbar] props description
class ScrollbarProps {
  final bool? thumbVisibility;
  final bool? trackVisibility;
  final double? thickness;
  final Radius? radius;
  final bool? interactive;
  final ScrollNotificationPredicate notificationPredicate;
  final ScrollbarOrientation? scrollbarOrientation;
  final OutlinedBorder? shape;
  final Color? thumbColor;
  final double minThumbLength;
  final double? minOverscrollLength;
  final Radius? trackRadius;
  final Color? trackColor;
  final Color? trackBorderColor;
  final Duration fadeDuration;
  final Duration timeToFade;
  final Duration pressDuration;
  final double mainAxisMargin;
  final double crossAxisMargin;

  const ScrollbarProps({
    this.shape,
    this.radius,
    this.thickness,
    this.mainAxisMargin = 0.0,
    this.crossAxisMargin = 0.0,
    this.fadeDuration = const Duration(milliseconds: 300),
    this.timeToFade = const Duration(milliseconds: 600),
    this.pressDuration = Duration.zero,
    this.trackBorderColor,
    this.trackColor,
    this.thumbColor,
    this.minThumbLength = 18.0,
    this.minOverscrollLength,
    this.trackRadius,
    this.scrollbarOrientation,
    this.thumbVisibility,
    this.trackVisibility,
    this.interactive,
    this.notificationPredicate = defaultScrollNotificationPredicate,
  });
}

bool defaultScrollNotificationPredicate(ScrollNotification notification) {
  return notification.depth == 0;
}
