import 'package:dropdown_search/src/base_dropdown_search.dart';
import 'package:dropdown_search/src/widgets/props/adaptive_popup_props.dart';
import 'package:dropdown_search/src/utils.dart';
import 'package:flutter/material.dart';

class AdaptiveDropdownSearch<T> extends BaseDropdownSearch<T> {
  AdaptiveDropdownSearch({
    AdaptivePopupProps<T> popupProps = const AdaptivePopupProps(),
    required BuildContext context,
    super.key,
    super.selectedItem,
    super.mode = Mode.form,
    super.autoValidateMode,
    super.onSelected,
    super.items,
    super.dropdownBuilder,
    super.suffixProps,
    super.clickProps,
    super.chipProps,
    super.enabled,
    super.filterFn,
    super.itemAsString,
    super.compareFn,
    super.onBeforeChange,
    super.onBeforePopupOpening,
    super.onFocusChange,
    super.onBeforeClear,
    super.onClear,
    //form properties
    super.onSaved,
    super.validator,
    super.decoratorProps,
    super.textProps,
  }) : super(
          uiMode: context.getUiToApply(UiMode.adaptive),
          popupProps: context.getUiToApply(UiMode.adaptive) == UiToApply.cupertino
              ? popupProps.cupertinoProps
              : popupProps.materialProps,
          groupId: context.getUiToApply(UiMode.adaptive) == UiToApply.cupertino
              ? popupProps.cupertinoProps.autoCompleteProps.groupId
              : popupProps.materialProps.autoCompleteProps.groupId,
        );

  AdaptiveDropdownSearch.multiSelection({
    AdaptiveMultiSelectionPopupProps<T> popupProps =
        const AdaptiveMultiSelectionPopupProps(),
    required BuildContext context,
    super.key,
    super.mode = Mode.form,
    super.autoValidateMode,
    super.items,
    super.suffixProps,
    super.clickProps,
    super.chipProps,
    super.enabled = true,
    super.filterFn,
    super.itemAsString,
    super.compareFn,
    super.selectedItems,
    super.selectedItemsScrollProps,
    super.onSelected,
    super.onBeforeChange,
    super.onBeforePopupOpening,
    super.onFocusChange,
    super.dropdownBuilder,
    super.onBeforeClear,
    super.onClear,
    //form properties
    super.onSaved,
    super.validator,
    super.decoratorProps,
    super.selectedItemsWrapProps,
    super.textProps,
  }) : super.multiSelection(
          uiMode: context.getUiToApply(UiMode.adaptive),
          popupProps: context.getUiToApply(UiMode.adaptive) == UiToApply.cupertino
              ? popupProps.cupertinoProps
              : popupProps.materialProps,
          groupId: context.getUiToApply(UiMode.adaptive) == UiToApply.cupertino
              ? popupProps.cupertinoProps.autoCompleteProps.groupId
              : popupProps.materialProps.autoCompleteProps.groupId,
        );
}
