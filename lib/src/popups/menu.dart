import 'package:dropdown_search/dropdown_search.dart';
import 'package:dropdown_search/src/utils.dart';
import 'package:flutter/material.dart';

abstract class CustomMenu<T> {
  final BuildContext context;

  CustomMenu({required this.context});

  Future<T?> openMenu() => Navigator.of(context).push(getRoute());

  Route<T> getRoute();

  static RelativeRect getMenuPosition(
    BuildContext context, // /!\ should be dropdownSearch context !
    PositionCallback? positionCallBack,
    MenuAlign? align,
    BoxConstraints constraints,
    EdgeInsets? margin,
  ) {
    //handle menu margin
    // Here we get the render object of our physical button, later to get its size & position
    final dropdownBox = context.findRenderObject() as RenderBox;
    // Get the render object of the overlay used in `Navigator` / `MaterialApp`, i.e. screen size reference
    var overlayBox =
        Overlay.of(context).context.findRenderObject() as RenderBox;

    if (positionCallBack != null) {
      return positionCallBack(dropdownBox, overlayBox).addMargin(margin);
    } else {
      var popupSize = computePopupSize(dropdownBox, overlayBox, constraints);
      return getPosition(dropdownBox, overlayBox, popupSize, align)
          .addMargin(margin);
    }
  }
}

class MaterialCustomMenu<T> extends CustomMenu<T> {
  final MenuProps props;
  final Widget child;
  final BoxConstraints constraints;

  MaterialCustomMenu(
      {required super.context,
      required this.props,
      required this.constraints,
      required this.child});

  @override
  Route<T> getRoute() {
    return _MaterialPopupMenuRoute<T>(
      parentContext: context,
      constraints: constraints,
      child: child,
      menuProps: props,
    );
  }
}

class CupertinoCustomMenu<T> extends CustomMenu<T> {
  final CupertinoMenuProps props;
  final Widget child;
  final BoxConstraints constraints;

  CupertinoCustomMenu(
      {required super.context,
      required this.constraints,
      required this.props,
      required this.child});

  @override
  Route<T> getRoute() {
    return _CupertinoPopupMenuRoute<T>(
      constraints: constraints,
      parentContext: context,
      child: child,
      menuProps: props,
    );
  }
}

class _MaterialPopupMenuRoute<T> extends PopupRoute<T> {
  final MenuProps menuProps; //for now menu props are the same for all uiModes
  final Widget child;
  final BoxConstraints constraints;
  final BuildContext parentContext;

  _MaterialPopupMenuRoute({
    required this.parentContext,
    required this.constraints,
    required this.menuProps,
    required this.child,
  });

  @override
  Duration get transitionDuration =>
      menuProps.transitionDuration ?? Duration.zero;

  @override
  Duration get reverseTransitionDuration =>
      menuProps.reverseTransitionDuration ?? Duration.zero;

  @override
  bool get barrierDismissible => menuProps.barrierDismissible;

  @override
  Color? get barrierColor => menuProps.barrierColor;

  @override
  String? get barrierLabel => menuProps.barrierLabel;

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    if (menuProps.transitionBuilder != null) {
      return menuProps.transitionBuilder!(
          context, animation, secondaryAnimation, child);
    }
    return super
        .buildTransitions(context, animation, secondaryAnimation, child);
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    final PopupMenuThemeData popupMenuTheme = PopupMenuTheme.of(context);
    final menu = Material(
      surfaceTintColor: menuProps.surfaceTintColor,
      shape: menuProps.shape ?? popupMenuTheme.shape,
      color: menuProps.backgroundColor ?? popupMenuTheme.color,
      type: MaterialType.card,
      elevation: menuProps.elevation ?? popupMenuTheme.elevation ?? 2.0,
      clipBehavior: menuProps.clipBehavior,
      borderRadius: menuProps.borderRadius,
      shadowColor: menuProps.shadowColor,
      borderOnForeground: menuProps.borderOnForeground,
      child: child,
    );

    try {
      final position = CustomMenu.getMenuPosition(
        parentContext,
        menuProps.positionCallback,
        menuProps.align,
        constraints,
        menuProps.margin,
      );

      return CustomSingleChildLayout(
        delegate: menuProps.layoutDelegate?.call(
              context,
              position,
            ) ??
            _PopupMenuRouteLayout(context, position),
        child: InheritedTheme.capture(
                from: context, to: Navigator.of(context).context)
            .wrap(menu),
      );
    } catch (e) {
      navigator?.removeRoute(this);
      return SizedBox.shrink();
    }
  }
}

class _CupertinoPopupMenuRoute<T> extends PopupRoute<T> {
  final CupertinoMenuProps menuProps;
  final Widget child;
  final BoxConstraints constraints;
  final BuildContext parentContext;

  _CupertinoPopupMenuRoute({
    required this.menuProps,
    required this.constraints,
    required this.child,
    required this.parentContext,
  });

  @override
  Duration get transitionDuration =>
      menuProps.transitionDuration ?? Duration.zero;

  @override
  Duration get reverseTransitionDuration =>
      menuProps.reverseTransitionDuration ?? Duration.zero;

  @override
  bool get barrierDismissible => menuProps.barrierDismissible;

  @override
  Color? get barrierColor => menuProps.barrierColor;

  @override
  String? get barrierLabel => menuProps.barrierLabel;

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    if (menuProps.transitionBuilder != null) {
      return menuProps.transitionBuilder!(
          context, animation, secondaryAnimation, child);
    }
    return super
        .buildTransitions(context, animation, secondaryAnimation, child);
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    final PopupMenuThemeData popupMenuTheme = PopupMenuTheme.of(context);
    final menu = Material(
      surfaceTintColor: menuProps.surfaceTintColor,
      shape: menuProps.shape ?? popupMenuTheme.shape,
      color: menuProps.backgroundColor ?? popupMenuTheme.color,
      type: MaterialType.card,
      elevation: menuProps.elevation ?? popupMenuTheme.elevation ?? 2.0,
      clipBehavior: menuProps.clipBehavior,
      borderRadius: menuProps.borderRadius,
      shadowColor: menuProps.shadowColor,
      borderOnForeground: menuProps.borderOnForeground,
      child: child,
    );

    try {
      final position = CustomMenu.getMenuPosition(
        parentContext,
        menuProps.positionCallback,
        menuProps.align,
        constraints,
        menuProps.margin,
      );
      return CustomSingleChildLayout(
        delegate: menuProps.layoutDelegate?.call(
              context,
              position,
            ) ??
            _PopupMenuRouteLayout(context, position),
        child: InheritedTheme.capture(
                from: parentContext, to: Navigator.of(context).context)
            .wrap(menu),
      );
    } catch (e) {
      navigator?.removeRoute(this);
      return SizedBox.shrink();
    }
  }
}

// Positioning of the menu on the screen.
class _PopupMenuRouteLayout extends SingleChildLayoutDelegate {
  // Rectangle of underlying button, relative to the overlay's dimensions.
  final RelativeRect position;
  final BuildContext context;

  const _PopupMenuRouteLayout(
    this.context,
    this.position,
  );

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    //keyBoardHeight is height of keyboard if showing
    final mediaQuery = MediaQuery.of(context);
    final keyBoardHeight = mediaQuery.viewInsets.bottom;
    final safeArea = mediaQuery.padding;

    return BoxConstraints.loose(
      Size(
        constraints.minWidth - position.left - position.right,
        constraints.minHeight,
      ),
    ).deflate(
      EdgeInsets.only(top: keyBoardHeight) + safeArea,
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
    }
    if (y < 0) {
      y = 8;
    }

    if (x + childSize.width > size.width) {
      x = size.width - childSize.width;
    }
    if (x < 0) {
      x = 8;
    }

    return Offset(x, y);
  }

  @override
  bool shouldRelayout(covariant SingleChildLayoutDelegate oldDelegate) => false;
}
