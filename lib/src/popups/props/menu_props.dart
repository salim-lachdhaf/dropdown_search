import 'package:dropdown_search/src/base_dropdown_search.dart';
import 'package:material_ui/material_ui.dart';

enum MenuAlign {
  bottomStart,
  bottomCenter,
  bottomEnd,
  topStart,
  topCenter,
  topEnd,
}

extension MenuAlignDirection on MenuAlign {
  bool get isDown =>
      this == MenuAlign.bottomStart ||
      this == MenuAlign.bottomCenter ||
      this == MenuAlign.bottomEnd;

  bool get isUp => !isDown;

  MenuAlign get reverse {
    switch (this) {
      case MenuAlign.topStart:
        return MenuAlign.bottomStart;
      case MenuAlign.topCenter:
        return MenuAlign.bottomCenter;
      case MenuAlign.topEnd:
        return MenuAlign.bottomEnd;
      case MenuAlign.bottomStart:
        return MenuAlign.topStart;
      case MenuAlign.bottomCenter:
        return MenuAlign.topCenter;
      case MenuAlign.bottomEnd:
        return MenuAlign.topEnd;
    }
  }
}

class MenuProps {
  final MenuAlign? align;
  final ShapeBorder? shape;
  final double? elevation;
  final Color? barrierColor;
  final Color? backgroundColor;
  final bool barrierDismissible;
  final Clip clipBehavior;
  final BorderRadiusGeometry? borderRadius;
  final Color? shadowColor;
  final bool borderOnForeground;
  final String? barrierLabel;
  final PositionCallback? positionCallback;
  final Duration? reverseTransitionDuration;
  final Duration? transitionDuration;
  final Color? color;
  final String? semanticLabel;
  final Color? surfaceTintColor;
  final EdgeInsets? margin;
  final RouteTransitionsBuilder? transitionBuilder;

  /// This property is exposed in order to give low level access to the
  /// positioning algorithm of the menu popup
  /// The delegate can determine the layout constraints for the child and can
  /// decide where to position the child.
  /// extend [`SingleChildLayoutDelegate`](https://api.flutter.dev/flutter/rendering/SingleChildLayoutDelegate-class.html)
  //  to create your own positioning strategy
  final SingleChildLayoutDelegate Function(
    BuildContext context,
    RelativeRect position,
  )? layoutDelegate;

  const MenuProps({
    this.align,
    this.barrierLabel,
    this.elevation,
    this.shape = const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(4.0))),
    this.positionCallback,
    this.barrierColor,
    this.backgroundColor,
    this.barrierDismissible = true,
    this.clipBehavior = Clip.none,
    this.borderOnForeground = false,
    this.borderRadius,
    this.shadowColor,
    this.color,
    this.transitionDuration,
    this.reverseTransitionDuration,
    this.semanticLabel,
    this.surfaceTintColor,
    this.margin,
    this.transitionBuilder,
    this.layoutDelegate,
  });
}

class CupertinoMenuProps {
  final MenuAlign? align;
  final ShapeBorder? shape;
  final double? elevation;
  final Color? barrierColor;
  final Color? backgroundColor;
  final bool barrierDismissible;
  final Clip clipBehavior;
  final BorderRadiusGeometry? borderRadius;
  final Color? shadowColor;
  final bool borderOnForeground;
  final String? barrierLabel;
  final PositionCallback? positionCallback;
  final Duration? reverseTransitionDuration;
  final Duration? transitionDuration;
  final Color? color;
  final String? semanticLabel;
  final Color? surfaceTintColor;
  final EdgeInsets? margin;
  final RouteTransitionsBuilder? transitionBuilder;

  /// This property is exposed in order to give low level access to the
  /// positioning algorithm of the menu popup
  /// The delegate can determine the layout constraints for the child and can
  /// decide where to position the child.
  /// extend [`SingleChildLayoutDelegate`](https://api.flutter.dev/flutter/rendering/SingleChildLayoutDelegate-class.html)
  //  to create your own positioning strategy
  final SingleChildLayoutDelegate Function(
    BuildContext context,
    RelativeRect position,
  )? layoutDelegate;

  const CupertinoMenuProps({
    this.align,
    this.barrierLabel,
    this.elevation,
    this.shape = const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12))),
    this.positionCallback,
    this.barrierColor,
    this.backgroundColor,
    this.barrierDismissible = true,
    this.clipBehavior = Clip.none,
    this.borderOnForeground = false,
    this.borderRadius,
    this.shadowColor,
    this.color,
    this.transitionDuration,
    this.reverseTransitionDuration,
    this.semanticLabel,
    this.surfaceTintColor,
    this.margin = const EdgeInsets.only(top: 8),
    this.transitionBuilder,
    this.layoutDelegate,
  });
}

class AdaptiveMenuProps {
  final CupertinoMenuProps cupertinoProps;
  final MenuProps materialProps;

  const AdaptiveMenuProps({
    this.materialProps = const MenuProps(),
    this.cupertinoProps = const CupertinoMenuProps(),
  });
}
