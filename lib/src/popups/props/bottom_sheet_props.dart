import 'dart:ui';

import 'package:dropdown_search/src/widgets/props/safe_area_props.dart';
import 'package:cupertino_ui/cupertino_ui.dart';

class BottomSheetProps {
  final ShapeBorder? shape;
  final BoxConstraints? constraints;
  final Color? backgroundColor;
  final Clip clipBehavior;
  final AnimationController? transitionAnimationController;
  final bool enableDrag;
  final double? elevation;
  final bool? showDragHandle;
  final AnimationStyle? sheetAnimationStyle;

  const BottomSheetProps({
    this.elevation,
    this.shape,
    this.backgroundColor,
    this.transitionAnimationController,
    this.enableDrag = true,
    this.clipBehavior = Clip.none,
    this.constraints,
    this.showDragHandle,
    this.sheetAnimationStyle,
  });
}

class CupertinoBottomSheetProps {
  final bool useRootNavigator;
  final ImageFilter? filter;
  final bool barrierDismissible;
  final bool semanticsDismissible;
  final RouteSettings? routeSettings;
  final bool isSurfacePainted;
  final Offset? anchorPoint;
  final Color barrierLabel;
  final SafeAreaProps safeAreaProps;

  const CupertinoBottomSheetProps({
    this.anchorPoint,
    this.routeSettings,
    this.isSurfacePainted = true,
    this.filter,
    this.barrierDismissible = true,
    this.semanticsDismissible = false,
    this.useRootNavigator = false,
    this.barrierLabel = kCupertinoModalBarrierColor,
    this.safeAreaProps = const SafeAreaProps(),
  });
}

class AdaptiveBottomSheetProps {
  final CupertinoBottomSheetProps cupertinoProps;
  final BottomSheetProps materialProps;

  const AdaptiveBottomSheetProps({
    this.cupertinoProps = const CupertinoBottomSheetProps(),
    this.materialProps = const BottomSheetProps(),
  });
}
