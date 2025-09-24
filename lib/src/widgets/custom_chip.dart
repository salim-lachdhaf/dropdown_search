import 'package:dropdown_search/src/widgets/props/chip_props.dart';
import 'package:flutter/material.dart';

class CustomChip extends StatelessWidget {
  final Widget label;
  final ChipProps props;

  const CustomChip({super.key, required this.label, required this.props});

  @override
  Widget build(BuildContext context) {
    return InputChip(
      label: label,
      avatar: props.avatar,
      labelStyle: props.labelStyle,
      labelPadding: props.labelPadding,
      selected: props.selected ?? false,
      isEnabled: props.isEnabled ?? true,
      onSelected: props.onSelected,
      deleteIcon: props.deleteIcon,
      onDeleted: props.onDeleted,
      deleteIconColor: props.deleteIconColor,
      deleteButtonTooltipMessage: props.deleteButtonTooltipMessage,
      onPressed: props.onPressed,
      pressElevation: props.pressElevation,
      disabledColor: props.disabledColor,
      selectedColor: props.selectedColor,
      tooltip: props.tooltip,
      side: props.side,
      shape: props.shape,
      clipBehavior: props.clipBehavior,
      focusNode: props.focusNode,
      autofocus: props.autofocus,
      color: props.color,
      backgroundColor: props.backgroundColor,
      padding: props.padding,
      visualDensity: props.visualDensity,
      materialTapTargetSize: props.materialTapTargetSize,
      elevation: props.elevation,
      shadowColor: props.shadowColor,
      surfaceTintColor: props.surfaceTintColor,
      iconTheme: props.iconTheme,
      selectedShadowColor: props.selectedShadowColor,
      showCheckmark: props.showCheckmark ?? false,
      checkmarkColor: props.checkmarkColor,
      avatarBorder: props.avatarBorder,
      avatarBoxConstraints: props.avatarBoxConstraints,
      deleteIconBoxConstraints: props.deleteIconBoxConstraints,
      chipAnimationStyle: props.chipAnimationStyle,
      mouseCursor: props.mouseCursor,
    );
  }
}
