import 'package:dropdown_search/dropdown_search.dart';
import 'package:dropdown_search/src/widgets/custom_safe_area.dart';
import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:material_ui/material_ui.dart';

Future openMaterialBottomSheet(
    BuildContext context, Widget content, BottomSheetProps props) {
  return showBottomSheet(
    context: context,
    showDragHandle: props.showDragHandle,
    sheetAnimationStyle: props.sheetAnimationStyle,
    enableDrag: props.enableDrag,
    backgroundColor: props.backgroundColor,
    clipBehavior: props.clipBehavior,
    elevation: props.elevation,
    shape: props.shape,
    transitionAnimationController: props.transitionAnimationController,
    constraints: props.constraints,
    builder: (ctx) => content,
  ).closed;
}

Future openAdaptiveBottomSheet(
    BuildContext context, Widget content, AdaptiveBottomSheetProps props) {
  final ThemeData theme = Theme.of(context);
  switch (theme.platform) {
    case TargetPlatform.iOS:
    case TargetPlatform.macOS:
      return openCupertinoBottomSheet(context, content, props.cupertinoProps);
    case TargetPlatform.android:
    case TargetPlatform.fuchsia:
    case TargetPlatform.linux:
    case TargetPlatform.windows:
    default:
      return openMaterialBottomSheet(context, content, props.materialProps);
  }
}

Future openCupertinoBottomSheet(
    BuildContext context, Widget content, CupertinoBottomSheetProps props) {
  return showCupertinoModalPopup(
    context: context,
    anchorPoint: props.anchorPoint,
    useRootNavigator: props.useRootNavigator,
    barrierColor: props.barrierLabel,
    barrierDismissible: props.barrierDismissible,
    filter: props.filter,
    semanticsDismissible: props.semanticsDismissible,
    routeSettings: props.routeSettings,
    builder: (ctx) {
      return CustomSafeArea(
        props: props.safeAreaProps,
        child: CupertinoPopupSurface(
          isSurfacePainted: props.isSurfacePainted,
          child: Container(
            margin:
                EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
            child: content,
          ),
        ),
      );
    },
  );
}
