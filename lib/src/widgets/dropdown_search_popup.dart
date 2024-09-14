import 'dart:async';

import 'package:dropdown_search/src/widgets/custom_inkwell.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../dropdown_search.dart';
import 'checkbox_widget.dart';
import 'custom_scroll_view.dart';

class DropdownSearchPopup<T> extends StatefulWidget {
  final ValueChanged<List<T>>? onChanged;
  final DropdownSearchOnFind<T>? items;
  final DropdownSearchItemAsString<T>? itemAsString;
  final DropdownSearchFilterFn<T>? filterFn;
  final DropdownSearchCompareFn<T>? compareFn;
  final List<T> defaultSelectedItems;
  final PopupPropsMultiSelection<T> popupProps;
  final bool isMultiSelectionMode;

  const DropdownSearchPopup({
    super.key,
    required this.popupProps,
    this.defaultSelectedItems = const [],
    this.isMultiSelectionMode = false,
    this.onChanged,
    this.items,
    this.itemAsString,
    this.filterFn,
    this.compareFn,
  });

  @override
  DropdownSearchPopupState<T> createState() => DropdownSearchPopupState<T>();
}

class DropdownSearchPopupState<T> extends State<DropdownSearchPopup<T>> {
  final StreamController<List<T>> _itemsStream = StreamController.broadcast();
  final ValueNotifier<bool> _loadingNotifier = ValueNotifier(false);
  final List<T> _cachedItems = [];
  final ValueNotifier<List<T>> _selectedItemsNotifier = ValueNotifier([]);
  final ScrollController scrollController = ScrollController();
  final List<T> _currentShowedItems = [];
  late TextEditingController searchBoxController;
  late bool isInfiniteScrollEnded;

  List<T> get _selectedItems => _selectedItemsNotifier.value;
  Timer? _debounce;
  String lastSearchText = '';

  void searchBoxControllerListener() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();

    //handle case when editText get focused, onTextChange was called !
    if (lastSearchText == searchBoxController.text) return;

    _debounce = Timer(widget.popupProps.searchDelay, () {
      lastSearchText = searchBoxController.text;
      _manageLoadItems(searchBoxController.text);
    });
  }

  @override
  void initState() {
    super.initState();
    _selectedItemsNotifier.value = widget.defaultSelectedItems;

    searchBoxController = widget.popupProps.searchFieldProps.controller ??
        TextEditingController();
    searchBoxController.addListener(searchBoxControllerListener);

    lastSearchText = searchBoxController.text;

    isInfiniteScrollEnded = widget.popupProps.infiniteScrollProps == null;

    Future.delayed(
      Duration.zero,
      () => _manageLoadItems(searchBoxController.text, isFirstLoad: true),
    );
  }

  @override
  void didUpdateWidget(covariant DropdownSearchPopup<T> oldWidget) {
    if (!listEquals(
        oldWidget.defaultSelectedItems, widget.defaultSelectedItems)) {
      _selectedItemsNotifier.value = widget.defaultSelectedItems;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _itemsStream.close();
    _debounce?.cancel();

    if (widget.popupProps.searchFieldProps.controller == null) {
      searchBoxController.dispose();
    } else {
      searchBoxController.removeListener(searchBoxControllerListener);
    }

    if (widget.popupProps.listViewProps.controller == null) {
      scrollController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: widget.popupProps.constraints,
      child: widget.popupProps.containerBuilder == null
          ? _defaultWidget()
          : widget.popupProps.containerBuilder!(context, _defaultWidget()),
    );
  }

  Widget _defaultWidget() {
    return Material(
      type: MaterialType.transparency,
      child: ValueListenableBuilder(
          valueListenable: _selectedItemsNotifier,
          builder: (ctx, value, w) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                _searchField(),
                _suggestedItemsWidget(),
                Flexible(
                  fit: widget.popupProps.fit,
                  child: Stack(
                    children: <Widget>[
                      StreamBuilder<List<T>>(
                        stream: _itemsStream.stream,
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return _errorWidget(snapshot.error);
                          } else if (!snapshot.hasData) {
                            return _loadingWidget();
                          } else if (snapshot.data!.isEmpty) {
                            return _noDataWidget();
                          }

                          final itemCount = snapshot.data!.length;
                          return RawScrollbar(
                            key:  widget.popupProps.scrollbarProps.key,
                            controller:
                                widget.popupProps.listViewProps.controller ??
                                    scrollController,
                            thumbVisibility: widget
                                .popupProps.scrollbarProps.thumbVisibility,
                            trackVisibility: widget
                                .popupProps.scrollbarProps.trackVisibility,
                            thickness:
                                widget.popupProps.scrollbarProps.thickness,
                            radius: widget.popupProps.scrollbarProps.radius,
                            notificationPredicate: widget.popupProps
                                .scrollbarProps.notificationPredicate,
                            interactive:
                                widget.popupProps.scrollbarProps.interactive,
                            scrollbarOrientation: widget
                                .popupProps.scrollbarProps.scrollbarOrientation,
                            thumbColor:
                                widget.popupProps.scrollbarProps.thumbColor,
                            fadeDuration:
                                widget.popupProps.scrollbarProps.fadeDuration,
                            crossAxisMargin: widget
                                .popupProps.scrollbarProps.crossAxisMargin,
                            mainAxisMargin:
                                widget.popupProps.scrollbarProps.mainAxisMargin,
                            minOverscrollLength: widget
                                .popupProps.scrollbarProps.minOverscrollLength,
                            minThumbLength:
                                widget.popupProps.scrollbarProps.minThumbLength,
                            pressDuration:
                                widget.popupProps.scrollbarProps.pressDuration,
                            shape: widget.popupProps.scrollbarProps.shape,
                            timeToFade:
                                widget.popupProps.scrollbarProps.timeToFade,
                            trackBorderColor: widget
                                .popupProps.scrollbarProps.trackBorderColor,
                            trackColor:
                                widget.popupProps.scrollbarProps.trackColor,
                            trackRadius:
                                widget.popupProps.scrollbarProps.trackRadius,
                            padding: widget.popupProps.scrollbarProps.padding,
                            child: ScrollConfiguration(
                              behavior: ScrollConfiguration.of(context)
                                  .copyWith(scrollbars: false),
                              child: ListView.builder(
                                key: widget
                                    .popupProps.listViewProps.key,
                                hitTestBehavior: widget
                                    .popupProps.listViewProps.hitTestBehavior,
                                controller: widget
                                        .popupProps.listViewProps.controller ??
                                    scrollController,
                                shrinkWrap:
                                    widget.popupProps.listViewProps.shrinkWrap,
                                padding:
                                    widget.popupProps.listViewProps.padding,
                                scrollDirection: widget
                                    .popupProps.listViewProps.scrollDirection,
                                reverse:
                                    widget.popupProps.listViewProps.reverse,
                                primary:
                                    widget.popupProps.listViewProps.primary,
                                physics:
                                    widget.popupProps.listViewProps.physics,
                                itemExtent:
                                    widget.popupProps.listViewProps.itemExtent,
                                addAutomaticKeepAlives: widget.popupProps
                                    .listViewProps.addAutomaticKeepAlives,
                                addRepaintBoundaries: widget.popupProps
                                    .listViewProps.addRepaintBoundaries,
                                addSemanticIndexes: widget.popupProps
                                    .listViewProps.addSemanticIndexes,
                                cacheExtent:
                                    widget.popupProps.listViewProps.cacheExtent,
                                semanticChildCount: widget.popupProps
                                    .listViewProps.semanticChildCount,
                                dragStartBehavior: widget
                                    .popupProps.listViewProps.dragStartBehavior,
                                keyboardDismissBehavior: widget.popupProps
                                    .listViewProps.keyboardDismissBehavior,
                                restorationId: widget
                                    .popupProps.listViewProps.restorationId,
                                clipBehavior: widget
                                    .popupProps.listViewProps.clipBehavior,
                                prototypeItem: widget
                                    .popupProps.listViewProps.prototypeItem,
                                itemExtentBuilder: widget
                                    .popupProps.listViewProps.itemExtentBuilder,
                                findChildIndexCallback: widget.popupProps
                                    .listViewProps.findChildIndexCallback,
                                itemCount:
                                    itemCount + (isInfiniteScrollEnded ? 0 : 1),
                                itemBuilder: (context, index) {
                                  if (index < itemCount) {
                                    var item = snapshot.data![index];
                                    return widget.isMultiSelectionMode
                                        ? _itemWidgetMultiSelection(item)
                                        : _itemWidgetSingleSelection(item);
                                  }
                                  //if infiniteScroll enabled && data received not less then take request
                                  else if (!isInfiniteScrollEnded) {
                                    _manageLoadMoreItems(
                                        searchBoxController.text,
                                        skip: itemCount,
                                        showLoading: false);
                                    return _infiniteScrollLoadingMoreWidget(
                                        itemCount);
                                  }

                                  return SizedBox.shrink();
                                },
                              ),
                            ),
                          );
                        },
                      ),
                      _loadingWidget()
                    ],
                  ),
                ),
                _multiSelectionValidation(),
              ],
            );
          }),
    );
  }

  Widget _infiniteScrollLoadingMoreWidget(int loadedItems) {
    if (widget.popupProps.infiniteScrollProps?.loadingMoreBuilder != null) {
      return widget.popupProps.infiniteScrollProps!.loadingMoreBuilder!(
          context, loadedItems);
    }
    return const Center(child: CircularProgressIndicator());
  }

  ///validation of selected items
  void onValidate() {
    closePopup();
    if (widget.onChanged != null) widget.onChanged!(_selectedItems);
  }

  Widget _multiSelectionValidation() {
    if (!widget.isMultiSelectionMode) return SizedBox.shrink();

    Widget defaultValidation = Padding(
      padding: EdgeInsets.all(8),
      child: Align(
        alignment: Alignment.centerRight,
        child: ElevatedButton(
          onPressed: onValidate,
          child: Text("OK"),
        ),
      ),
    );

    if (widget.popupProps.validationBuilder != null) {
      return widget.popupProps.validationBuilder!(context, _selectedItems);
    }

    return defaultValidation;
  }

  Widget _noDataWidget() {
    if (widget.popupProps.emptyBuilder != null) {
      return widget.popupProps.emptyBuilder!(context, searchBoxController.text);
    }

    return Container(
      height: 70,
      alignment: Alignment.center,
      child: Text("No data found"),
    );
  }

  Widget _errorWidget(dynamic error) {
    if (widget.popupProps.errorBuilder != null) {
      return widget.popupProps.errorBuilder!(
        context,
        searchBoxController.text,
        error,
      );
    }

    return Container(
      alignment: Alignment.center,
      child: Text(
        error?.toString() ?? 'Unknown Error',
      ),
    );
  }

  Widget _loadingWidget() {
    return ValueListenableBuilder(
        valueListenable: _loadingNotifier,
        builder: (context, bool isLoading, wid) {
          if (isLoading) {
            if (widget.popupProps.loadingBuilder != null) {
              return widget.popupProps.loadingBuilder!(
                context,
                searchBoxController.text,
              );
            }

            return Container(
              height: 70,
              alignment: Alignment.center,
              child: const CircularProgressIndicator(),
            );
          }
          return const SizedBox.shrink();
        });
  }

  List<T> _applyFilter(String filter) {
    return _cachedItems.where((i) {
      if (widget.filterFn != null) {
        return (widget.filterFn!(i, filter));
      } else if (i.toString().toLowerCase().contains(filter.toLowerCase())) {
        return true;
      } else if (widget.itemAsString != null) {
        return (widget.itemAsString!(i))
            .toLowerCase()
            .contains(filter.toLowerCase());
      }
      return false;
    }).toList();
  }

  Future<void> _manageLoadItems(
    String filter, {
    bool isFirstLoad = false,
  }) async {
    //if the filter is not handled by user, we load full list once
    if (!widget.popupProps.cacheItems) _cachedItems.clear();

    //case filtering locally (no need to load new data)
    if (!isFirstLoad &&
        !widget.popupProps.disableFilter &&
        widget.popupProps.cacheItems &&
        isInfiniteScrollEnded) {
      _addDataToStream(_applyFilter(filter));
      return;
    }

    return _manageLoadMoreItems(filter);
  }

  Future<void> _manageLoadMoreItems(
    String filter, {
    int? skip,
    bool showLoading = true,
  }) async {
    if (widget.items == null) return;

    final loadProps = widget.popupProps.infiniteScrollProps?.loadProps;

    if (showLoading) {
      _loadingNotifier.value = true;
    }

    try {
      final List<T> myItems =
          await widget.items!(filter, loadProps?.copy(skip: skip));

      if (loadProps != null) {
        isInfiniteScrollEnded = myItems.length < loadProps.take;
      }

      //add new online items to cache list
      _cachedItems.addAll(myItems);

      //manage data filtering
      if (widget.popupProps.disableFilter) {
        _addDataToStream(_cachedItems);
      } else {
        _addDataToStream(_applyFilter(filter));
      }
    } catch (e) {
      _setErrorToStream(e);
    }

    if (showLoading) {
      _loadingNotifier.value = false;
    }
  }

  void _addDataToStream(List<T> data) {
    if (_itemsStream.isClosed) return;
    _itemsStream.add(data);

    //update showed data list
    _currentShowedItems.clear();
    _currentShowedItems.addAll(data);

    if (widget.popupProps.onItemsLoaded != null) {
      widget.popupProps.onItemsLoaded!(data);
    }
  }

  void _setErrorToStream(Object error, [StackTrace? stackTrace]) {
    if (_itemsStream.isClosed) return;
    _itemsStream.addError(error, stackTrace);
  }

  Widget _itemWidgetSingleSelection(T item) {
    if (widget.popupProps.itemBuilder != null) {
      var w = widget.popupProps.itemBuilder!(
        context,
        item,
        _isDisabled(item),
        !widget.popupProps.showSelectedItems ? false : _isSelectedItem(item),
      );

      if (widget.popupProps.interceptCallBacks) return w;

      return CustomInkWell(
        clickProps: widget.popupProps.itemClickProps,
        onTap: _isDisabled(item) ? null : () => _handleSelectedItem(item),
        child: IgnorePointer(child: w),
      );
    } else {
      return ListTile(
        enabled: !_isDisabled(item),
        title: Text(_selectedItemAsString(item)),
        selected: !widget.popupProps.showSelectedItems
            ? false
            : _isSelectedItem(item),
        onTap: _isDisabled(item) ? null : () => _handleSelectedItem(item),
      );
    }
  }

  Widget _itemWidgetMultiSelection(T item) {
    if (widget.popupProps.checkBoxBuilder != null) {
      return CheckBoxWidget(
        clickProps: widget.popupProps.itemClickProps,
        checkBox: (cxt, checked) {
          return widget.popupProps.checkBoxBuilder!(
              cxt, item, _isDisabled(item), checked);
        },
        interceptCallBacks: widget.popupProps.interceptCallBacks,
        textDirection: widget.popupProps.textDirection,
        layout: (context, isChecked) => _itemWidgetSingleSelection(item),
        isChecked: _isSelectedItem(item),
        isDisabled: _isDisabled(item),
        onChanged: (c) => _handleSelectedItem(item),
      );
    } else {
      return CheckBoxWidget(
        clickProps: widget.popupProps.itemClickProps,
        textDirection: widget.popupProps.textDirection,
        interceptCallBacks: widget.popupProps.interceptCallBacks,
        layout: (context, isChecked) => _itemWidgetSingleSelection(item),
        isChecked: _isSelectedItem(item),
        isDisabled: _isDisabled(item),
        onChanged: (c) => _handleSelectedItem(item),
      );
    }
  }

  bool _isDisabled(T item) =>
      widget.popupProps.disabledItemFn != null &&
      (widget.popupProps.disabledItemFn!(item)) == true;

  /// selected item will be highlighted only when [widget.showSelectedItems] is true,
  /// if our object is String [widget.compareFn] is not required , other wises it's required
  bool _isSelectedItem(T item) => _itemIndexInList(_selectedItems, item) > -1;

  ///test if list has an item T
  ///if contains return index of item in the list, -1 otherwise
  int _itemIndexInList(List<T> list, T item) =>
      list.indexWhere((i) => _isEqual(i, item));

  ///compared two items base on user params
  bool _isEqual(T i1, T i2) {
    if (widget.compareFn != null) {
      return widget.compareFn!(i1, i2);
    } else {
      return i1 == i2;
    }
  }

  Widget _searchField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        widget.popupProps.title ?? const SizedBox.shrink(),
        if (widget.popupProps.showSearchBox)
          Padding(
            padding: widget.popupProps.searchFieldProps.padding,
            child: DefaultTextEditingShortcuts(
              child: Shortcuts(
                shortcuts: const <ShortcutActivator, Intent>{
                  SingleActivator(LogicalKeyboardKey.space):
                      DoNothingAndStopPropagationTextIntent(),
                },
                child: TextField(
                  key: widget.popupProps.searchFieldProps.key,
                  onChanged: widget.popupProps.searchFieldProps.onChanged,
                  onEditingComplete: widget.popupProps.searchFieldProps.onEditingComplete,
                  onSubmitted: widget.popupProps.searchFieldProps.onSubmitted,
                  onTapAlwaysCalled: widget.popupProps.searchFieldProps.onTapAlwaysCalled,
                  enableIMEPersonalizedLearning: widget.popupProps
                      .searchFieldProps.enableIMEPersonalizedLearning,
                  clipBehavior: widget.popupProps.searchFieldProps.clipBehavior,
                  style: widget.popupProps.searchFieldProps.style,
                  controller: searchBoxController,
                  focusNode: widget.popupProps.searchFieldProps.focusNode,
                  autofocus: widget.popupProps.searchFieldProps.autofocus,
                  decoration: widget.popupProps.searchFieldProps.decoration,
                  keyboardType: widget.popupProps.searchFieldProps.keyboardType,
                  textInputAction:
                      widget.popupProps.searchFieldProps.textInputAction,
                  textCapitalization:
                      widget.popupProps.searchFieldProps.textCapitalization,
                  strutStyle: widget.popupProps.searchFieldProps.strutStyle,
                  textAlign: widget.popupProps.searchFieldProps.textAlign,
                  textAlignVertical:
                      widget.popupProps.searchFieldProps.textAlignVertical,
                  textDirection:
                      widget.popupProps.searchFieldProps.textDirection,
                  readOnly: widget.popupProps.searchFieldProps.readOnly,
                  contextMenuBuilder:
                      widget.popupProps.searchFieldProps.contextMenuBuilder,
                  showCursor: widget.popupProps.searchFieldProps.showCursor,
                  obscuringCharacter:
                      widget.popupProps.searchFieldProps.obscuringCharacter,
                  obscureText: widget.popupProps.searchFieldProps.obscureText,
                  autocorrect: widget.popupProps.searchFieldProps.autocorrect,
                  smartDashesType:
                      widget.popupProps.searchFieldProps.smartDashesType,
                  smartQuotesType:
                      widget.popupProps.searchFieldProps.smartQuotesType,
                  enableSuggestions:
                      widget.popupProps.searchFieldProps.enableSuggestions,
                  maxLines: widget.popupProps.searchFieldProps.maxLines,
                  minLines: widget.popupProps.searchFieldProps.minLines,
                  expands: widget.popupProps.searchFieldProps.expands,
                  maxLengthEnforcement:
                      widget.popupProps.searchFieldProps.maxLengthEnforcement,
                  maxLength: widget.popupProps.searchFieldProps.maxLength,
                  onAppPrivateCommand:
                      widget.popupProps.searchFieldProps.onAppPrivateCommand,
                  inputFormatters:
                      widget.popupProps.searchFieldProps.inputFormatters,
                  enabled: widget.popupProps.searchFieldProps.enabled,
                  cursorWidth: widget.popupProps.searchFieldProps.cursorWidth,
                  cursorHeight: widget.popupProps.searchFieldProps.cursorHeight,
                  cursorRadius: widget.popupProps.searchFieldProps.cursorRadius,
                  cursorColor: widget.popupProps.searchFieldProps.cursorColor,
                  selectionHeightStyle:
                      widget.popupProps.searchFieldProps.selectionHeightStyle,
                  selectionWidthStyle:
                      widget.popupProps.searchFieldProps.selectionWidthStyle,
                  keyboardAppearance:
                      widget.popupProps.searchFieldProps.keyboardAppearance,
                  scrollPadding:
                      widget.popupProps.searchFieldProps.scrollPadding,
                  dragStartBehavior:
                      widget.popupProps.searchFieldProps.dragStartBehavior,
                  enableInteractiveSelection: widget
                      .popupProps.searchFieldProps.enableInteractiveSelection,
                  selectionControls:
                      widget.popupProps.searchFieldProps.selectionControls,
                  onTap: widget.popupProps.searchFieldProps.onTap,
                  mouseCursor: widget.popupProps.searchFieldProps.mouseCursor,
                  buildCounter: widget.popupProps.searchFieldProps.buildCounter,
                  scrollController:
                      widget.popupProps.searchFieldProps.scrollController,
                  scrollPhysics:
                      widget.popupProps.searchFieldProps.scrollPhysics,
                  autofillHints:
                      widget.popupProps.searchFieldProps.autofillHints,
                  restorationId:
                      widget.popupProps.searchFieldProps.restorationId,
                  canRequestFocus:
                      widget.popupProps.searchFieldProps.canRequestFocus,
                  statesController:
                      widget.popupProps.searchFieldProps.statesController,
                  contentInsertionConfiguration: widget.popupProps
                      .searchFieldProps.contentInsertionConfiguration,
                  cursorErrorColor:
                      widget.popupProps.searchFieldProps.cursorErrorColor,
                  cursorOpacityAnimates:
                      widget.popupProps.searchFieldProps.cursorOpacityAnimates,
                  ignorePointers:
                      widget.popupProps.searchFieldProps.ignorePointers,
                  magnifierConfiguration:
                      widget.popupProps.searchFieldProps.magnifierConfiguration,
                  onTapOutside: widget.popupProps.searchFieldProps.onTapOutside,
                  scribbleEnabled:
                      widget.popupProps.searchFieldProps.scribbleEnabled,
                  undoController:
                      widget.popupProps.searchFieldProps.undoController,
                  spellCheckConfiguration: widget
                      .popupProps.searchFieldProps.spellCheckConfiguration,
                ),
              ),
            ),
          )
      ],
    );
  }

  Widget _suggestedItemsWidget() {
    if (widget.popupProps.suggestedItemProps.showSuggestedItems &&
        widget.popupProps.suggestedItemProps.suggestedItems != null) {
      return StreamBuilder<List<T>>(
          stream: _itemsStream.stream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return _buildSuggestedItems(widget.popupProps.suggestedItemProps
                  .suggestedItems!(snapshot.data!));
            } else {
              return SizedBox.shrink();
            }
          });
    }

    return SizedBox.shrink();
  }

  Widget _buildSuggestedItems(List<T> suggestedItems) {
    if (suggestedItems.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: LayoutBuilder(builder: (context, constraints) {
        return CustomSingleScrollView(
          scrollProps: widget.popupProps.suggestedItemProps.scrollProps,
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: constraints.maxWidth),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment:
                  widget.popupProps.suggestedItemProps.suggestedItemsAlignment,
              children: suggestedItems
                  .map(
                    (f) => CustomInkWell(
                      clickProps:
                          widget.popupProps.suggestedItemProps.itemClickProps,
                      onTap: () => _handleSelectedItem(f),
                      child: widget.popupProps.suggestedItemProps
                                  .suggestedItemBuilder !=
                              null
                          ? widget.popupProps.suggestedItemProps
                                  .suggestedItemBuilder!(
                              context, f, _isSelectedItem(f))
                          : _suggestedItemDefaultWidget(f),
                    ),
                  )
                  .toList(),
            ),
          ),
        );
      }),
    );
  }

  void _handleSelectedItem(T newSelectedItem) {
    if (widget.isMultiSelectionMode) {
      if (_isSelectedItem(newSelectedItem)) {
        _selectedItemsNotifier.value = List.from(_selectedItems)
          ..removeWhere((i) => _isEqual(newSelectedItem, i));
        if (widget.popupProps.onItemRemoved != null) {
          widget.popupProps.onItemRemoved!(_selectedItems, newSelectedItem);
        }
      } else {
        _selectedItemsNotifier.value = List.from(_selectedItems)
          ..add(newSelectedItem);
        if (widget.popupProps.onItemAdded != null) {
          widget.popupProps.onItemAdded!(_selectedItems, newSelectedItem);
        }
      }
    } else {
      closePopup();
      if (widget.onChanged != null) {
        widget.onChanged!(List.filled(1, newSelectedItem));
      }
    }
  }

  Widget _suggestedItemDefaultWidget(T item) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      margin: EdgeInsets.only(left: 8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).primaryColorLight),
      child: Row(
        children: [
          Text(
            _selectedItemAsString(item),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          Padding(padding: EdgeInsets.only(left: 8)),
          Visibility(
            child: Icon(Icons.check_box_outlined),
            visible: _isSelectedItem(item),
          )
        ],
      ),
    );
  }

  ///function that return the String value of an object
  String _selectedItemAsString(T data) {
    if (data == null) {
      return "";
    } else if (widget.itemAsString != null) {
      return widget.itemAsString!(data);
    } else {
      return data.toString();
    }
  }

  void selectItems(List<T> itemsToSelect) {
    for (var i in itemsToSelect) {
      if (!_isSelectedItem(i) /*check if the item is already selected*/ &&
          !_isDisabled(i) /*escape disabled items*/) {
        _selectedItems.add(i);
        if (widget.popupProps.onItemAdded != null) {
          widget.popupProps.onItemAdded!(_selectedItems, i);
        }
      }
    }
    _selectedItemsNotifier.value = List.from(_selectedItems);
  }

  void deselectItems(List<T> itemsToDeselect) {
    List<T> tempList = List.from(itemsToDeselect);
    for (var i in tempList) {
      var index = _itemIndexInList(_selectedItems, i);
      if (index > -1) /*check if the item is already selected*/ {
        _selectedItems.removeAt(index);
        if (widget.popupProps.onItemRemoved != null) {
          widget.popupProps.onItemRemoved!(_selectedItems, i);
        }
      }
    }
    _selectedItemsNotifier.value = List.from(_selectedItems);
  }

  ///close popup
  void closePopup() => Navigator.pop(context);

  void selectAllItems() => selectItems(_currentShowedItems);

  void deselectAllItems() => deselectItems(_selectedItems);

  bool get isAllItemSelected =>
      _listEquals(_selectedItems, _currentShowedItems);

  List<T> get getSelectedItem => List.from(_selectedItems);

  List<T> get getLoadedItems => List.from(_currentShowedItems);

  bool _listEquals(List<T>? a, List<T>? b) {
    if (a == null) {
      return b == null;
    }
    if (b == null || a.length != b.length) {
      return false;
    }
    if (identical(a, b)) {
      return true;
    }
    for (int index = 0; index < b.length; index += 1) {
      if (_itemIndexInList(a, b[index]) == -1) {
        return false;
      }
    }
    return true;
  }
}
