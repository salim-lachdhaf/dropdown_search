import 'package:flutter/material.dart';

///see [InputChip] for details
class ChipProps {
  final Widget? avatar;
  final TextStyle? labelStyle;
  final EdgeInsetsGeometry? labelPadding;
  final bool? selected;
  final bool? isEnabled;
  final ValueChanged<bool>? onSelected;
  final Widget? deleteIcon;
  final VoidCallback? onDeleted;
  final Color? deleteIconColor;
  final String? deleteButtonTooltipMessage;
  final VoidCallback? onPressed;
  final double? pressElevation;
  final Color? disabledColor;
  final Color? selectedColor;
  final String? tooltip;
  final BorderSide? side;
  final OutlinedBorder? shape;
  final Clip clipBehavior;
  final FocusNode? focusNode;
  final bool autofocus;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;
  final VisualDensity? visualDensity;
  final MaterialTapTargetSize? materialTapTargetSize;
  final double? elevation;
  final Color? shadowColor;
  final Color? surfaceTintColor;
  final Color? selectedShadowColor;
  final bool? showCheckmark;
  final Color? checkmarkColor;
  final ShapeBorder avatarBorder;
  final IconThemeData? iconTheme;
  final BoxConstraints? avatarBoxConstraints;
  final BoxConstraints? deleteIconBoxConstraints;
  final ChipAnimationStyle? chipAnimationStyle;
  final WidgetStateProperty<Color?>? color;
  final MouseCursor? mouseCursor;

  const ChipProps({
    this.avatar,
    this.labelStyle,
    this.labelPadding,
    this.selected,
    this.isEnabled,
    this.onSelected,
    this.deleteIcon,
    this.onDeleted,
    this.deleteIconColor,
    this.deleteButtonTooltipMessage,
    this.onPressed,
    this.pressElevation,
    this.disabledColor,
    this.selectedColor,
    this.tooltip,
    this.side,
    this.shape,
    this.clipBehavior = Clip.none,
    this.focusNode,
    this.autofocus = false,
    this.color,
    this.backgroundColor,
    this.padding,
    this.visualDensity,
    this.materialTapTargetSize,
    this.elevation,
    this.shadowColor,
    this.surfaceTintColor,
    this.iconTheme,
    this.selectedShadowColor,
    this.showCheckmark,
    this.checkmarkColor,
    this.avatarBorder = const CircleBorder(),
    this.avatarBoxConstraints,
    this.deleteIconBoxConstraints,
    this.chipAnimationStyle,
    this.mouseCursor,
  });

  ChipProps copyWith({
    Widget? avatar,
    TextStyle? labelStyle,
    EdgeInsetsGeometry? labelPadding,
    bool? selected,
    bool? isEnabled,
    ValueChanged<bool>? onSelected,
    Widget? deleteIcon,
    VoidCallback? onDeleted,
    Color? deleteIconColor,
    String? deleteButtonTooltipMessage,
    VoidCallback? onPressed,
    double? pressElevation,
    Color? disabledColor,
    Color? selectedColor,
    String? tooltip,
    BorderSide? side,
    OutlinedBorder? shape,
    Clip? clipBehavior,
    FocusNode? focusNode,
    bool? autofocus,
    Color? backgroundColor,
    EdgeInsetsGeometry? padding,
    VisualDensity? visualDensity,
    MaterialTapTargetSize? materialTapTargetSize,
    double? elevation,
    Color? shadowColor,
    Color? surfaceTintColor,
    Color? selectedShadowColor,
    bool? showCheckmark,
    Color? checkmarkColor,
    ShapeBorder? avatarBorder,
    IconThemeData? iconTheme,
    BoxConstraints? avatarBoxConstraints,
    BoxConstraints? deleteIconBoxConstraints,
    ChipAnimationStyle? chipAnimationStyle,
    WidgetStateProperty<Color?>? color,
    MouseCursor? mouseCursor,
  }) {
    return ChipProps(
      avatar: avatar ?? this.avatar,
      labelStyle: labelStyle ?? this.labelStyle,
      labelPadding: labelPadding ?? this.labelPadding,
      selected: selected ?? this.selected,
      isEnabled: isEnabled ?? this.isEnabled,
      onSelected: onSelected ?? this.onSelected,
      deleteIcon: deleteIcon ?? this.deleteIcon,
      onDeleted: onDeleted ?? this.onDeleted,
      deleteIconColor: deleteIconColor ?? this.deleteIconColor,
      deleteButtonTooltipMessage: deleteButtonTooltipMessage ?? this.deleteButtonTooltipMessage,
      onPressed: onPressed ?? this.onPressed,
      pressElevation: pressElevation ?? this.pressElevation,
      disabledColor: disabledColor ?? this.disabledColor,
      selectedColor: selectedColor ?? this.selectedColor,
      tooltip: tooltip ?? this.tooltip,
      side: side ?? this.side,
      shape: shape ?? this.shape,
      clipBehavior: clipBehavior ?? this.clipBehavior,
      focusNode: focusNode ?? this.focusNode,
      autofocus: autofocus ?? this.autofocus,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      padding: padding ?? this.padding,
      visualDensity: visualDensity ?? this.visualDensity,
      materialTapTargetSize: materialTapTargetSize ?? this.materialTapTargetSize,
      elevation: elevation ?? this.elevation,
      shadowColor: shadowColor ?? this.shadowColor,
      surfaceTintColor: surfaceTintColor ?? this.surfaceTintColor,
      selectedShadowColor: selectedShadowColor ?? this.selectedShadowColor,
      showCheckmark: showCheckmark ?? this.showCheckmark,
      checkmarkColor: checkmarkColor ?? this.checkmarkColor,
      avatarBorder: avatarBorder ?? this.avatarBorder,
      iconTheme: iconTheme ?? this.iconTheme,
      avatarBoxConstraints: avatarBoxConstraints ?? this.avatarBoxConstraints,
      deleteIconBoxConstraints: deleteIconBoxConstraints ?? this.deleteIconBoxConstraints,
      chipAnimationStyle: chipAnimationStyle ?? this.chipAnimationStyle,
      color: color ?? this.color,
      mouseCursor: mouseCursor ?? this.mouseCursor,
    );
  }

  ChipProps merge(ChipProps? other) {
    if (other == null) return this;

    return copyWith(
      avatar: other.avatar ?? avatar,
      labelStyle: other.labelStyle ?? labelStyle,
      labelPadding: other.labelPadding ?? labelPadding,
      selected: other.selected ?? selected,
      isEnabled: other.isEnabled ?? isEnabled,
      onSelected: other.onSelected ?? onSelected,
      deleteIcon: other.deleteIcon ?? deleteIcon,
      onDeleted: other.onDeleted ?? onDeleted,
      deleteIconColor: other.deleteIconColor ?? deleteIconColor,
      deleteButtonTooltipMessage: other.deleteButtonTooltipMessage ?? deleteButtonTooltipMessage,
      onPressed: other.onPressed ?? onPressed,
      pressElevation: other.pressElevation ?? pressElevation,
      disabledColor: other.disabledColor ?? disabledColor,
      selectedColor: other.selectedColor ?? selectedColor,
      tooltip: other.tooltip ?? tooltip,
      side: other.side ?? side,
      shape: other.shape ?? shape,
      clipBehavior: other.clipBehavior,
      focusNode: other.focusNode ?? focusNode,
      autofocus: other.autofocus,
      backgroundColor: other.backgroundColor ?? backgroundColor,
      padding: other.padding ?? padding,
      visualDensity: other.visualDensity ?? visualDensity,
      materialTapTargetSize: other.materialTapTargetSize ?? materialTapTargetSize,
      elevation: other.elevation ?? elevation,
      shadowColor: other.shadowColor ?? shadowColor,
      surfaceTintColor: other.surfaceTintColor ?? surfaceTintColor,
      selectedShadowColor: other.selectedShadowColor ?? selectedShadowColor,
      showCheckmark: other.showCheckmark ?? showCheckmark,
      checkmarkColor: other.checkmarkColor ?? checkmarkColor,
      avatarBorder: other.avatarBorder,
      iconTheme: other.iconTheme ?? iconTheme,
      avatarBoxConstraints: other.avatarBoxConstraints ?? avatarBoxConstraints,
      deleteIconBoxConstraints: other.deleteIconBoxConstraints ?? deleteIconBoxConstraints,
      chipAnimationStyle: other.chipAnimationStyle ?? chipAnimationStyle,
      color: other.color ?? color,
      mouseCursor: other.mouseCursor ?? mouseCursor,
    );
  }
}
