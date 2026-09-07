import 'package:material_ui/material_ui.dart';

class DialogProps {
  final List<Widget>? actions;
  final MainAxisAlignment? actionsAlignment;
  final OverflowBarAlignment? actionsOverflowAlignment;
  final double? actionsOverflowButtonSpacing;
  final VerticalDirection? actionsOverflowDirection;
  final EdgeInsetsGeometry? actionsPadding;
  final EdgeInsets? insetPadding;
  final EdgeInsetsGeometry? buttonPadding;
  final EdgeInsetsGeometry contentPadding;
  final Offset? anchorPoint;
  final RouteTransitionsBuilder? transitionBuilder;
  final ShapeBorder? shape;
  final bool useRootNavigator;
  final RouteSettings? routeSettings;
  final double? elevation;
  final String? semanticLabel;
  final Color? barrierColor;
  final String? barrierLabel;
  final Color? backgroundColor;
  final bool barrierDismissible;
  final Duration transitionDuration;
  final Clip? clipBehavior;
  final AnimationController? animation;
  final AlignmentGeometry? alignment;
  final Color? shadowColor;
  final Color? surfaceTintColor;
  final Widget? title;
  final Widget? icon;
  final Color? iconColor;
  final EdgeInsetsGeometry? iconPadding;
  final bool scrollable;
  final EdgeInsetsGeometry? titlePadding;
  final TextStyle? titleTextStyle;

  const DialogProps({
    this.routeSettings,
    this.iconPadding,
    this.titlePadding,
    this.titleTextStyle,
    this.title,
    this.icon,
    this.scrollable = false,
    this.iconColor,
    this.alignment,
    this.elevation,
    this.semanticLabel,
    this.shape,
    this.barrierColor,
    this.barrierLabel,
    this.backgroundColor,
    this.barrierDismissible = false,
    this.transitionDuration = kThemeChangeDuration,
    this.animation,
    this.actions,
    this.actionsAlignment,
    this.actionsOverflowAlignment,
    this.actionsOverflowButtonSpacing,
    this.actionsOverflowDirection,
    this.clipBehavior = Clip.hardEdge,
    this.useRootNavigator = true,
    this.actionsPadding,
    this.insetPadding,
    this.buttonPadding,
    this.contentPadding = EdgeInsets.zero,
    this.anchorPoint,
    this.transitionBuilder,
    this.shadowColor,
    this.surfaceTintColor,
  });
}

class CupertinoDialogProps {
  final String? barrierLabel;
  final bool useRootNavigator;
  final bool barrierDismissible;
  final RouteSettings? routeSettings;
  final Offset? anchorPoint;
  final Color? barrierColor;

  final List<Widget>? actions;
  final ScrollController? scrollController;
  final ScrollController? actionScrollController;
  final Duration insetAnimationDuration;
  final Curve insetAnimationCurve;

  const CupertinoDialogProps({
    this.barrierDismissible = false,
    this.useRootNavigator = true,
    this.barrierLabel,
    this.barrierColor,
    this.routeSettings,
    this.anchorPoint,
    this.actions,
    this.scrollController,
    this.actionScrollController,
    this.insetAnimationDuration = const Duration(milliseconds: 100),
    this.insetAnimationCurve = Curves.decelerate,
  });
}

class AdaptiveDialogProps {
  final DialogProps materialProps;
  final CupertinoDialogProps cupertinoProps;

  const AdaptiveDialogProps({
    this.materialProps = const DialogProps(),
    this.cupertinoProps = const CupertinoDialogProps(),
  });
}
