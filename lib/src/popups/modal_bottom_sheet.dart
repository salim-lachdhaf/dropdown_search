import 'package:dropdown_search/dropdown_search.dart';
import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:material_ui/material_ui.dart';

Future openMaterialModalBottomSheet(
    BuildContext context, Widget content, ModalBottomSheetProps props) {
  final sheetTheme = Theme.of(context).bottomSheetTheme;
  return showModalBottomSheet(
    context: context,
    barrierLabel: props.barrierLabel,
    scrollControlDisabledMaxHeightRatio:
        props.scrollControlDisabledMaxHeightRatio,
    showDragHandle: props.showDragHandle,
    sheetAnimationStyle: props.sheetAnimationStyle,
    useSafeArea: props.useSafeArea,
    barrierColor: props.barrierColor,
    backgroundColor: props.backgroundColor ??
        sheetTheme.modalBackgroundColor ??
        sheetTheme.backgroundColor,
    isDismissible: props.barrierDismissible,
    isScrollControlled: props.isScrollControlled,
    enableDrag: props.enableDrag,
    clipBehavior: props.clipBehavior,
    elevation: props.elevation,
    shape: props.shape,
    anchorPoint: props.anchorPoint,
    useRootNavigator: props.useRootNavigator,
    transitionAnimationController: props.animation,
    constraints: props.constraints,
    routeSettings: props.routeSettings,
    builder: (ctx) {
      return Container(
        margin: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: content,
      );
    },
  );
}

Future openAdaptiveModalBottomSheet(
  BuildContext context,
  Widget content,
  AdaptiveModalBottomSheetProps props,
  List<CupertinoActionSheetAction>? defaultCupertinoActions,
) {
  final ThemeData theme = Theme.of(context);
  switch (theme.platform) {
    case TargetPlatform.iOS:
    case TargetPlatform.macOS:
      return openCupertinoModalBottomSheet(
          context, content, props.cupertinoProps, defaultCupertinoActions);
    case TargetPlatform.android:
    case TargetPlatform.fuchsia:
    case TargetPlatform.linux:
    case TargetPlatform.windows:
    default:
      return openMaterialModalBottomSheet(
          context, content, props.materialProps);
  }
}

Future openCupertinoModalBottomSheet(
  BuildContext context,
  Widget content,
  CupertinoModalBottomSheetProps props,
  List<CupertinoActionSheetAction>? defaultActions,
) {
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
      return Container(
        //to move layout up if keyboard is showed up
        margin: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: CupertinoActionSheet(
          title: props.title,
          actionScrollController: props.actionScrollController,
          actions: props.actions ?? defaultActions,
          cancelButton: props.cancelButton ??
              CupertinoActionSheetAction(
                isDestructiveAction: true,
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
          messageScrollController: props.messageScrollController,
          message: content,
        ),
      );
    },
  );
}
