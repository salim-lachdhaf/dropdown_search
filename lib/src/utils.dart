import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

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
