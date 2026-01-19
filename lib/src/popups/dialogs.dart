import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future openMaterialDialog(
    BuildContext context, Widget content, DialogProps props) {
  return showGeneralDialog(
    context: context,
    barrierDismissible: props.barrierDismissible,
    barrierLabel: props.barrierLabel,
    transitionDuration: props.transitionDuration,
    barrierColor: props.barrierColor ?? Colors.black54,
    useRootNavigator: props.useRootNavigator,
    anchorPoint: props.anchorPoint,
    transitionBuilder: props.transitionBuilder,
    routeSettings: props.routeSettings,
    pageBuilder: (context, animation, secondaryAnimation) {
      return AlertDialog(
        actions: props.actions,
        buttonPadding: props.buttonPadding,
        actionsOverflowButtonSpacing: props.actionsOverflowButtonSpacing,
        insetPadding: props.insetPadding,
        actionsPadding: props.actionsPadding,
        actionsOverflowDirection: props.actionsOverflowDirection,
        actionsOverflowAlignment: props.actionsOverflowAlignment,
        actionsAlignment: props.actionsAlignment,
        alignment: props.alignment,
        clipBehavior: props.clipBehavior,
        elevation: props.elevation,
        contentPadding: props.contentPadding,
        shape: props.shape,
        backgroundColor: props.backgroundColor,
        semanticLabel: props.semanticLabel,
        shadowColor: props.shadowColor,
        surfaceTintColor: props.surfaceTintColor,
        title: props.title,
        icon: props.icon,
        iconColor: props.iconColor,
        iconPadding: props.iconPadding,
        scrollable: props.scrollable,
        titlePadding: props.titlePadding,
        titleTextStyle: props.titleTextStyle,
        content: content,
      );
    },
  );
}

Future openAdaptiveDialog(
  BuildContext context,
  Widget content,
  AdaptiveDialogProps props,
  List<CupertinoDialogAction>? defaultCupertinoActions,
) {
  final ThemeData theme = Theme.of(context);
  switch (theme.platform) {
    case TargetPlatform.iOS:
    case TargetPlatform.macOS:
      return openCupertinoDialog(
          context, content, props.cupertinoProps, defaultCupertinoActions);
    case TargetPlatform.android:
    case TargetPlatform.fuchsia:
    case TargetPlatform.linux:
    case TargetPlatform.windows:
      return openMaterialDialog(context, content, props.materialProps);
  }
}

Future openCupertinoDialog(
  BuildContext context,
  Widget content,
  CupertinoDialogProps props,
  List<CupertinoDialogAction>? defaultActions,
) {
  return showCupertinoDialog(
    context: context,
    barrierDismissible: props.barrierDismissible,
    barrierLabel: props.barrierLabel,
    useRootNavigator: props.useRootNavigator,
    anchorPoint: props.anchorPoint,
    routeSettings: props.routeSettings,
    builder: (context) {
      return CupertinoAlertDialog(
        actions: props.actions ?? defaultActions ?? [],
        content: content,
        scrollController: props.scrollController,
        actionScrollController: props.actionScrollController,
        insetAnimationCurve: props.insetAnimationCurve,
        insetAnimationDuration: props.insetAnimationDuration,
      );
    },
  );
}
