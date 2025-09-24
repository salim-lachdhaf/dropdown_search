import 'package:dropdown_search/src/base_dropdown_search.dart';
import 'package:dropdown_search/src/popups/props/autocomplete_props.dart';
import 'package:dropdown_search/src/popups/props/bottom_sheet_props.dart';
import 'package:dropdown_search/src/popups/props/dialog_props.dart';
import 'package:dropdown_search/src/popups/props/menu_props.dart';
import 'package:dropdown_search/src/popups/props/modal_bottom_sheet_props.dart';
import 'package:dropdown_search/src/widgets/props/base_popup_props.dart';
import 'package:dropdown_search/src/widgets/props/text_field_props.dart';
import 'package:flutter/material.dart';

class MultiSelectionPopupProps<T> extends BasePopupProps<T> {
  ///dialog mode props
  final DialogProps dialogProps;

  ///BottomSheet mode props
  final BottomSheetProps bottomSheetProps;

  ///ModalBottomSheet mode props
  final ModalBottomSheetProps modalBottomSheetProps;

  ///Menu mode props
  final MenuProps menuProps;

  ///Menu mode props
  final AutocompleteProps autoCompleteProps;

  const MultiSelectionPopupProps.menu({
    this.menuProps = const MenuProps(),
    TextFieldProps searchFieldProps = const TextFieldProps(),
    super.fit,
    super.suggestionsProps,
    super.scrollbarProps,
    super.listViewProps,
    super.searchDelay,
    super.itemClickProps,
    super.showSearchBox,
    super.title,
    super.disableFilter,
    super.cacheItems,
    super.itemBuilder,
    super.disabledItemFn,
    super.onDisplayed,
    super.onDismissed,
    super.emptyBuilder,
    super.errorBuilder,
    super.loadingBuilder,
    super.showSelectedItems,
    super.containerBuilder,
    super.constraints = const BoxConstraints(maxHeight: 350),
    super.interceptCallBacks,
    super.infiniteScrollProps,
    super.onItemsLoaded,
    //multi selection props
    super.onItemAdded,
    super.onItemRemoved,
    super.checkBoxBuilder,
    super.validationBuilder,
    super.textDirection = TextDirection.ltr,
  })  : bottomSheetProps = const BottomSheetProps(),
        dialogProps = const DialogProps(),
        autoCompleteProps = const AutocompleteProps(),
        modalBottomSheetProps = const ModalBottomSheetProps(),
        super(mode: PopupMode.menu, searchFieldProps: searchFieldProps);

  const MultiSelectionPopupProps.autocomplete({
    this.autoCompleteProps = const AutocompleteProps(),
    TextFieldProps searchFieldProps = const TextFieldProps(),
    super.fit,
    super.suggestionsProps,
    super.scrollbarProps,
    super.listViewProps,
    super.searchDelay,
    super.itemClickProps,
    super.showSearchBox,
    super.title,
    super.disableFilter,
    super.cacheItems,
    super.itemBuilder,
    super.disabledItemFn,
    super.onDismissed,
    super.emptyBuilder,
    super.errorBuilder,
    super.loadingBuilder,
    super.showSelectedItems,
    super.containerBuilder,
    super.constraints = const BoxConstraints(maxHeight: 350),
    super.interceptCallBacks,
    super.infiniteScrollProps,
    super.onItemsLoaded,
    super.onDisplayed,
    //multi selection props
    super.onItemAdded,
    super.onItemRemoved,
    super.checkBoxBuilder,
    super.validationBuilder,
    super.textDirection = TextDirection.ltr,
  })  : bottomSheetProps = const BottomSheetProps(),
        dialogProps = const DialogProps(),
        menuProps = const MenuProps(),
        modalBottomSheetProps = const ModalBottomSheetProps(),
        super(mode: PopupMode.autocomplete, searchFieldProps: searchFieldProps);

  const MultiSelectionPopupProps.dialog({
    this.dialogProps = const DialogProps(),
    TextFieldProps searchFieldProps = const TextFieldProps(),
    super.fit,
    super.suggestionsProps,
    super.scrollbarProps,
    super.listViewProps,
    super.searchDelay,
    super.itemClickProps,
    super.showSearchBox,
    super.title,
    super.disableFilter,
    super.cacheItems,
    super.itemBuilder,
    super.disabledItemFn,
    super.onDismissed,
    super.emptyBuilder,
    super.errorBuilder,
    super.loadingBuilder,
    super.showSelectedItems,
    super.containerBuilder,
    super.constraints = const BoxConstraints(
      minWidth: 500,
      maxWidth: 500,
      maxHeight: 600,
    ),
    super.interceptCallBacks,
    super.infiniteScrollProps,
    super.onItemsLoaded,
    super.onDisplayed,
    //multi selection props
    super.onItemAdded,
    super.onItemRemoved,
    super.checkBoxBuilder,
    super.validationBuilder,
    super.textDirection = TextDirection.ltr,
  })  : bottomSheetProps = const BottomSheetProps(),
        menuProps = const MenuProps(),
        autoCompleteProps = const AutocompleteProps(),
        modalBottomSheetProps = const ModalBottomSheetProps(),
        super(mode: PopupMode.dialog, searchFieldProps: searchFieldProps);

  const MultiSelectionPopupProps.bottomSheet({
    this.bottomSheetProps = const BottomSheetProps(),
    TextFieldProps searchFieldProps = const TextFieldProps(),
    super.fit,
    super.suggestionsProps,
    super.scrollbarProps,
    super.listViewProps,
    super.searchDelay,
    super.itemClickProps,
    super.showSearchBox,
    super.title,
    super.disableFilter,
    super.cacheItems,
    super.itemBuilder,
    super.disabledItemFn,
    super.onDismissed,
    super.emptyBuilder,
    super.errorBuilder,
    super.loadingBuilder,
    super.showSelectedItems,
    super.containerBuilder,
    super.constraints = const BoxConstraints(maxHeight: 500),
    super.interceptCallBacks,
    super.infiniteScrollProps,
    super.onItemsLoaded,
    super.onDisplayed,
    //multi selection props
    super.onItemAdded,
    super.onItemRemoved,
    super.checkBoxBuilder,
    super.validationBuilder,
    super.textDirection = TextDirection.ltr,
  })  : menuProps = const MenuProps(),
        dialogProps = const DialogProps(),
        autoCompleteProps = const AutocompleteProps(),
        modalBottomSheetProps = const ModalBottomSheetProps(),
        super(mode: PopupMode.bottomSheet, searchFieldProps: searchFieldProps);

  const MultiSelectionPopupProps.modalBottomSheet({
    this.modalBottomSheetProps = const ModalBottomSheetProps(),
    TextFieldProps searchFieldProps = const TextFieldProps(),
    super.fit,
    super.suggestionsProps,
    super.scrollbarProps,
    super.listViewProps,
    super.searchDelay,
    super.itemClickProps,
    super.showSearchBox,
    super.title,
    super.disableFilter,
    super.cacheItems,
    super.itemBuilder,
    super.disabledItemFn,
    super.onDismissed,
    super.emptyBuilder,
    super.errorBuilder,
    super.loadingBuilder,
    super.showSelectedItems,
    super.containerBuilder,
    super.constraints = const BoxConstraints(maxHeight: 500),
    super.interceptCallBacks,
    super.infiniteScrollProps,
    super.onItemsLoaded,
    super.onDisplayed,
    //multi selection props
    super.onItemAdded,
    super.onItemRemoved,
    super.checkBoxBuilder,
    super.validationBuilder,
    super.textDirection = TextDirection.ltr,
  })  : menuProps = const MenuProps(),
        bottomSheetProps = const BottomSheetProps(),
        dialogProps = const DialogProps(),
        autoCompleteProps = const AutocompleteProps(),
        super(
            mode: PopupMode.modalBottomSheet,
            searchFieldProps: searchFieldProps);
}

class PopupProps<T> extends BasePopupProps<T> {
  ///dialog mode props
  final DialogProps dialogProps;

  ///BottomSheet mode props
  final BottomSheetProps bottomSheetProps;

  ///ModalBottomSheet mode props
  final ModalBottomSheetProps modalBottomSheetProps;

  ///Menu mode props
  final MenuProps menuProps;

  ///Menu mode props
  final AutocompleteProps autoCompleteProps;

  const PopupProps.menu({
    this.menuProps = const MenuProps(),
    TextFieldProps searchFieldProps = const TextFieldProps(),
    super.fit,
    super.suggestionsProps,
    super.scrollbarProps,
    super.listViewProps,
    super.searchDelay,
    super.itemClickProps,
    super.showSearchBox,
    super.title,
    super.disableFilter,
    super.cacheItems,
    super.itemBuilder,
    super.disabledItemFn,
    super.onDisplayed,
    super.onDismissed,
    super.emptyBuilder,
    super.errorBuilder,
    super.loadingBuilder,
    super.showSelectedItems,
    super.containerBuilder,
    super.constraints = const BoxConstraints(maxHeight: 350),
    super.interceptCallBacks,
    super.infiniteScrollProps,
    super.onItemsLoaded,
  })  : bottomSheetProps = const BottomSheetProps(),
        dialogProps = const DialogProps(),
        autoCompleteProps = const AutocompleteProps(),
        modalBottomSheetProps = const ModalBottomSheetProps(),
        super(mode: PopupMode.menu, searchFieldProps: searchFieldProps);

  const PopupProps.autocomplete({
    this.autoCompleteProps = const AutocompleteProps(),
    TextFieldProps searchFieldProps = const TextFieldProps(),
    super.fit,
    super.suggestionsProps,
    super.scrollbarProps,
    super.listViewProps,
    super.searchDelay,
    super.itemClickProps,
    super.showSearchBox,
    super.title,
    super.disableFilter,
    super.cacheItems,
    super.itemBuilder,
    super.disabledItemFn,
    super.onDismissed,
    super.emptyBuilder,
    super.errorBuilder,
    super.loadingBuilder,
    super.showSelectedItems,
    super.containerBuilder,
    super.constraints = const BoxConstraints(maxHeight: 350),
    super.interceptCallBacks,
    super.infiniteScrollProps,
    super.onItemsLoaded,
    super.onDisplayed,
  })  : bottomSheetProps = const BottomSheetProps(),
        dialogProps = const DialogProps(),
        menuProps = const MenuProps(),
        modalBottomSheetProps = const ModalBottomSheetProps(),
        super(mode: PopupMode.autocomplete, searchFieldProps: searchFieldProps);

  const PopupProps.dialog({
    this.dialogProps = const DialogProps(),
    TextFieldProps searchFieldProps = const TextFieldProps(),
    super.fit = FlexFit.tight,
    super.suggestionsProps,
    super.scrollbarProps,
    super.listViewProps,
    super.searchDelay,
    super.itemClickProps,
    super.showSearchBox,
    super.title,
    super.disableFilter,
    super.cacheItems,
    super.itemBuilder,
    super.disabledItemFn,
    super.onDismissed,
    super.emptyBuilder,
    super.errorBuilder,
    super.loadingBuilder,
    super.showSelectedItems,
    super.containerBuilder,
    super.constraints = const BoxConstraints(
      minWidth: 500,
      maxWidth: 500,
      maxHeight: 600,
    ),
    super.interceptCallBacks,
    super.infiniteScrollProps,
    super.onItemsLoaded,
    super.onDisplayed,
  })  : bottomSheetProps = const BottomSheetProps(),
        menuProps = const MenuProps(),
        autoCompleteProps = const AutocompleteProps(),
        modalBottomSheetProps = const ModalBottomSheetProps(),
        super(mode: PopupMode.dialog, searchFieldProps: searchFieldProps);

  const PopupProps.modalBottomSheet({
    this.modalBottomSheetProps = const ModalBottomSheetProps(),
    TextFieldProps searchFieldProps = const TextFieldProps(),
    super.fit = FlexFit.tight,
    super.suggestionsProps,
    super.scrollbarProps,
    super.listViewProps,
    super.searchDelay,
    super.itemClickProps,
    super.showSearchBox,
    super.title,
    super.disableFilter,
    super.cacheItems,
    super.itemBuilder,
    super.disabledItemFn,
    super.onDismissed,
    super.emptyBuilder,
    super.errorBuilder,
    super.loadingBuilder,
    super.showSelectedItems,
    super.containerBuilder,
    super.constraints = const BoxConstraints(maxHeight: 500),
    super.interceptCallBacks,
    super.infiniteScrollProps,
    super.onItemsLoaded,
    super.onDisplayed,
  })  : menuProps = const MenuProps(),
        autoCompleteProps = const AutocompleteProps(),
        dialogProps = const DialogProps(),
        bottomSheetProps = const BottomSheetProps(),
        super(
            mode: PopupMode.modalBottomSheet,
            searchFieldProps: searchFieldProps);

  const PopupProps.bottomSheet({
    this.bottomSheetProps = const BottomSheetProps(),
    TextFieldProps searchFieldProps = const TextFieldProps(),
    super.fit = FlexFit.tight,
    super.suggestionsProps,
    super.scrollbarProps,
    super.listViewProps,
    super.searchDelay,
    super.itemClickProps,
    super.showSearchBox,
    super.title,
    super.disableFilter,
    super.cacheItems,
    super.itemBuilder,
    super.disabledItemFn,
    super.onDismissed,
    super.emptyBuilder,
    super.errorBuilder,
    super.loadingBuilder,
    super.showSelectedItems,
    super.containerBuilder,
    super.constraints = const BoxConstraints(maxHeight: 500),
    super.interceptCallBacks,
    super.infiniteScrollProps,
    super.onItemsLoaded,
    super.onDisplayed,
  })  : menuProps = const MenuProps(),
        autoCompleteProps = const AutocompleteProps(),
        modalBottomSheetProps = const ModalBottomSheetProps(),
        dialogProps = const DialogProps(),
        super(mode: PopupMode.bottomSheet, searchFieldProps: searchFieldProps);
}
