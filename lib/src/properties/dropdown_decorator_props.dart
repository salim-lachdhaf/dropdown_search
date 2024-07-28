import 'package:dropdown_search/src/properties/ink_well_props.dart';
import 'package:flutter/material.dart';

class DropDownDecoratorProps {
  final InputDecoration? dropdownSearchDecoration;
  final InkWellProps? inkWellProps;
  final TextStyle? baseStyle;
  final TextAlign? textAlign;
  final TextAlignVertical? textAlignVertical;

  const DropDownDecoratorProps({
    this.dropdownSearchDecoration,
    this.inkWellProps,
    this.baseStyle,
    this.textAlign,
    this.textAlignVertical,
  });
}
