import 'package:dropdown_search/src/base_dropdown_search.dart';
import 'package:dropdown_search/src/properties/base_text_field_props.dart';
import 'package:dropdown_search/src/properties/infinite_scroll_props.dart';
import 'package:dropdown_search/src/properties/list_view_props.dart';
import 'package:dropdown_search/src/properties/scrollbar_props.dart';
import 'package:dropdown_search/src/widgets/props/suggestions_props.dart';
import 'package:dropdown_search/src/widgets/props/text_field_props.dart';
import 'package:flutter/material.dart';

import 'inkwell_props.dart';

abstract class BasePopupProps<T> {
  /// popup title
  final Widget? title;

  /// the search box will be shown if true, hidden otherwise
  final bool showSearchBox;

  /// custom UI for the item
  final DropdownSearchPopupItemBuilder<T>? itemBuilder;

  /// object that passes all props to search field
  final BaseTextFieldProps searchFieldProps;

  /// props for selection list view
  final ListViewProps listViewProps;

  /// scrollbar properties
  final ScrollbarProps scrollbarProps;

  /// callback executed before applying value change
  /// delay before searching, change it to Duration(milliseconds: 0)
  /// if you do not use online search
  final Duration searchDelay;

  ///called when popup is dismissed/destroyed
  final VoidCallback? onDismissed;

  ///called when popup is showed/loaded/built
  final VoidCallback? onDisplayed;

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
  final PopupMode mode;

  ///select the selected item in the menu/dialog/bottomSheet of items
  final bool showSelectedItems;

  ///false if the filter on items is applied by the plugin
  ///true if you want to handle by yourself the filtering (data already filtered by DB, API, ....)
  final bool disableFilter;

  ///if true, once all items are loaded, filtering is applied on cached items (no need to re call the API to get items)
  ///[cacheItems] and [disableFilter] could not be both true
  final bool cacheItems;

  ///suggested items props
  final SuggestionsProps<T> suggestionsProps;

  ///fit height depending on nb of result or keep height fix.
  final FlexFit fit;

  ///used as container to the popup widget
  ///this could be very useful if you want to add extra actions/widget to the popup
  ///the popup widget is considered as a child
  final ContainerBuilder? containerBuilder;

  ///used as container to the popup items list
  ///this could be very useful if you want to add some specific decoration to the items container
  final ContainerBuilder? itemsContainerBuilder;

  ///popup constraints
  final BoxConstraints constraints;

  ///if true , the callbacks (onTap, onLongClick...) will be handled by the user
  final bool interceptCallBacks;

  ///infinite scroll params like skip (offset), take,...
  final InfiniteScrollProps? infiniteScrollProps;

  /// called when loading new items
  final ValueChanged<List<T>>? onItemsLoaded;

  ///properties of click
  final ClickProps itemClickProps;

  /*multiSelection props*/

  ///called when a new item added on Multi selection mode
  final OnItemAdded<T>? onItemAdded;

  ///called when a new item added on Multi selection mode
  final OnItemRemoved<T>? onItemRemoved;

  ///widget used to show checked items in multiSelection mode
  final DropdownSearchPopupItemBuilder<T>? checkBoxBuilder;

  ///widget used to validate items in multiSelection mode
  final ValidationMultiSelectionBuilder<T>? validationBuilder;

  ///checkbox multi selection direction
  final TextDirection textDirection;

  const BasePopupProps({
    required this.mode,
    required this.constraints,
    this.fit = FlexFit.tight,
    this.showSearchBox = false,
    this.searchFieldProps = const TextFieldProps(),
    this.suggestionsProps = const SuggestionsProps(),
    this.scrollbarProps = const ScrollbarProps(),
    this.listViewProps = const ListViewProps(),
    this.searchDelay = const Duration(milliseconds: 700),
    this.itemClickProps = const ClickProps(),
    this.title,
    this.onDismissed,
    this.onDisplayed,
    this.emptyBuilder,
    this.itemBuilder,
    this.errorBuilder,
    this.loadingBuilder,
    this.showSelectedItems = false,
    this.disabledItemFn,
    this.disableFilter = false,
    this.cacheItems = false,
    this.containerBuilder,
    this.itemsContainerBuilder,
    this.interceptCallBacks = false,
    this.infiniteScrollProps,
    this.onItemsLoaded,
    //multiSelection props
    this.onItemAdded,
    this.onItemRemoved,
    this.checkBoxBuilder,
    this.validationBuilder,
    this.textDirection = TextDirection.ltr,
  }) : assert(
          !cacheItems || !disableFilter,
          'Caching items will be unuseful if the local filter disableFilter is disabled ',
        );
}
