import 'package:dropdown_search/src/base_dropdown_search.dart';
import 'package:dropdown_search/src/popups/props/material_popup_props.dart';
import 'package:dropdown_search/src/utils.dart';

class DropdownSearch<T> extends BaseDropdownSearch<T> {
  DropdownSearch({
    PopupProps<T> popupProps = const PopupProps.menu(),
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
          popupProps: popupProps,
          uiMode: UiToApply.material,
          groupId: popupProps.autoCompleteProps.groupId,
        );

  DropdownSearch.multiSelection({
    MultiSelectionPopupProps<T> popupProps = const MultiSelectionPopupProps.menu(),
    super.key,
    super.mode = Mode.form,
    super.autoValidateMode,
    super.items,
    super.suffixProps,
    super.clickProps,
    super.chipProps,
    super.enabled,
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
          popupProps: popupProps,
          uiMode: UiToApply.material,
          groupId: popupProps.autoCompleteProps.groupId,
        );
}
