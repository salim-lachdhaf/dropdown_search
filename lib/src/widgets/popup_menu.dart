import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../properties/menu_props.dart';

Future<T?> showCustomMenu<T>({
  required BuildContext context,
  required MenuProps menuModeProps,
  required RelativeRect position,
  required Widget child,
}) {
  final NavigatorState navigator = Navigator.of(context);
  return navigator.push(
    _PopupMenuRoute<T>(
      context: context,
      position: position,
      child: child,
      menuModeProps: menuModeProps,
      capturedThemes: InheritedTheme.capture(
        from: context,
        to: navigator.context,
      ),
    ),
  );
}
const double _kMenuScreenPadding = 8.0;
// Positioning of the menu on the screen.
class _PopupMenuRouteLayout extends SingleChildLayoutDelegate {
  // Rectangle of underlying button, relative to the overlay's dimensions.
  final RelativeRect position;
  final BuildContext context;
  // The padding of unsafe area.
  EdgeInsets padding;
  // List of rectangles that we should avoid overlapping. Unusable screen area.
  final Set<Rect> avoidBounds;

  _PopupMenuRouteLayout(
    this.context,
      this.padding,
      this.position,
      this.avoidBounds,
      );

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    // The menu can be at most the size of the overlay minus 8.0 pixels in each
    // direction.
    return BoxConstraints.loose(constraints.biggest).deflate(
      const EdgeInsets.all(_kMenuScreenPadding) + padding,
    );
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    final double y = position.top;

    // Find the ideal horizontal position.
    // size: The size of the overlay.
    // childSize: The size of the menu, when fully open, as determined by
    // getConstraintsForChild.
    double x;
    if (position.left > position.right) {
      // Menu button is closer to the right edge, so grow to the left, aligned to the right edge.
      x = size.width - position.right ;//- childSize.width;
    } else if (position.left < position.right) {
      // Menu button is closer to the left edge, so grow to the right, aligned to the left edge.
      x = position.left;
    } else {
      // Menu button is equidistant from both edges, so grow in reading direction.
      x = position.left;
    }
    final Offset wantedPosition = Offset(x, y);
    final Offset originCenter = position.toRect(Offset.zero & size).center;
    final Iterable<Rect> subScreens = DisplayFeatureSubScreen.subScreensInBounds(Offset.zero & size, avoidBounds);
    final Rect subScreen = _closestScreen(subScreens, originCenter);
    return _fitInsideScreen(subScreen, childSize, wantedPosition);
  }

  Rect _closestScreen(Iterable<Rect> screens, Offset point) {
    Rect closest = screens.first;
    for (final Rect screen in screens) {
      if ((screen.center - point).distance < (closest.center - point).distance) {
        closest = screen;
      }
    }
    return closest;
  }

  Offset _fitInsideScreen(Rect screen, Size childSize, Offset wantedPosition){
    double x = wantedPosition.dx;
    double y = wantedPosition.dy;
    // Avoid going outside an area defined as the rectangle 8.0 pixels from the
    // edge of the screen in every direction.
    if (x < screen.left + _kMenuScreenPadding + padding.left) {
      x = screen.left + _kMenuScreenPadding + padding.left;
    } else if (x + childSize.width > screen.right - _kMenuScreenPadding - padding.right) {
      x = screen.right - childSize.width - _kMenuScreenPadding - padding.right;
    }
    if (y < screen.top + _kMenuScreenPadding + padding.top) {
      y = _kMenuScreenPadding + padding.top;
    } else if (y + childSize.height > screen.bottom - _kMenuScreenPadding - padding.bottom) {
      y = screen.bottom - childSize.height - _kMenuScreenPadding - padding.bottom;
    }

    return Offset(x,y);
  }

  @override
  bool shouldRelayout(_PopupMenuRouteLayout oldDelegate) {
    return position != oldDelegate.position
        || padding != oldDelegate.padding
        || !setEquals(avoidBounds, oldDelegate.avoidBounds);
  }
}

class _PopupMenuRoute<T> extends PopupRoute<T> {
  final MenuProps menuModeProps;
  final BuildContext context;
  final RelativeRect position;
  final Widget child;
  final CapturedThemes capturedThemes;

  _PopupMenuRoute({
    required this.context,
    required this.menuModeProps,
    required this.position,
    required this.capturedThemes,
    required this.child,
  });

  @override
  Duration get transitionDuration => menuModeProps.popUpAnimationStyle?.duration ?? Duration(milliseconds: 300);

  @override
  bool get barrierDismissible => menuModeProps.barrierDismissible;

  @override
  Color? get barrierColor => menuModeProps.barrierColor;

  @override
  String? get barrierLabel => menuModeProps.barrierLabel;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    final PopupMenuThemeData popupMenuTheme = PopupMenuTheme.of(context);
    final menu = Material(
      surfaceTintColor: menuModeProps.surfaceTintColor,
      shape: menuModeProps.shape ?? popupMenuTheme.shape,
      color: menuModeProps.backgroundColor ?? popupMenuTheme.color,
      type: MaterialType.card,
      elevation: menuModeProps.elevation ?? popupMenuTheme.elevation ?? 8.0,
      clipBehavior: menuModeProps.clipBehavior,
      borderRadius: menuModeProps.borderRadius,
      animationDuration:menuModeProps.popUpAnimationStyle?.duration ?? Duration(milliseconds: 300),
      shadowColor: menuModeProps.shadowColor,
      borderOnForeground: menuModeProps.borderOnForeground,
      child: child,
    );
    final MediaQueryData mediaQuery = MediaQuery.of(context);

    return CustomSingleChildLayout(
      delegate: _PopupMenuRouteLayout(context, mediaQuery.padding, position ,_avoidBounds(mediaQuery)),
      child: capturedThemes.wrap(menu),
    );
  }

  Set<Rect> _avoidBounds(MediaQueryData mediaQuery) {
    return DisplayFeatureSubScreen.avoidBounds(mediaQuery).toSet();
  }
}
