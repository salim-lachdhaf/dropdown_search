import 'package:dropdown_search/src/base_dropdown_search.dart';
import 'package:dropdown_search/src/popups/props/menu_props.dart';
import 'package:material_ui/material_ui.dart';

class AutocompleteProps {
  final MenuAlign? align;
  final ShapeBorder? shape;
  final double? elevation;
  final Clip clipBehavior;
  final BorderRadiusGeometry? borderRadius;
  final Color? shadowColor;
  final bool borderOnForeground;
  final PositionCallback? positionCallback;
  final Color? color;
  final Color? surfaceTintColor;
  final EdgeInsets? margin;
  final Object? groupId;

  const AutocompleteProps({
    this.groupId = 'DropdownSearchAutocomplete',
    this.align,
    this.elevation = 4,
    this.shape = const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(4.0))),
    this.positionCallback,
    this.clipBehavior = Clip.none,
    this.borderOnForeground = false,
    this.borderRadius,
    this.shadowColor,
    this.color,
    this.surfaceTintColor,
    this.margin,
  });
}

class CupertinoAutocompleteProps<T> {
  final MenuAlign? align;
  final ShapeBorder? shape;
  final double? elevation;
  final Clip clipBehavior;
  final BorderRadiusGeometry? borderRadius;
  final Color? shadowColor;
  final bool borderOnForeground;
  final PositionCallback? positionCallback;
  final Color? color;
  final Color? surfaceTintColor;
  final EdgeInsets? margin;
  final Object? groupId;
  const CupertinoAutocompleteProps({
    this.groupId = 'DropdownSearchAutocomplete',
    this.align,
    this.elevation = 8,
    this.shape = const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12))),
    this.positionCallback,
    this.clipBehavior = Clip.none,
    this.borderOnForeground = false,
    this.borderRadius,
    this.shadowColor,
    this.color,
    this.surfaceTintColor,
    this.margin = const EdgeInsets.only(top: 8),
  });
}

class AdaptiveAutocompleteProps {
  final CupertinoAutocompleteProps cupertinoProps;
  final AutocompleteProps materialProps;

  const AdaptiveAutocompleteProps({
    this.materialProps = const AutocompleteProps(),
    this.cupertinoProps = const CupertinoAutocompleteProps(),
  });
}
