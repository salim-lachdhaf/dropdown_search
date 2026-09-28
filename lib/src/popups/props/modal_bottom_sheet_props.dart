import 'dart:ui';

import 'package:cupertino_ui/cupertino_ui.dart';

class ModalBottomSheetProps {
  final ShapeBorder? shape;
  final bool useRootNavigator;
  final BoxConstraints? constraints;
  final double? elevation;
  final Color? barrierColor;
  final Color? backgroundColor;
  final bool barrierDismissible;
  final Clip clipBehavior;
  final AnimationController? animation;
  final bool enableDrag;
  final Offset? anchorPoint;
  final bool isScrollControlled;
  final EdgeInsets padding;
  final bool useSafeArea;
  final bool? showDragHandle;
  final AnimationStyle? sheetAnimationStyle;
  final String? barrierLabel;
  final double scrollControlDisabledMaxHeightRatio;
  final RouteSettings? routeSettings;

  const ModalBottomSheetProps({
    this.anchorPoint,
    this.elevation,
    this.shape,
    this.barrierColor,
    this.backgroundColor,
    this.barrierDismissible = true,
    this.animation,
    this.enableDrag = true,
    this.clipBehavior = Clip.none,
    this.useRootNavigator = false,
    this.constraints,
    this.isScrollControlled = true,
    this.padding = EdgeInsets.zero,
    this.useSafeArea = true,
    this.sheetAnimationStyle,
    this.showDragHandle,
    this.barrierLabel,
    this.scrollControlDisabledMaxHeightRatio = 9.0 / 16.0,
    this.routeSettings,
  });
}

class CupertinoModalBottomSheetProps {
  final bool useRootNavigator;
  final ImageFilter? filter;
  final bool barrierDismissible;
  final bool semanticsDismissible;
  final RouteSettings? routeSettings;
  final Offset? anchorPoint;
  final Color barrierLabel;
  final Widget? title;
  final Widget? cancelButton;
  final ScrollController? messageScrollController;
  final List<Widget>? actions;
  final ScrollController? actionScrollController;

  const CupertinoModalBottomSheetProps({
    this.anchorPoint,
    this.routeSettings,
    this.actionScrollController,
    this.messageScrollController,
    this.cancelButton,
    this.actions,
    this.title,
    this.filter,
    this.barrierDismissible = true,
    this.semanticsDismissible = false,
    this.useRootNavigator = false,
    this.barrierLabel = kCupertinoModalBarrierColor,
  });
}

class AdaptiveModalBottomSheetProps {
  final CupertinoModalBottomSheetProps cupertinoProps;
  final ModalBottomSheetProps materialProps;

  const AdaptiveModalBottomSheetProps({
    this.materialProps = const ModalBottomSheetProps(),
    this.cupertinoProps = const CupertinoModalBottomSheetProps(),
  });
}
