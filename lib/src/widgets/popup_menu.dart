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

// Positioning of the menu on the screen.
class _PopupMenuRouteLayout extends SingleChildLayoutDelegate {
  // Rectangle of underlying button, relative to the overlay's dimensions.
  final RelativeRect position;
  final BuildContext context;

  // The padding of unsafe area.
  EdgeInsets padding;

  _PopupMenuRouteLayout(
    this.context,
    this.padding,
    this.position,
  );

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    //keyBoardHeight is height of keyboard if showing
    double keyBoardHeight = MediaQuery.of(context).viewInsets.bottom;
    double safeAreaTop = MediaQuery.of(context).padding.top;
    double safeAreaBottom = MediaQuery.of(context).padding.bottom;
    double safeAreaTotal = safeAreaTop + safeAreaBottom;

    return BoxConstraints.loose(
      Size(
        constraints.minWidth - position.left - position.right,
        constraints.minHeight,
      ),
    ).deflate(
      EdgeInsets.only(top: safeAreaTotal + keyBoardHeight) + padding,
    );
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    //keyBoardHeight is height of keyboard if showing
    double keyBoardHeight = MediaQuery.of(context).viewInsets.bottom;

    double x = position.left;

    // Find the ideal vertical position.
    double y = position.top;
    // check if we are in the bottom
    if (y + childSize.height > size.height - keyBoardHeight) {
      y = size.height - childSize.height - keyBoardHeight;
    } else if (y < 0) {
      y = 8;
    }

    if (x + childSize.width > size.width) {
      x = size.width - childSize.width;
    } else if (x < 0) {
      x = 8;
    }

    return Offset(x, y);
  }

  @override
  bool shouldRelayout(_PopupMenuRouteLayout oldDelegate) {
    return true;
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
  Duration get transitionDuration =>
      menuModeProps.popUpAnimationStyle?.duration ??
      Duration(milliseconds: 300);

  @override
  bool get barrierDismissible => menuModeProps.barrierDismissible;

  @override
  Color? get barrierColor => menuModeProps.barrierColor;

  @override
  String? get barrierLabel => menuModeProps.barrierLabel;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    final PopupMenuThemeData popupMenuTheme = PopupMenuTheme.of(context);
    final menu = Material(
      surfaceTintColor: menuModeProps.surfaceTintColor,
      shape: menuModeProps.shape ?? popupMenuTheme.shape,
      color: menuModeProps.backgroundColor ?? popupMenuTheme.color,
      type: MaterialType.card,
      elevation: menuModeProps.elevation ?? popupMenuTheme.elevation ?? 8.0,
      clipBehavior: menuModeProps.clipBehavior,
      borderRadius: menuModeProps.borderRadius,
      animationDuration: menuModeProps.popUpAnimationStyle?.duration ??
          Duration(milliseconds: 300),
      shadowColor: menuModeProps.shadowColor,
      borderOnForeground: menuModeProps.borderOnForeground,
      child: child,
    );
    final MediaQueryData mediaQuery = MediaQuery.of(context);

    //handle menu margin
    var pos = position;
    if (menuModeProps.margin != null) {
      final margin = menuModeProps.margin!;
      pos = RelativeRect.fromLTRB(
        position.left + margin.left,
        position.top + margin.top,
        position.right + margin.right,
        position.bottom + margin.bottom,
      );
    }

    return CustomSingleChildLayout(
      delegate: _PopupMenuRouteLayout(context, mediaQuery.padding, pos),
      child: capturedThemes.wrap(menu),
    );
  }
}
