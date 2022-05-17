import 'package:flutter/material.dart';

import '../../dropdown_search.dart';

class PopupProps<T> {
  final TextStyle? textStyle;
  final Widget? title;
  final bool showSearchBox;

  final DropdownSearchPopupItemBuilder<T>? itemBuilder;

  /// object that passes all props to search field
  final TextFieldProps searchFieldProps;

  /// props for selection list view
  final ListViewProps listViewProps;

  /// scrollbar properties
  final ScrollbarProps scrollbarProps;

  /// callback executed before applying value change
  ///delay before searching, change it to Duration(milliseconds: 0)
  ///if you do not use online search
  final Duration? searchDelay;

  ///called when popup is dismissed
  final VoidCallback? onDismissed;

  ///custom layout for empty results
  final EmptyBuilder? emptyBuilder;

  ///custom layout for loading items
  final LoadingBuilder? loadingBuilder;

  ///custom layout for error
  final ErrorBuilder? errorBuilder;

  ///defines if an item of the popup is enabled or not, if the item is disabled,
  ///it cannot be clicked
  final DropdownSearchPopupItemEnabled<T>? disabledItemFn;

  ///popup mode
  final Mode mode;

  ///select the selected item in the menu/dialog/bottomSheet of items
  final bool showSelectedItems;

  ///true if the filter on items is applied onlie (via API/DB/...)
  final bool isFilterOnline;

  ///favorite items props
  final FavoriteItemProps<T> favoriteItemProps;

  ///dialog mode props
  final DialogProps dialogProps;

  ///BottomSheet mode props
  final BottomSheetProps bottomSheetProps;

  ///ModalBottomSheet mode props
  final ModalBottomSheetProps modalBottomSheetProps;

  ///Menu mode props
  final MenuProps menuProps;

  ///fit height depending on nb of result or keep height fix.
  final FlexFit fit;

  const PopupProps._({
    this.mode = Mode.MENU,
    this.fit = FlexFit.tight,
    this.title,
    this.textStyle,
    this.showSearchBox = false,
    this.bottomSheetProps = const BottomSheetProps(),
    this.dialogProps = const DialogProps(),
    this.modalBottomSheetProps = const ModalBottomSheetProps(),
    this.menuProps = const MenuProps(),
    this.searchFieldProps = const TextFieldProps(),
    this.scrollbarProps = const ScrollbarProps(),
    this.listViewProps = const ListViewProps(),
    this.favoriteItemProps = const FavoriteItemProps(),
    this.searchDelay,
    this.onDismissed,
    this.emptyBuilder,
    this.itemBuilder,
    this.errorBuilder,
    this.loadingBuilder,
    this.showSelectedItems = false,
    this.disabledItemFn,
    this.isFilterOnline = false,
  });

  const PopupProps.menu({
    this.title,
    this.fit = FlexFit.tight,
    this.textStyle,
    this.showSearchBox = false,
    this.menuProps = const MenuProps(),
    this.searchFieldProps = const TextFieldProps(),
    this.scrollbarProps = const ScrollbarProps(),
    this.listViewProps = const ListViewProps(),
    this.favoriteItemProps = const FavoriteItemProps(),
    this.searchDelay,
    this.onDismissed,
    this.emptyBuilder,
    this.itemBuilder,
    this.errorBuilder,
    this.loadingBuilder,
    this.showSelectedItems = false,
    this.disabledItemFn,
    this.isFilterOnline = false,
  })  : this.mode = Mode.MENU,
        this.bottomSheetProps = const BottomSheetProps(),
        this.dialogProps = const DialogProps(),
        this.modalBottomSheetProps = const ModalBottomSheetProps();

  const PopupProps.dialog({
    this.textStyle,
    this.fit = FlexFit.tight,
    this.title,
    this.showSearchBox = false,
    this.dialogProps = const DialogProps(),
    this.searchFieldProps = const TextFieldProps(),
    this.scrollbarProps = const ScrollbarProps(),
    this.listViewProps = const ListViewProps(),
    this.favoriteItemProps = const FavoriteItemProps(),
    this.searchDelay,
    this.onDismissed,
    this.emptyBuilder,
    this.itemBuilder,
    this.errorBuilder,
    this.loadingBuilder,
    this.showSelectedItems = false,
    this.disabledItemFn,
    this.isFilterOnline = false,
  })  : this.mode = Mode.DIALOG,
        this.menuProps = const MenuProps(),
        this.bottomSheetProps = const BottomSheetProps(),
        this.modalBottomSheetProps = const ModalBottomSheetProps();

  const PopupProps.bottomSheet({
    this.textStyle,
    this.fit = FlexFit.tight,
    this.title,
    this.showSearchBox = false,
    this.bottomSheetProps = const BottomSheetProps(),
    this.searchFieldProps = const TextFieldProps(),
    this.scrollbarProps = const ScrollbarProps(),
    this.listViewProps = const ListViewProps(),
    this.favoriteItemProps = const FavoriteItemProps(),
    this.searchDelay,
    this.onDismissed,
    this.emptyBuilder,
    this.itemBuilder,
    this.errorBuilder,
    this.loadingBuilder,
    this.showSelectedItems = false,
    this.disabledItemFn,
    this.isFilterOnline = false,
  })  : this.mode = Mode.BOTTOM_SHEET,
        this.menuProps = const MenuProps(),
        this.dialogProps = const DialogProps(),
        this.modalBottomSheetProps = const ModalBottomSheetProps();

  const PopupProps.modalBottomSheet({
    this.title,
    this.textStyle,
    this.fit = FlexFit.tight,
    this.showSearchBox = false,
    this.modalBottomSheetProps = const ModalBottomSheetProps(),
    this.searchFieldProps = const TextFieldProps(),
    this.scrollbarProps = const ScrollbarProps(),
    this.listViewProps = const ListViewProps(),
    this.favoriteItemProps = const FavoriteItemProps(),
    this.searchDelay,
    this.onDismissed,
    this.emptyBuilder,
    this.itemBuilder,
    this.errorBuilder,
    this.loadingBuilder,
    this.showSelectedItems = false,
    this.disabledItemFn,
    this.isFilterOnline = false,
  })  : this.mode = Mode.MODAL_BOTTOM_SHEET,
        this.menuProps = const MenuProps(),
        this.dialogProps = const DialogProps(),
        this.bottomSheetProps = const BottomSheetProps();
}

class PopupPropsMultiSelection<T> extends PopupProps<T> {
  ///called when a new item added on Multi selection mode
  final OnItemAdded<T>? popupOnItemAdded;

  ///called when a new item added on Multi selection mode
  final OnItemRemoved<T>? popupOnItemRemoved;

  ///widget used to show checked items in multiSelection mode
  final DropdownSearchPopupItemBuilder<T>? popupSelectionWidget;

  ///widget used to validate items in multiSelection mode
  final ValidationMultiSelectionBuilder<T>? popupValidationMultiSelectionWidget;

  ///widget to add custom widget like addAll/removeAll on popup multi selection mode
  final ValidationMultiSelectionBuilder<T>? popupCustomMultiSelectionWidget;

  const PopupPropsMultiSelection._({
    super.mode = Mode.MENU,
    super.fit = FlexFit.tight,
    super.title,
    super.isFilterOnline,
    super.itemBuilder,
    super.disabledItemFn,
    super.textStyle,
    super.showSearchBox,
    super.searchFieldProps = const TextFieldProps(),
    super.favoriteItemProps = const FavoriteItemProps(),
    super.modalBottomSheetProps = const ModalBottomSheetProps(),
    super.scrollbarProps = const ScrollbarProps(),
    super.listViewProps = const ListViewProps(),
    super.searchDelay,
    super.onDismissed,
    super.emptyBuilder,
    super.errorBuilder,
    super.loadingBuilder,
    super.showSelectedItems,
    super.bottomSheetProps = const BottomSheetProps(),
    super.dialogProps = const DialogProps(),
    super.menuProps = const MenuProps(),
    this.popupCustomMultiSelectionWidget,
    this.popupOnItemAdded,
    this.popupOnItemRemoved,
    this.popupSelectionWidget,
    this.popupValidationMultiSelectionWidget,
  }) : super._();

  const PopupPropsMultiSelection.menu({
    super.title,
    super.textStyle,
    super.fit = FlexFit.tight,
    super.showSearchBox = false,
    super.searchFieldProps = const TextFieldProps(),
    super.menuProps = const MenuProps(),
    super.favoriteItemProps = const FavoriteItemProps(),
    super.scrollbarProps = const ScrollbarProps(),
    super.listViewProps = const ListViewProps(),
    super.searchDelay,
    super.onDismissed,
    super.emptyBuilder,
    super.itemBuilder,
    super.errorBuilder,
    super.loadingBuilder,
    super.showSelectedItems = false,
    super.disabledItemFn,
    super.isFilterOnline = false,
    this.popupCustomMultiSelectionWidget,
    this.popupOnItemAdded,
    this.popupOnItemRemoved,
    this.popupSelectionWidget,
    this.popupValidationMultiSelectionWidget,
  }) : super.menu();

  const PopupPropsMultiSelection.dialog({
    super.title,
    super.textStyle,
    super.fit = FlexFit.tight,
    super.showSearchBox = false,
    super.searchFieldProps = const TextFieldProps(),
    super.scrollbarProps = const ScrollbarProps(),
    super.listViewProps = const ListViewProps(),
    super.favoriteItemProps = const FavoriteItemProps(),
    super.dialogProps = const DialogProps(),
    super.searchDelay,
    super.onDismissed,
    super.emptyBuilder,
    super.itemBuilder,
    super.errorBuilder,
    super.loadingBuilder,
    super.showSelectedItems = false,
    super.disabledItemFn,
    super.isFilterOnline = false,
    this.popupCustomMultiSelectionWidget,
    this.popupOnItemAdded,
    this.popupOnItemRemoved,
    this.popupSelectionWidget,
    this.popupValidationMultiSelectionWidget,
  }) : super.dialog();

  const PopupPropsMultiSelection.bottomSheet({
    super.title,
    super.textStyle,
    super.fit = FlexFit.tight,
    super.showSearchBox = false,
    super.searchFieldProps = const TextFieldProps(),
    super.listViewProps = const ListViewProps(),
    super.favoriteItemProps = const FavoriteItemProps(),
    super.bottomSheetProps = const BottomSheetProps(),
    super.scrollbarProps = const ScrollbarProps(),
    super.searchDelay,
    super.onDismissed,
    super.emptyBuilder,
    super.itemBuilder,
    super.errorBuilder,
    super.loadingBuilder,
    super.showSelectedItems = false,
    super.disabledItemFn,
    super.isFilterOnline = false,
    this.popupCustomMultiSelectionWidget,
    this.popupOnItemAdded,
    this.popupOnItemRemoved,
    this.popupSelectionWidget,
    this.popupValidationMultiSelectionWidget,
  }) : super.bottomSheet();

  const PopupPropsMultiSelection.modalBottomSheet({
    super.title,
    super.isFilterOnline,
    super.fit = FlexFit.tight,
    super.itemBuilder,
    super.disabledItemFn,
    super.textStyle,
    super.showSearchBox,
    super.searchFieldProps = const TextFieldProps(),
    super.favoriteItemProps = const FavoriteItemProps(),
    super.modalBottomSheetProps = const ModalBottomSheetProps(),
    super.scrollbarProps = const ScrollbarProps(),
    super.listViewProps = const ListViewProps(),
    super.searchDelay,
    super.onDismissed,
    super.emptyBuilder,
    super.errorBuilder,
    super.loadingBuilder,
    super.showSelectedItems,
    this.popupCustomMultiSelectionWidget,
    this.popupOnItemAdded,
    this.popupOnItemRemoved,
    this.popupSelectionWidget,
    this.popupValidationMultiSelectionWidget,
  }) : super.modalBottomSheet();

  PopupPropsMultiSelection.from(PopupProps<T> popupProps)
      : this._(
          title: popupProps.title,
          fit: popupProps.fit,
          favoriteItemProps: popupProps.favoriteItemProps,
          disabledItemFn: popupProps.disabledItemFn,
          emptyBuilder: popupProps.emptyBuilder,
          errorBuilder: popupProps.errorBuilder,
          isFilterOnline: popupProps.isFilterOnline,
          itemBuilder: popupProps.itemBuilder,
          listViewProps: popupProps.listViewProps,
          loadingBuilder: popupProps.loadingBuilder,
          modalBottomSheetProps: popupProps.modalBottomSheetProps,
          onDismissed: popupProps.onDismissed,
          scrollbarProps: popupProps.scrollbarProps,
          searchDelay: popupProps.searchDelay,
          searchFieldProps: popupProps.searchFieldProps,
          showSearchBox: popupProps.showSearchBox,
          showSelectedItems: popupProps.showSelectedItems,
          textStyle: popupProps.textStyle,
          mode: popupProps.mode,
          bottomSheetProps: popupProps.bottomSheetProps,
          dialogProps: popupProps.dialogProps,
          menuProps: popupProps.menuProps,
          popupCustomMultiSelectionWidget: null,
          popupOnItemAdded: null,
          popupOnItemRemoved: null,
          popupSelectionWidget: null,
          popupValidationMultiSelectionWidget: null,
        );
}
