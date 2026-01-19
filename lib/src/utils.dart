import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Value inspected from Xcode 11 & iOS 13.0 Simulator.
const kCupertinoBorderSide = BorderSide(
  color: CupertinoDynamicColor.withBrightness(
    color: Color(0x33000000),
    darkColor: Color(0x33FFFFFF),
  ),
  width: 0.0,
);

const kCupertinoTextFieldBG = CupertinoDynamicColor.withBrightness(
  color: CupertinoColors.white,
  darkColor: CupertinoColors.black,
);

const kCupertinoBorderRadius = BorderRadius.all(Radius.circular(5));

RelativeRect getPosition(RenderBox dropdown, RenderBox overlay, Size menuSize,
    MenuAlign? menuAlign) {
  final dropDownX = dropdown.localToGlobal(Offset.zero, ancestor: overlay).dx;
  final dropDownY = dropdown.localToGlobal(Offset.zero, ancestor: overlay).dy;

  if (menuAlign == MenuAlign.bottomCenter) {
    // Calculate the center position of the TextField for the popup
    final textFieldCenterX = dropDownX + (dropdown.size.width / 2);
    final dY = dropDownY + dropdown.size.height;
    final dX = textFieldCenterX - (menuSize.width / 2);

    return RelativeRect.fromSize(Offset(dX, dY) & menuSize, overlay.size);
  } else if (menuAlign == MenuAlign.bottomStart) {
    final dX = dropDownX;
    final dY = dropDownY + dropdown.size.height;

    return RelativeRect.fromSize(Offset(dX, dY) & menuSize, overlay.size);
  } else if (menuAlign == MenuAlign.topStart) {
    final dX = dropDownX;
    final dY = dropDownY - menuSize.height;

    return RelativeRect.fromSize(Offset(dX, dY) & menuSize, overlay.size);
  } else if (menuAlign == MenuAlign.topCenter) {
    final textFieldCenterX = dropDownX + (dropdown.size.width / 2);
    final dX = textFieldCenterX - menuSize.width / 2;
    final dY = dropDownY - menuSize.height;

    return RelativeRect.fromSize(Offset(dX, dY) & menuSize, overlay.size);
  } else if (menuAlign == MenuAlign.topEnd) {
    final dX = dropdown.localToGlobal(Offset.zero, ancestor: overlay).dx +
        dropdown.size.width -
        menuSize.width;
    final dY = dropDownY - menuSize.height;

    return RelativeRect.fromSize(Offset(dX, dY) & menuSize, overlay.size);
  }

  //by default BottomRight
  final dX = dropdown.localToGlobal(Offset.zero, ancestor: overlay).dx +
      dropdown.size.width -
      menuSize.width;
  final dY = dropdown.localToGlobal(Offset.zero, ancestor: overlay).dy +
      dropdown.size.height;
  return RelativeRect.fromSize(Offset(dX, dY) & menuSize, overlay.size);
}

Size computePopupSize(
    RenderBox dropdown, RenderBox overlay, BoxConstraints popUpConstraints) {
  var menuMinWidth = popUpConstraints.minWidth;
  var menuMaxWidth = popUpConstraints.maxWidth;

  var menuMinHeight = popUpConstraints.minHeight;
  var menuMaxHeight = popUpConstraints.maxHeight;

  var menuWidth = dropdown.size.width;
  var menuHeight = 350.0;

  if (menuMinWidth > 0) {
    menuWidth = menuMinWidth;
  }
  if (menuMaxWidth > 0 && menuMaxWidth < menuWidth) {
    menuWidth = menuMaxWidth;
  }

  if (menuMinHeight > 0) {
    menuHeight = menuMinHeight;
  }
  if (menuMaxHeight > 0 && menuMaxHeight < menuHeight) {
    menuHeight = menuMaxHeight;
  }

  return Size(menuWidth, menuHeight);
}

enum UiToApply { cupertino, material }

extension RelativeRectEx on RelativeRect {
  RelativeRect addMargin(EdgeInsets? margin) {
    if (margin == null) return this;

    return RelativeRect.fromLTRB(left + margin.left, top + margin.top,
        right + margin.right, bottom + margin.bottom);
  }
}

extension PlatformUi on BuildContext {
  UiToApply getUiToApply(UiMode uiMode) {
    switch (uiMode) {
      case UiMode.cupertino:
        return UiToApply.cupertino;
      case UiMode.adaptive:
        final ThemeData theme = Theme.of(this);
        switch (theme.platform) {
          case TargetPlatform.iOS:
          case TargetPlatform.macOS:
            return UiToApply.cupertino;
          case TargetPlatform.android:
          case TargetPlatform.fuchsia:
          case TargetPlatform.linux:
          case TargetPlatform.windows:
            return UiToApply.material;
        }
      case UiMode.material:
        return UiToApply.material;
    }
  }
}
