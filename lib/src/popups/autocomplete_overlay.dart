import 'dart:async';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:dropdown_search/src/utils.dart';
import 'package:material_ui/material_ui.dart';

abstract class CustomOverlayEntry {
  OverlayEntry? overlayEntry;
  Completer? completer;

  OverlayEntry getOverlayEntry(BuildContext context);

  void close() {
    overlayEntry?.remove();
    overlayEntry = null;
    completer?.complete();
  }

  Future<void> open(BuildContext context) async {
    if (completer?.isCompleted == false) return;

    completer = Completer();

    overlayEntry = getOverlayEntry(context);

    Overlay.of(context).insert(overlayEntry!);

    //add screen size change listener
    WidgetsBinding.instance
        .addObserver(CustomWidgetsBindingObserver(overlayEntry!));

    await completer?.future;
  }

  bool isOpen() => completer?.isCompleted == false;

  ///return overlay position based on different params such, constrains, alignment and screen size
  RelativeRect getOverlayPosition(
      BuildContext pContext, MenuAlign? pAlign, BoxConstraints pConstraints) {
    final dropdownBox = pContext.findRenderObject() as RenderBox;
    final overlayBox =
        Overlay.of(pContext).context.findRenderObject() as RenderBox;
    var popupSize = computePopupSize(dropdownBox, overlayBox, pConstraints);
    var lAlign = pAlign ?? MenuAlign.bottomCenter;

    final dropDownY =
        dropdownBox.localToGlobal(Offset.zero, ancestor: overlayBox).dy;
    final bottomHeight =
        overlayBox.size.height - dropDownY - dropdownBox.size.height;
    final topHeight = dropDownY;

    //get best orientation
    if (lAlign.isDown && popupSize.height > bottomHeight) {
      //check if there enough space in opposite direction,
      if (popupSize.height <= topHeight) {
        lAlign = lAlign.reverse;
      } else if (topHeight > bottomHeight) {
        //if there is more available space in the opposite direction then use that direction
        lAlign = lAlign.reverse;
        popupSize = Size(popupSize.width, topHeight);
      } else {
        //Other wise minimize the height to max available space
        popupSize = Size(popupSize.width, bottomHeight);
      }
    } else if (lAlign.isUp && popupSize.height > topHeight) {
      //check if there enough space in opposite direction,
      if (popupSize.height <= bottomHeight) {
        lAlign = lAlign.reverse;
      } else if (bottomHeight > topHeight) {
        //if there is more available space in the opposite direction then use that direction
        lAlign = lAlign.reverse;
        popupSize = Size(popupSize.width, bottomHeight);
      } else {
        //Other wise minimize the height to max available space
        popupSize = Size(popupSize.width, topHeight);
      }
    }

    return getPosition(dropdownBox, overlayBox, popupSize, lAlign);
  }
}

class CustomWidgetsBindingObserver with WidgetsBindingObserver {
  final OverlayEntry overlayEntry;

  CustomWidgetsBindingObserver(this.overlayEntry);

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    overlayEntry.markNeedsBuild();
  }
}

class MaterialCustomOverlyEntry extends CustomOverlayEntry {
  final AutocompleteProps props;
  final BoxConstraints constraints;
  final TapRegionCallback? onTapOutside;
  final Widget? child;

  MaterialCustomOverlyEntry(
      {required this.props,
      required this.constraints,
      this.child,
      this.onTapOutside});

  @override
  getOverlayEntry(BuildContext context) {
    return OverlayEntry(builder: (ctx) {
      final pos = getOverlayPosition(context, props.align, constraints)
          .addMargin(props.margin);
      return Positioned(
        top: pos.top,
        left: pos.left,
        right: pos.right,
        bottom: pos.bottom,
        child: Container(
          constraints: constraints,
          child: TapRegion(
            groupId: props.groupId,
            onTapOutside: onTapOutside,
            child: Material(
              type: MaterialType.card,
              shape: props.shape ?? PopupMenuTheme.of(context).shape,
              color: props.color ?? PopupMenuTheme.of(context).surfaceTintColor,
              elevation:
                  props.elevation ?? PopupMenuTheme.of(context).elevation ?? 4,
              shadowColor:
                  props.shadowColor ?? PopupMenuTheme.of(context).shadowColor,
              surfaceTintColor: props.surfaceTintColor ??
                  PopupMenuTheme.of(context).surfaceTintColor,
              clipBehavior: props.clipBehavior,
              borderRadius: props.borderRadius,
              borderOnForeground: props.borderOnForeground,
              child: child,
            ),
          ),
        ),
      );
    });
  }
}

class CupertinoCustomOverlyEntry extends CustomOverlayEntry {
  final CupertinoAutocompleteProps props;
  final TapRegionCallback? onTapOutside;
  final BoxConstraints constraints;
  final Widget? child;

  CupertinoCustomOverlyEntry(
      {required this.props,
      required this.constraints,
      this.child,
      this.onTapOutside});

  @override
  OverlayEntry getOverlayEntry(BuildContext context) {
    return OverlayEntry(builder: (ctx) {
      final pos = getOverlayPosition(context, props.align, constraints)
          .addMargin(props.margin);
      return Positioned(
        top: pos.top,
        left: pos.left,
        right: pos.right,
        bottom: pos.bottom,
        child: Container(
          constraints: constraints,
          child: TapRegion(
            groupId: props.groupId,
            onTapOutside: onTapOutside,
            child: Material(
              type: MaterialType.card,
              shape: props.shape ?? PopupMenuTheme.of(context).shape,
              elevation:
                  props.elevation ?? PopupMenuTheme.of(context).elevation ?? 8,
              color: props.color ?? PopupMenuTheme.of(context).color,
              clipBehavior: props.clipBehavior,
              borderRadius: props.borderRadius,
              shadowColor: props.shadowColor,
              borderOnForeground: props.borderOnForeground,
              surfaceTintColor: props.surfaceTintColor,
              child: child,
            ),
          ),
        ),
      );
    });
  }
}
