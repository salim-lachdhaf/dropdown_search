import 'package:flutter/material.dart';

import '../../dropdown_search.dart';

class PopupProps<T> {
  final PositionCallback? positionCallback;
  final double? elevation;
  final String? semanticLabel;
  final ShapeBorder? shape;
  final Color? barrierColor;
  final String barrierLabel;
  final Color? backgroundColor;
  final bool enableDrag;
  final bool barrierDismissible;
  final Duration transitionDuration;
  final AnimationController? animation;
  final Curve? barrierCurve;
  final bool borderOnForeground;
  final Clip clipBehavior;
  final BorderRadiusGeometry? borderRadius;
  final TextStyle? textStyle;
  final Color? shadowColor;
  final Widget? title;
  final bool showSearchBox;
  final bool useRootNavigator;
  final BoxConstraints? constraints;

  final DropdownSearchPopupItemBuilder<T>? itemBuilder;

  /// object that passes all props to search field
  final TextFieldProps searchFieldProps;

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

  /// props for selection list view
  final ListViewProps listViewProps;

  /// scrollbar properties
  final ScrollbarProps? scrollbarProps;

  ///show or hide favorites items
  final bool showFavoriteItems;

  ///to customize favorites chips
  final FavoriteItemsBuilder<T>? favoriteItemBuilder;

  ///favorites items list
  final FavoriteItems<T>? favoriteItems;

  ///favorite items alignment
  final MainAxisAlignment favoriteItemsAlignment;

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

  ///to customize selected item
  final DropdownSearchPopupItemBuilder<T>? popupItemBuilder;

  ///defines if an item of the popup is enabled or not, if the item is disabled,
  ///it cannot be clicked
  final DropdownSearchPopupItemEnabled<T>? disabledItemFn;

  ///MENU / DIALOG/ BOTTOM_SHEET
  final Mode mode;

  ///select the selected item in the menu/dialog/bottomSheet of items
  final bool showSelectedItems;

  final bool isFilterOnline;

  /// props for selection focus node
  final FocusNode? focusNode;

  const PopupProps({
    this.mode = Mode.MENU,
    this.enableDrag = true,
    this.title,
    this.focusNode,
    this.isFilterOnline = false,
    this.positionCallback,
    this.itemBuilder,
    this.elevation,
    this.semanticLabel,
    this.shape,
    this.barrierColor,
    this.barrierLabel = '',
    this.backgroundColor,
    this.barrierDismissible = true,
    this.transitionDuration = kThemeChangeDuration,
    this.disabledItemFn,
    this.animation,
    this.barrierCurve,
    this.shadowColor,
    this.textStyle,
    this.borderRadius,
    this.borderOnForeground = true,
    this.clipBehavior = Clip.none,
    this.showSearchBox = false,
    this.searchFieldProps = const TextFieldProps(),
    this.scrollbarProps,
    this.listViewProps = const ListViewProps(),
    this.favoriteItemBuilder,
    this.favoriteItems,
    this.favoriteItemsAlignment = MainAxisAlignment.start,
    this.showFavoriteItems = false,
    this.searchDelay,
    this.onDismissed,
    this.emptyBuilder,
    this.errorBuilder,
    this.loadingBuilder,
    this.popupItemBuilder,
    this.showSelectedItems = false,
    this.useRootNavigator = false,
    this.constraints,
  })  : this.popupOnItemAdded = null,
        this.popupOnItemRemoved = null,
        this.popupSelectionWidget = null,
        this.popupValidationMultiSelectionWidget = null,
        this.popupCustomMultiSelectionWidget = null;

  const PopupProps.multiSelection({
    this.mode = Mode.MENU,
    this.title,
    this.positionCallback,
    this.enableDrag = true,
    this.elevation,
    this.semanticLabel,
    this.shape,
    this.barrierColor,
    this.focusNode,
    this.barrierLabel = '',
    this.backgroundColor,
    this.barrierDismissible = true,
    this.transitionDuration = kThemeChangeDuration,
    this.animation,
    this.barrierCurve,
    this.shadowColor,
    this.textStyle,
    this.borderRadius,
    this.borderOnForeground = true,
    this.clipBehavior = Clip.none,
    this.showSearchBox = false,
    this.searchFieldProps = const TextFieldProps(),
    this.scrollbarProps,
    this.listViewProps = const ListViewProps(),
    this.popupCustomMultiSelectionWidget,
    this.popupOnItemAdded,
    this.popupOnItemRemoved,
    this.popupSelectionWidget,
    this.popupValidationMultiSelectionWidget,
    this.favoriteItemBuilder,
    this.favoriteItems,
    this.favoriteItemsAlignment = MainAxisAlignment.start,
    this.showFavoriteItems = false,
    this.searchDelay,
    this.onDismissed,
    this.emptyBuilder,
    this.itemBuilder,
    this.errorBuilder,
    this.loadingBuilder,
    this.popupItemBuilder,
    this.showSelectedItems = false,
    this.useRootNavigator = false,
    this.constraints,
    this.disabledItemFn,
    this.isFilterOnline = false,
  });
}
