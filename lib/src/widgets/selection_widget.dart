import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../dropdown_search.dart';
import 'checkbox_widget.dart';

class SelectionWidget<T> extends StatefulWidget {
  final List<T> items;
  final ValueChanged<List<T>>? onChanged;
  final DropdownSearchOnFind<T>? asyncItems;
  final DropdownSearchItemAsString<T>? itemAsString;
  final DropdownSearchFilterFn<T>? filterFn;
  final DropdownSearchCompareFn<T>? compareFn;
  final List<T> defaultSelectedItems;
  final PopupPropsMultiSelection<T> popupProps;
  final bool isMultiSelectionMode;

  const SelectionWidget({
    Key? key,
    required this.popupProps,
    this.defaultSelectedItems = const [],
    this.isMultiSelectionMode = false,
    this.items = const [],
    this.onChanged,
    this.asyncItems,
    this.itemAsString,
    this.filterFn,
    this.compareFn,
  }) : super(key: key);

  @override
  SelectionWidgetState<T> createState() => SelectionWidgetState<T>();
}

class SelectionWidgetState<T> extends State<SelectionWidget<T>> {
  final StreamController<List<T>> _itemsStream = StreamController.broadcast();
  final ValueNotifier<bool> _loadingNotifier = ValueNotifier(false);
  final List<T> _cachedItems = [];
  final ValueNotifier<List<T>> _selectedItemsNotifier = ValueNotifier([]);
  final ScrollController scrollController = ScrollController();
  final List<T> _currentShowedItems = [];
  late TextEditingController searchBoxController;

  List<T> get _selectedItems => _selectedItemsNotifier.value;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _selectedItemsNotifier.value = widget.defaultSelectedItems;

    searchBoxController = widget.popupProps.searchFieldProps.controller ?? TextEditingController();
    searchBoxController.addListener(() {
      if (_debounce?.isActive ?? false) _debounce?.cancel();
      _debounce = Timer(widget.popupProps.searchDelay, () {
        _manageItemsByFilter(searchBoxController.text);
      });
    });

    Future.delayed(
      Duration.zero,
      () => _manageItemsByFilter(
        searchBoxController.text,
        isFirstLoad: true,
      ),
    );
  }

  @override
  void didUpdateWidget(covariant SelectionWidget<T> oldWidget) {
    if (!listEquals(oldWidget.defaultSelectedItems, widget.defaultSelectedItems)) {
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
    return ValueListenableBuilder(
        valueListenable: _selectedItemsNotifier,
        builder: (ctx, value, wdgt) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _searchField(),
              _favoriteItemsWidget(),
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

                        return RawScrollbar(
                          controller: widget.popupProps.listViewProps.controller ?? scrollController,
                          thumbVisibility: widget.popupProps.scrollbarProps.thumbVisibility,
                          trackVisibility: widget.popupProps.scrollbarProps.trackVisibility,
                          thickness: widget.popupProps.scrollbarProps.thickness,
                          radius: widget.popupProps.scrollbarProps.radius,
                          notificationPredicate: widget.popupProps.scrollbarProps.notificationPredicate,
                          interactive: widget.popupProps.scrollbarProps.interactive,
                          scrollbarOrientation: widget.popupProps.scrollbarProps.scrollbarOrientation,
                          thumbColor: widget.popupProps.scrollbarProps.thumbColor,
                          fadeDuration: widget.popupProps.scrollbarProps.fadeDuration,
                          crossAxisMargin: widget.popupProps.scrollbarProps.crossAxisMargin,
                          mainAxisMargin: widget.popupProps.scrollbarProps.mainAxisMargin,
                          minOverscrollLength: widget.popupProps.scrollbarProps.minOverscrollLength,
                          minThumbLength: widget.popupProps.scrollbarProps.minThumbLength,
                          pressDuration: widget.popupProps.scrollbarProps.pressDuration,
                          shape: widget.popupProps.scrollbarProps.shape,
                          timeToFade: widget.popupProps.scrollbarProps.timeToFade,
                          trackBorderColor: widget.popupProps.scrollbarProps.trackBorderColor,
                          trackColor: widget.popupProps.scrollbarProps.trackColor,
                          trackRadius: widget.popupProps.scrollbarProps.trackRadius,
                          child: ListView.builder(
                            controller: widget.popupProps.listViewProps.controller ?? scrollController,
                            shrinkWrap: widget.popupProps.listViewProps.shrinkWrap,
                            padding: widget.popupProps.listViewProps.padding,
                            scrollDirection: widget.popupProps.listViewProps.scrollDirection,
                            reverse: widget.popupProps.listViewProps.reverse,
                            primary: widget.popupProps.listViewProps.primary,
                            physics: widget.popupProps.listViewProps.physics,
                            itemExtent: widget.popupProps.listViewProps.itemExtent,
                            addAutomaticKeepAlives: widget.popupProps.listViewProps.addAutomaticKeepAlives,
                            addRepaintBoundaries: widget.popupProps.listViewProps.addRepaintBoundaries,
                            addSemanticIndexes: widget.popupProps.listViewProps.addSemanticIndexes,
                            cacheExtent: widget.popupProps.listViewProps.cacheExtent,
                            semanticChildCount: widget.popupProps.listViewProps.semanticChildCount,
                            dragStartBehavior: widget.popupProps.listViewProps.dragStartBehavior,
                            keyboardDismissBehavior: widget.popupProps.listViewProps.keyboardDismissBehavior,
                            restorationId: widget.popupProps.listViewProps.restorationId,
                            clipBehavior: widget.popupProps.listViewProps.clipBehavior,
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              var item = snapshot.data![index];
                              return widget.isMultiSelectionMode
                                  ? _itemWidgetMultiSelection(item)
                                  : _itemWidgetSingleSelection(item);
                            },
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
        });
  }

  ///validation of selected items
  void onValidate() {
    closePopup();
    if (widget.onChanged != null) widget.onChanged!(_selectedItems);
  }

  ///close popup
  void closePopup() => Navigator.pop(context);

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

    if (widget.popupProps.validationWidgetBuilder != null) {
      return widget.popupProps.validationWidgetBuilder!(context, _selectedItems);
    }

    return defaultValidation;
  }

  void _showErrorDialog(dynamic error) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Error while getting online items"),
          content: _errorWidget(error),
          actions: <Widget>[
            TextButton(
              child: new Text("OK"),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            )
          ],
        );
      },
    );
  }

  Widget _noDataWidget() {
    if (widget.popupProps.emptyBuilder != null)
      return widget.popupProps.emptyBuilder!(
        context,
        searchBoxController.text,
      );
    else
      return Container(
        height: 70,
        alignment: Alignment.center,
        child: Text("No data found"),
      );
  }

  Widget _errorWidget(dynamic error) {
    if (widget.popupProps.errorBuilder != null)
      return widget.popupProps.errorBuilder!(
        context,
        searchBoxController.text,
        error,
      );
    else
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
            if (widget.popupProps.loadingBuilder != null)
              return widget.popupProps.loadingBuilder!(
                context,
                searchBoxController.text,
              );
            else
              return Container(
                height: 70,
                alignment: Alignment.center,
                child: const CircularProgressIndicator(),
              );
          }
          return const SizedBox.shrink();
        });
  }

  ///Function that filter item (online and offline) base on user filter
  ///[filter] is the filter keyword
  ///[isFirstLoad] true if it's the first time we load data from online, false other wises
  Future<void> _manageItemsByFilter(String filter, {bool isFirstLoad = false}) async {
    _loadingNotifier.value = true;

    List<T> applyFilter(String filter) {
      return _cachedItems.where((i) {
        if (widget.filterFn != null)
          return (widget.filterFn!(i, filter));
        else if (i.toString().toLowerCase().contains(filter.toLowerCase()))
          return true;
        else if (widget.itemAsString != null) {
          return (widget.itemAsString!(i)).toLowerCase().contains(filter.toLowerCase());
        }
        return false;
      }).toList();
    }

    //load offline data for the first time
    if (isFirstLoad) _cachedItems.addAll(widget.items);

    //manage offline items
    if (widget.asyncItems != null && (widget.popupProps.isFilterOnline || isFirstLoad)) {
      try {
        final List<T> onlineItems = [];
        onlineItems.addAll(await widget.asyncItems!(filter));

        //Remove all old data
        _cachedItems.clear();
        //add offline items
        _cachedItems.addAll(widget.items);
        //if filter online we filter only local list based on entered keyword (filter)
        if (widget.popupProps.isFilterOnline == true) {
          var filteredLocalList = applyFilter(filter);
          _cachedItems.clear();
          _cachedItems.addAll(filteredLocalList);
        }

        //add new online items to list
        _cachedItems.addAll(onlineItems);

        //don't filter data , they are already filtered online and local data are already filtered
        if (widget.popupProps.isFilterOnline == true)
          _addDataToStream(_cachedItems);
        else
          _addDataToStream(applyFilter(filter));
      } catch (e) {
        _addErrorToStream(e);
        //if offline items count > 0 , the error will be not visible for the user
        //As solution we show it in dialog
        if (widget.items.isNotEmpty) {
          _showErrorDialog(e);
          _addDataToStream(applyFilter(filter));
        }
      }
    } else {
      _addDataToStream(applyFilter(filter));
    }

    _loadingNotifier.value = false;
  }

  void _addDataToStream(List<T> data) {
    if (_itemsStream.isClosed) return;
    _itemsStream.add(data);

    //update showed data list
    _currentShowedItems.clear();
    _currentShowedItems.addAll(data);
  }

  void _addErrorToStream(Object error, [StackTrace? stackTrace]) {
    if (_itemsStream.isClosed) return;
    _itemsStream.addError(error, stackTrace);
  }

  Widget _itemWidgetSingleSelection(T item) {
    if (widget.popupProps.itemBuilder != null) {
      var w = widget.popupProps.itemBuilder!(
        context,
        item,
        !widget.popupProps.showSelectedItems ? false : _isSelectedItem(item),
      );

      if (widget.popupProps.interceptCallBacks)
        return w;
      else
        return InkWell(
          // ignore pointers in itemBuilder
          child: IgnorePointer(child: w),
          onTap: _isDisabled(item) ? null : () => _handleSelectedItem(item),
        );
    } else {
      return ListTile(
        enabled: !_isDisabled(item),
        title: Text(_selectedItemAsString(item)),
        selected: !widget.popupProps.showSelectedItems ? false : _isSelectedItem(item),
        onTap: _isDisabled(item) ? null : () => _handleSelectedItem(item),
      );
    }
  }

  Widget _itemWidgetMultiSelection(T item) {
    if (widget.popupProps.selectionWidget != null)
      return CheckBoxWidget(
        checkBox: (cnt, checked) {
          return widget.popupProps.selectionWidget!(context, item, checked);
        },
        interceptCallBacks: widget.popupProps.interceptCallBacks,
        textDirection: widget.popupProps.textDirection,
        layout: (context, isChecked) => _itemWidgetSingleSelection(item),
        isChecked: _isSelectedItem(item),
        isDisabled: _isDisabled(item),
        onChanged: (c) => _handleSelectedItem(item),
      );
    else
      return CheckBoxWidget(
        textDirection: widget.popupProps.textDirection,
        interceptCallBacks: widget.popupProps.interceptCallBacks,
        layout: (context, isChecked) => _itemWidgetSingleSelection(item),
        isChecked: _isSelectedItem(item),
        isDisabled: _isDisabled(item),
        onChanged: (c) => _handleSelectedItem(item),
      );
  }

  bool _isDisabled(T item) =>
      widget.popupProps.disabledItemFn != null && (widget.popupProps.disabledItemFn!(item)) == true;

  /// selected item will be highlighted only when [widget.showSelectedItems] is true,
  /// if our object is String [widget.compareFn] is not required , other wises it's required
  bool _isSelectedItem(T item) {
    return _itemIndexInList(_selectedItems, item) > -1;
  }

  ///test if list has an item T
  ///if contains return index of item in the list, -1 otherwise
  int _itemIndexInList(List<T> list, T item) {
    return list.indexWhere((i) => _isEqual(i, item));
  }

  ///compared two items base on user params
  bool _isEqual(T i1, T i2) {
    if (widget.compareFn != null)
      return widget.compareFn!(i1, i2);
    else
      return i1 == i2;
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
                  SingleActivator(LogicalKeyboardKey.space): DoNothingAndStopPropagationTextIntent(),
                },
                child: TextField(
                  enableIMEPersonalizedLearning: widget.popupProps.searchFieldProps.enableIMEPersonalizedLearning,
                  clipBehavior: widget.popupProps.searchFieldProps.clipBehavior,
                  style: widget.popupProps.searchFieldProps.style,
                  controller: searchBoxController,
                  focusNode: widget.popupProps.searchFieldProps.focusNode,
                  autofocus: widget.popupProps.searchFieldProps.autofocus,
                  decoration: widget.popupProps.searchFieldProps.decoration,
                  keyboardType: widget.popupProps.searchFieldProps.keyboardType,
                  textInputAction: widget.popupProps.searchFieldProps.textInputAction,
                  textCapitalization: widget.popupProps.searchFieldProps.textCapitalization,
                  strutStyle: widget.popupProps.searchFieldProps.strutStyle,
                  textAlign: widget.popupProps.searchFieldProps.textAlign,
                  textAlignVertical: widget.popupProps.searchFieldProps.textAlignVertical,
                  textDirection: widget.popupProps.searchFieldProps.textDirection,
                  readOnly: widget.popupProps.searchFieldProps.readOnly,
                  contextMenuBuilder: widget.popupProps.searchFieldProps.contextMenuBuilder,
                  showCursor: widget.popupProps.searchFieldProps.showCursor,
                  obscuringCharacter: widget.popupProps.searchFieldProps.obscuringCharacter,
                  obscureText: widget.popupProps.searchFieldProps.obscureText,
                  autocorrect: widget.popupProps.searchFieldProps.autocorrect,
                  smartDashesType: widget.popupProps.searchFieldProps.smartDashesType,
                  smartQuotesType: widget.popupProps.searchFieldProps.smartQuotesType,
                  enableSuggestions: widget.popupProps.searchFieldProps.enableSuggestions,
                  maxLines: widget.popupProps.searchFieldProps.maxLines,
                  minLines: widget.popupProps.searchFieldProps.minLines,
                  expands: widget.popupProps.searchFieldProps.expands,
                  maxLengthEnforcement: widget.popupProps.searchFieldProps.maxLengthEnforcement,
                  maxLength: widget.popupProps.searchFieldProps.maxLength,
                  onAppPrivateCommand: widget.popupProps.searchFieldProps.onAppPrivateCommand,
                  inputFormatters: widget.popupProps.searchFieldProps.inputFormatters,
                  enabled: widget.popupProps.searchFieldProps.enabled,
                  cursorWidth: widget.popupProps.searchFieldProps.cursorWidth,
                  cursorHeight: widget.popupProps.searchFieldProps.cursorHeight,
                  cursorRadius: widget.popupProps.searchFieldProps.cursorRadius,
                  cursorColor: widget.popupProps.searchFieldProps.cursorColor,
                  selectionHeightStyle: widget.popupProps.searchFieldProps.selectionHeightStyle,
                  selectionWidthStyle: widget.popupProps.searchFieldProps.selectionWidthStyle,
                  keyboardAppearance: widget.popupProps.searchFieldProps.keyboardAppearance,
                  scrollPadding: widget.popupProps.searchFieldProps.scrollPadding,
                  dragStartBehavior: widget.popupProps.searchFieldProps.dragStartBehavior,
                  enableInteractiveSelection: widget.popupProps.searchFieldProps.enableInteractiveSelection,
                  selectionControls: widget.popupProps.searchFieldProps.selectionControls,
                  onTap: widget.popupProps.searchFieldProps.onTap,
                  mouseCursor: widget.popupProps.searchFieldProps.mouseCursor,
                  buildCounter: widget.popupProps.searchFieldProps.buildCounter,
                  scrollController: widget.popupProps.searchFieldProps.scrollController,
                  scrollPhysics: widget.popupProps.searchFieldProps.scrollPhysics,
                  autofillHints: widget.popupProps.searchFieldProps.autofillHints,
                  restorationId: widget.popupProps.searchFieldProps.restorationId,
                ),
              ),
            ),
          )
      ],
    );
  }

  Widget _favoriteItemsWidget() {
    if (widget.popupProps.favoriteItemProps.showFavoriteItems &&
        widget.popupProps.favoriteItemProps.favoriteItems != null) {
      return StreamBuilder<List<T>>(
          stream: _itemsStream.stream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return _buildFavoriteItems(widget.popupProps.favoriteItemProps.favoriteItems!(snapshot.data!));
            } else {
              return Container();
            }
          });
    }

    return Container();
  }

  Widget _buildFavoriteItems(List<T> favoriteItems) {
    if (favoriteItems.isEmpty) return Container();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: LayoutBuilder(builder: (context, constraints) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: constraints.maxWidth),
            child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: widget.popupProps.favoriteItemProps.favoriteItemsAlignment,
                children: favoriteItems
                    .map(
                      (f) => InkWell(
                        onTap: () => _handleSelectedItem(f),
                        child: Container(
                          margin: EdgeInsets.only(right: 4),
                          child: widget.popupProps.favoriteItemProps.favoriteItemBuilder != null
                              ? widget.popupProps.favoriteItemProps.favoriteItemBuilder!(
                                  context,
                                  f,
                                  _isSelectedItem(f),
                                )
                              : _favoriteItemDefaultWidget(f),
                        ),
                      ),
                    )
                    .toList()),
          ),
        );
      }),
    );
  }

  void _handleSelectedItem(T newSelectedItem) {
    if (widget.isMultiSelectionMode) {
      if (_isSelectedItem(newSelectedItem)) {
        _selectedItemsNotifier.value = List.from(_selectedItems)..removeWhere((i) => _isEqual(newSelectedItem, i));
        if (widget.popupProps.onItemRemoved != null) widget.popupProps.onItemRemoved!(_selectedItems, newSelectedItem);
      } else {
        _selectedItemsNotifier.value = List.from(_selectedItems)..add(newSelectedItem);
        if (widget.popupProps.onItemAdded != null) widget.popupProps.onItemAdded!(_selectedItems, newSelectedItem);
      }
    } else {
      closePopup();
      if (widget.onChanged != null) widget.onChanged!(List.filled(1, newSelectedItem));
    }
  }

  Widget _favoriteItemDefaultWidget(T item) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Theme.of(context).primaryColorLight),
      child: Row(
        children: [
          Text(
            _selectedItemAsString(item),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
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
    List<T> newSelectedItems = _selectedItems;
    itemsToSelect.forEach((i) {
      if (!_isSelectedItem(i) /*check if the item is already selected*/ && !_isDisabled(i) /*escape disabled items*/) {
        newSelectedItems.add(i);
        if (widget.popupProps.onItemAdded != null) widget.popupProps.onItemAdded!(_selectedItems, i);
      }
    });
    _selectedItemsNotifier.value = List.from(newSelectedItems);
  }

  void selectAllItems() {
    selectItems(_currentShowedItems);
  }

  void deselectItems(List<T> itemsToDeselect) {
    List<T> newSelectedItems = _selectedItems;
    itemsToDeselect.forEach((i) {
      var index = _itemIndexInList(newSelectedItems, i);
      if (index > -1) /*check if the item is already selected*/ {
        newSelectedItems.removeAt(index);
        if (widget.popupProps.onItemRemoved != null) widget.popupProps.onItemRemoved!(_selectedItems, i);
      }
    });
    _selectedItemsNotifier.value = List.from(newSelectedItems);
  }

  void deselectAllItems() {
    deselectItems(_cachedItems);
  }

  bool get isAllItemSelected => _selectedItems.length >= _currentShowedItems.length;

  List<T> get getSelectedItem => List.from(_selectedItems);
}
