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

  _PopupMenuRouteLayout(
    this.context,
    this.position,
  );

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    final parentRenderBox = context.findRenderObject() as RenderBox;
    //keyBoardHeight is height of keyboard if showing
    double keyBoardHeight = MediaQuery.of(context).viewInsets.bottom;
    double safeAreaTop = MediaQuery.of(context).padding.top;
    double safeAreaBottom = MediaQuery.of(context).padding.bottom;
    double totalSafeArea = safeAreaTop + safeAreaBottom;
    double maxHeight = constraints.minHeight - keyBoardHeight - totalSafeArea;
    return BoxConstraints.loose(
      Size(
        parentRenderBox.size.width - position.right - position.left,
        maxHeight,
      ),
    );
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    // size: The size of the overlay.
    // childSize: The size of the menu, when fully open, as determined by
    // getConstraintsForChild.

    //keyBoardHeight is height of keyboard if showing
    double keyBoardHeight = MediaQuery.of(context).viewInsets.bottom;

    double x = position.left;

    // Find the ideal vertical position.
    double y = position.top;
    // check if we are in the bottom
    if (y + childSize.height > size.height - keyBoardHeight) {
      y = size.height - childSize.height - keyBoardHeight;
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
  Duration get transitionDuration => menuModeProps.animationDuration;

  @override
  bool get barrierDismissible => menuModeProps.barrierDismissible;

  @override
  Color? get barrierColor => menuModeProps.barrierColor;

  @override
  String? get barrierLabel => menuModeProps.barrierLabel;

  @override
  Animation<double>? get animation => menuModeProps.animation ?? super.animation;

  @override
  Curve get barrierCurve => menuModeProps.barrierCurve ?? super.barrierCurve;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    final PopupMenuThemeData popupMenuTheme = PopupMenuTheme.of(context);
    final menu = Material(
      shape: menuModeProps.shape ?? popupMenuTheme.shape,
      color: menuModeProps.backgroundColor ?? popupMenuTheme.color,
      type: MaterialType.card,
      elevation: menuModeProps.elevation ?? popupMenuTheme.elevation ?? 8.0,
      clipBehavior: menuModeProps.clipBehavior,
      borderRadius: menuModeProps.borderRadius,
      animationDuration: menuModeProps.animationDuration,
      shadowColor: menuModeProps.shadowColor,
      borderOnForeground: menuModeProps.borderOnForeground,
      child: child,
    );

    return CustomSingleChildLayout(
      delegate: _PopupMenuRouteLayout(context, position),
      child: capturedThemes.wrap(menu),
    );
  }
}
