import 'dart:async';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:dropdown_search/src/utils.dart';
import 'package:dropdown_search/src/widgets/custom_inkwell.dart';
import 'package:dropdown_search/src/widgets/custom_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'checkbox_widget.dart';
import 'custom_cupertino_text_field.dart';
import 'suggestions_widget.dart';

class DropdownSearchPopup<T> extends StatefulWidget {
  final ValueChanged<List<T>>? onSelected;
  final DropdownSearchOnFind<T>? items;
  final DropdownSearchItemAsString<T>? itemAsString;
  final DropdownSearchFilterFn<T>? filterFn;
  final DropdownSearchCompareFn<T>? compareFn;
  final List<T> defaultSelectedItems;
  final BasePopupProps<T> props;
  final bool isMultiSelectionMode;
  final UiToApply uiMode;
  final PopupMode dropdownMode;
  final VoidCallback? onClose;

  const DropdownSearchPopup({
    super.key,
    required this.props,
    this.onClose,
    this.uiMode = UiToApply.material,
    this.dropdownMode = PopupMode.menu,
    this.defaultSelectedItems = const [],
    this.isMultiSelectionMode = false,
    this.onSelected,
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

  void _searchBoxControllerListener() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();

    //handle case when editText get focused, onTextChange was called !
    if (lastSearchText == searchBoxController.text) return;

    _debounce = Timer(widget.props.searchDelay, () {
      lastSearchText = searchBoxController.text;
      _manageLoadItems(searchBoxController.text);
    });
  }

  @override
  void initState() {
    super.initState();
    _selectedItemsNotifier.value = widget.defaultSelectedItems;

    searchBoxController =
        widget.props.searchFieldProps.controller ?? TextEditingController();
    searchBoxController.addListener(_searchBoxControllerListener);

    lastSearchText = searchBoxController.text;

    isInfiniteScrollEnded = widget.props.infiniteScrollProps == null;

    Future.delayed(
      Duration.zero,
      () => _manageLoadItems(searchBoxController.text, isFirstLoad: true),
    );

    WidgetsBinding.instance.endOfFrame.then(
      (_) {
        if (mounted) widget.props.onDisplayed?.call();
      },
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

    if (widget.props.searchFieldProps.controller == null) {
      searchBoxController.dispose();
    } else {
      searchBoxController.removeListener(_searchBoxControllerListener);
    }

    if (widget.props.listViewProps.controller == null) {
      scrollController.dispose();
    }

    widget.props.onDismissed?.call();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: widget.props.constraints,
      child: widget.props.containerBuilder == null
          ? _defaultWidget()
          : widget.props.containerBuilder!(context, _defaultWidget()),
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
                if (widget.props.title != null) widget.props.title!,
                if (widget.props.showSearchBox &&
                    widget.dropdownMode != PopupMode.autocomplete)
                  _searchField(),
                _suggestedItemsWidget(),
                Flexible(
                  fit: widget.props.fit,
                  child: Stack(
                    children: <Widget>[
                      StreamBuilder<List<T>>(
                        stream: _itemsStream.stream,
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            if (_cachedItems.isNotEmpty &&
                                !isInfiniteScrollEnded) {
                              return _listItemWidget(
                                  _cachedItems, snapshot.error);
                            }
                            return _errorWidget(snapshot.error);
                          } else if (snapshot.hasData) {
                            if (snapshot.data!.isEmpty) return _noDataWidget();
                            return _listItemWidget(snapshot.data!);
                          }
                          return _loadingWidget();
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

  Widget _listItemWidget(List<T> data, [dynamic pLoadingMoreError]) {
    final itemCount = data.length;
    return RawScrollbar(
      controller: widget.props.listViewProps.controller ?? scrollController,
      thumbVisibility: widget.props.scrollbarProps.thumbVisibility,
      trackVisibility: widget.props.scrollbarProps.trackVisibility,
      thickness: widget.props.scrollbarProps.thickness,
      radius: widget.props.scrollbarProps.radius ??
          (widget.uiMode == UiToApply.cupertino ? Radius.circular(4) : null),
      notificationPredicate: widget.props.scrollbarProps.notificationPredicate,
      interactive: widget.props.scrollbarProps.interactive,
      scrollbarOrientation: widget.props.scrollbarProps.scrollbarOrientation,
      thumbColor: widget.props.scrollbarProps.thumbColor,
      fadeDuration: widget.props.scrollbarProps.fadeDuration,
      crossAxisMargin: widget.props.scrollbarProps.crossAxisMargin,
      mainAxisMargin: widget.props.scrollbarProps.mainAxisMargin,
      minOverscrollLength: widget.props.scrollbarProps.minOverscrollLength,
      minThumbLength: widget.props.scrollbarProps.minThumbLength,
      pressDuration: widget.props.scrollbarProps.pressDuration,
      shape: widget.props.scrollbarProps.shape,
      timeToFade: widget.props.scrollbarProps.timeToFade,
      trackBorderColor: widget.props.scrollbarProps.trackBorderColor,
      trackColor: widget.props.scrollbarProps.trackColor,
      trackRadius: widget.props.scrollbarProps.trackRadius,
      padding: widget.props.scrollbarProps.padding,
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
        child: Material(
          type: MaterialType.transparency,
          //todo temp solution till fix this Flutter issue here https://github.com/flutter/flutter/issues/155198
          child: ListView.builder(
            hitTestBehavior: widget.props.listViewProps.hitTestBehavior,
            controller:
                widget.props.listViewProps.controller ?? scrollController,
            shrinkWrap: widget.props.listViewProps.shrinkWrap,
            padding: widget.props.listViewProps.padding,
            scrollDirection: widget.props.listViewProps.scrollDirection,
            reverse: widget.props.listViewProps.reverse,
            primary: widget.props.listViewProps.primary,
            physics: widget.props.listViewProps.physics,
            itemExtent: widget.props.listViewProps.itemExtent,
            addAutomaticKeepAlives:
                widget.props.listViewProps.addAutomaticKeepAlives,
            addRepaintBoundaries:
                widget.props.listViewProps.addRepaintBoundaries,
            addSemanticIndexes: widget.props.listViewProps.addSemanticIndexes,
            cacheExtent: widget.props.listViewProps.cacheExtent,
            semanticChildCount: widget.props.listViewProps.semanticChildCount,
            dragStartBehavior: widget.props.listViewProps.dragStartBehavior,
            keyboardDismissBehavior:
                widget.props.listViewProps.keyboardDismissBehavior,
            restorationId: widget.props.listViewProps.restorationId,
            clipBehavior: widget.props.listViewProps.clipBehavior,
            prototypeItem: widget.props.listViewProps.prototypeItem,
            itemExtentBuilder: widget.props.listViewProps.itemExtentBuilder,
            findChildIndexCallback:
                widget.props.listViewProps.findChildIndexCallback,
            itemCount: itemCount + (isInfiniteScrollEnded ? 0 : 1),
            itemBuilder: (context, index) {
              if (index < itemCount) {
                var item = data[index];
                return widget.isMultiSelectionMode
                    ? _itemWidgetMultiSelection(item)
                    : _itemWidgetSingleSelection(item);
              }
              if (pLoadingMoreError != null) {
                return _loadMoreErrorWidget(pLoadingMoreError, itemCount);
              } else if (!isInfiniteScrollEnded) {
                _manageLoadMoreItems(searchBoxController.text,
                    skip: itemCount, showLoading: false);
                return _infiniteScrollLoadingMoreWidget(itemCount);
              }

              return SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  Widget _loadMoreErrorWidget(dynamic error, int loadedItems) {
    if (widget.props.infiniteScrollProps?.errorBuilder != null) {
      return widget.props.infiniteScrollProps!.errorBuilder!(
        context,
        lastSearchText,
        error,
        widget.props.infiniteScrollProps!.loadProps.copy(skip: loadedItems),
      );
    }
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('An error occurred !'),
          IconButton(
            onPressed: () =>
                loadMoreItems(searchBoxController.text, loadedItems),
            icon: Icon(widget.uiMode == UiToApply.cupertino
                ? CupertinoIcons.refresh
                : Icons.refresh),
          )
        ],
      ),
    );
  }

  Widget _infiniteScrollLoadingMoreWidget(int loadedItems) {
    if (widget.props.infiniteScrollProps?.loadingMoreBuilder != null) {
      return widget.props.infiniteScrollProps!.loadingMoreBuilder!(
          context, loadedItems);
    }

    return Center(
      child: widget.uiMode == UiToApply.cupertino
          ? CupertinoActivityIndicator()
          : CircularProgressIndicator(),
    );
  }

  ///validation of selected items
  void onValidate() {
    _closePopup();
    if (widget.onSelected != null) widget.onSelected!(_selectedItems);
  }

  Widget _multiSelectionValidation() {
    if (!widget.isMultiSelectionMode) return SizedBox.shrink();

    if (widget.props.validationBuilder != null) {
      return widget.props.validationBuilder!(context, _selectedItems);
    }

    //for cupertino modal and dialog we used already "actions" as Validation method
    if (widget.uiMode == UiToApply.cupertino &&
        (widget.props.mode == PopupMode.modalBottomSheet ||
            widget.props.mode == PopupMode.dialog)) {
      return SizedBox.shrink();
    }

    Widget defaultMaterialValidation = Container(
      alignment: Alignment.centerRight,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
          border:
              Border(top: BorderSide(width: 1, color: Colors.grey.shade300))),
      child: TextButton(
        onPressed: onValidate,
        child: Text("DONE"),
      ),
    );

    return defaultMaterialValidation;
  }

  Widget _noDataWidget() {
    if (widget.props.emptyBuilder != null) {
      return widget.props.emptyBuilder!(context, searchBoxController.text);
    }

    return Container(
      height: 70,
      alignment: Alignment.center,
      child: Text("No data found"),
    );
  }

  Widget _errorWidget(dynamic error) {
    if (widget.props.errorBuilder != null) {
      return widget.props.errorBuilder!(
          context, searchBoxController.text, error);
    }

    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(error?.toString() ?? 'Unknown Error'),
          IconButton(
            onPressed: () => reloadItems(searchBoxController.text),
            icon: Icon(widget.uiMode == UiToApply.cupertino
                ? CupertinoIcons.refresh
                : Icons.refresh),
          )
        ],
      ),
    );
  }

  Widget _loadingWidget() {
    return ValueListenableBuilder(
      valueListenable: _loadingNotifier,
      builder: (context, bool isLoading, wid) {
        if (!isLoading) return const SizedBox.shrink();

        if (widget.props.loadingBuilder != null) {
          return widget.props.loadingBuilder!(
            context,
            searchBoxController.text,
          );
        }

        return AbsorbPointer(
          child: Container(
            alignment: Alignment.center,
            child: widget.uiMode == UiToApply.cupertino
                ? CupertinoActivityIndicator()
                : CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  List<T> _applyFilter(String filter) {
    return _cachedItems.where((i) {
      if (widget.filterFn != null) {
        return (widget.filterFn!(i, filter));
      } else if (widget.itemAsString != null) {
        return (widget.itemAsString!(i))
            .toLowerCase()
            .contains(filter.toLowerCase());
      }
      return i.toString().toLowerCase().contains(filter.toLowerCase());
    }).toList();
  }

  Future<void> _manageLoadItems(
    String filter, {
    bool isFirstLoad = false,
  }) async {
    //if the filter is not handled by user, we load full list once
    if (!widget.props.cacheItems || isFirstLoad) _cachedItems.clear();

    //case filtering locally (no need to load new data)
    if (!isFirstLoad &&
        !widget.props.disableFilter &&
        widget.props.cacheItems &&
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

    final loadProps = widget.props.infiniteScrollProps?.loadProps;

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
      if (widget.props.disableFilter) {
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

    if (widget.props.onItemsLoaded != null) {
      widget.props.onItemsLoaded!(data);
    }
  }

  void _setErrorToStream(Object error, [StackTrace? stackTrace]) {
    if (_itemsStream.isClosed) return;
    _itemsStream.addError(error, stackTrace);
  }

  Widget _itemWidgetSingleSelection(T item) {
    final isDisabled = _isDisabled(item);

    if (widget.props.itemBuilder != null) {
      var w = widget.props.itemBuilder!(
        context,
        item,
        isDisabled,
        !widget.props.showSelectedItems ? false : _isSelectedItem(item),
        _handleSelectedItem,
      );

      if (widget.props.interceptCallBacks) return w;

      return CustomInkWell(
        clickProps: widget.props.itemClickProps,
        onTap: isDisabled ? null : () => _handleSelectedItem(item),
        child: IgnorePointer(child: w),
      );
    } else {
      return ListTile(
        enabled: !isDisabled,
        title: Text(_itemAsString(item)),
        selected:
            !widget.props.showSelectedItems ? false : _isSelectedItem(item),
        onTap: isDisabled ? null : () => _handleSelectedItem(item),
      );
    }
  }

  Widget _itemWidgetMultiSelection(T item) {
    final isDisabled = _isDisabled(item);

    if (widget.props.checkBoxBuilder != null) {
      return CheckBoxWidget(
        clickProps: widget.props.itemClickProps,
        checkBox: (cxt, checked) {
          return widget.props.checkBoxBuilder!(
            cxt,
            item,
            isDisabled,
            checked,
            _handleSelectedItem,
          );
        },
        interceptCallBacks: widget.props.interceptCallBacks,
        textDirection: widget.props.textDirection,
        layout: (context, isChecked) => _itemWidgetSingleSelection(item),
        isChecked: _isSelectedItem(item),
        isDisabled: isDisabled,
        onSelected: (c) => _handleSelectedItem(item),
        uiToApply: widget.uiMode,
      );
    } else {
      return CheckBoxWidget(
        clickProps: widget.props.itemClickProps,
        textDirection: widget.props.textDirection,
        interceptCallBacks: widget.props.interceptCallBacks,
        layout: (context, isChecked) => _itemWidgetSingleSelection(item),
        isChecked: _isSelectedItem(item),
        isDisabled: isDisabled,
        onSelected: (c) => _handleSelectedItem(item),
        uiToApply: widget.uiMode,
      );
    }
  }

  bool _isDisabled(T item) => widget.props.disabledItemFn?.call(item) == true;

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
    final textField = widget.uiMode == UiToApply.cupertino
        ? CustomCupertinoTextFields(
            props: widget.props.searchFieldProps as CupertinoTextFieldProps,
            controller: searchBoxController,
          )
        : CustomTextFields(
            props: widget.props.searchFieldProps as TextFieldProps,
            controller: searchBoxController,
          );

    if (widget.props.searchFieldProps.containerBuilder != null) {
      return widget.props.searchFieldProps.containerBuilder!(
          context, textField);
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: textField,
    );
  }

  Widget _suggestedItemsWidget() {
    if (!widget.props.suggestionsProps.showSuggestions) {
      return SizedBox.shrink();
    }

    return StreamBuilder<List<T>>(
      stream: _itemsStream.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return SuggestionsWidget<T>(
            dropdownItems: snapshot.data!,
            props: widget.props.suggestionsProps,
            isSelectedItemFn: (item) => _isSelectedItem(item),
            isDisabledItemFn: (item) => _isDisabled(item),
            itemAsString: (item) => _itemAsString(item),
            onClick: (value) => _handleSelectedItem(value),
            uiToApply: widget.uiMode,
          );
        } else {
          return SizedBox.shrink();
        }
      },
    );
  }

  void _handleSelectedItem(T newSelectedItem) {
    if (widget.isMultiSelectionMode) {
      if (_isSelectedItem(newSelectedItem)) {
        _selectedItemsNotifier.value = List.from(_selectedItems)
          ..removeWhere((i) => _isEqual(newSelectedItem, i));
        if (widget.props.onItemRemoved != null) {
          widget.props.onItemRemoved!(_selectedItems, newSelectedItem);
        }
      } else {
        _selectedItemsNotifier.value = List.from(_selectedItems)
          ..add(newSelectedItem);
        if (widget.props.onItemAdded != null) {
          widget.props.onItemAdded!(_selectedItems, newSelectedItem);
        }
      }
    } else {
      _closePopup();
      if (widget.onSelected != null) {
        widget.onSelected!(List.filled(1, newSelectedItem));
      }
    }
  }

  ///function that return the String value of an object
  String _itemAsString(T data) {
    if (data == null) {
      return "";
    } else if (widget.itemAsString != null) {
      return widget.itemAsString!(data);
    } else {
      return data.toString();
    }
  }

  ///close popup
  void _closePopup() => widget.onClose?.call();

  Future<void> loadMoreItems(String filter, int skip) {
    return _manageLoadMoreItems(filter, skip: skip, showLoading: true);
  }

  Future<void> reloadItems(String filter) {
    return _manageLoadItems(filter, isFirstLoad: true);
  }

  void selectItems(List<T> itemsToSelect) {
    for (var i in itemsToSelect) {
      if (!_isSelectedItem(i) /*check if the item is already selected*/ &&
          !_isDisabled(i) /*escape disabled items*/) {
        _selectedItems.add(i);
        if (widget.props.onItemAdded != null) {
          widget.props.onItemAdded!(_selectedItems, i);
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
        if (widget.props.onItemRemoved != null) {
          widget.props.onItemRemoved!(_selectedItems, i);
        }
      }
    }
    _selectedItemsNotifier.value = List.from(_selectedItems);
  }

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
