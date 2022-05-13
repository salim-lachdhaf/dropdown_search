import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../dropdown_search.dart';
import 'widgets/checkbox_widget.dart';

class SelectionWidget<T> extends StatefulWidget {
  final List<T>? items;
  final ValueChanged<List<T>>? onChanged;
  final DropdownSearchOnFind<T>? asyncItems;
  final DropdownSearchItemAsString<T>? itemAsString;
  final DropdownSearchFilterFn<T>? filterFn;
  final DropdownSearchCompareFn<T>? compareFn;
  final List<T> defaultSelectedItems;
  final PopupProps<T> popupProps;
  final bool isMultiSelectionMode;

  const SelectionWidget({
    Key? key,
    this.popupProps = const PopupProps(),
    this.defaultSelectedItems = const [],
    this.isMultiSelectionMode = false,
    this.items,
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
  late Debouncer _debouncer;

  List<T> get _selectedItems => _selectedItemsNotifier.value;

  @override
  void initState() {
    super.initState();
    _debouncer = Debouncer(delay: widget.popupProps.searchDelay);
    _selectedItemsNotifier.value = widget.defaultSelectedItems;

    widget.popupProps.searchFieldProps.controller?.addListener(() {
      _debouncer(() {
        _onTextChanged(widget.popupProps.searchFieldProps.controller!.text);
      });
    });

    Future.delayed(
      Duration.zero,
      () => _manageItemsByFilter(
        widget.popupProps.searchFieldProps.controller?.text ?? '',
        isFirstLoad: true,
      ),
    );
  }

  @override
  void didUpdateWidget(covariant SelectionWidget<T> oldWidget) {
    if (!listEquals(
        oldWidget.defaultSelectedItems, widget.defaultSelectedItems)) {
      _selectedItemsNotifier.value = widget.defaultSelectedItems;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _itemsStream.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: Colors.orange,
          child: Text('test'),
        ),
        ValueListenableBuilder(
            valueListenable: _selectedItemsNotifier,
            builder: (ctx, value, wdgt) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  _searchField(),
                  _favoriteItemsWidget(),
                  Flexible(
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
                            return Scrollbar(
                              controller:
                                  widget.popupProps.scrollbarProps?.controller,
                              thumbVisibility: widget
                                  .popupProps.scrollbarProps?.thumbVisibility,
                              trackVisibility: widget
                                  .popupProps.scrollbarProps?.trackVisibility,
                              thickness:
                                  widget.popupProps.scrollbarProps?.thickness,
                              radius: widget.popupProps.scrollbarProps?.radius,
                              notificationPredicate: widget.popupProps
                                  .scrollbarProps?.notificationPredicate,
                              interactive:
                                  widget.popupProps.scrollbarProps?.interactive,
                              child: ListView.builder(
                                shrinkWrap:
                                    widget.popupProps.listViewProps.shrinkWrap,
                                padding:
                                    widget.popupProps.listViewProps.padding,
                                scrollDirection: widget
                                    .popupProps.listViewProps.scrollDirection,
                                reverse:
                                    widget.popupProps.listViewProps.reverse,
                                controller:
                                    widget.popupProps.listViewProps.controller,
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
            }),
      ],
    );
  }

  ///validation of selected items
  void onValidate() {
    closePopup();
    if (widget.onChanged != null) widget.onChanged!(_selectedItems);
  }

  ///close popup
  void closePopup() {
    Navigator.pop(context);
  }

  Widget _multiSelectionValidation() {
    if (!widget.isMultiSelectionMode) return Container();

    Widget defaultValidation = Padding(
      padding: EdgeInsets.all(8),
      child: ElevatedButton(
        onPressed: onValidate,
        child: Text("OK"),
      ),
    );

    Widget popupCustomMultiSelectionWidget() {
      if (widget.popupProps.popupCustomMultiSelectionWidget != null) {
        return widget.popupProps.popupCustomMultiSelectionWidget!(
            context, _selectedItems);
      }
      return Container();
    }

    Widget popupValidationMultiSelectionWidget() {
      if (widget.popupProps.popupValidationMultiSelectionWidget != null) {
        return InkWell(
          child: IgnorePointer(
            ignoring: true,
            child: widget.popupProps.popupValidationMultiSelectionWidget!(
                context, _selectedItems),
          ),
          onTap: onValidate,
        );
      }
      return defaultValidation;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.max,
      children: [
        popupCustomMultiSelectionWidget(),
        popupValidationMultiSelectionWidget(),
      ],
    );
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
        widget.popupProps.searchFieldProps.controller?.text,
      );
    else
      return const Center(
        child: const Text("No data found"),
      );
  }

  Widget _errorWidget(dynamic error) {
    if (widget.popupProps.errorBuilder != null)
      return widget.popupProps.errorBuilder!(
        context,
        widget.popupProps.searchFieldProps.controller?.text,
        error,
      );
    else
      return Padding(
        padding: EdgeInsets.all(8),
        child: Text(
          error?.toString() ?? 'Error',
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
                widget.popupProps.searchFieldProps.controller?.text,
              );
            else
              return Padding(
                padding: const EdgeInsets.all(24.0),
                child: const Center(
                  child: const CircularProgressIndicator(),
                ),
              );
          }
          return const SizedBox.shrink();
        });
  }

  void _onTextChanged(String filter) async {
    _manageItemsByFilter(filter);
  }

  ///Function that filter item (online and offline) base on user filter
  ///[filter] is the filter keyword
  ///[isFirstLoad] true if it's the first time we load data from online, false other wises
  void _manageItemsByFilter(String filter, {bool isFirstLoad = false}) async {
    _loadingNotifier.value = true;

    List<T> applyFilter(String? filter) {
      return _cachedItems.where((i) {
        if (widget.filterFn != null)
          return (widget.filterFn!(i, filter));
        else if (i
            .toString()
            .toLowerCase()
            .contains(filter?.toLowerCase() ?? 'null'))
          return true;
        else if (widget.itemAsString != null) {
          return (widget.itemAsString!(i))
              .toLowerCase()
              .contains(filter?.toLowerCase() ?? 'null');
        }
        return false;
      }).toList();
    }

    //load offline data for the first time
    if (isFirstLoad && widget.items != null) _cachedItems.addAll(widget.items!);

    //manage offline items
    if (widget.asyncItems != null &&
        (widget.popupProps.isFilterOnline || isFirstLoad)) {
      try {
        final List<T> onlineItems = [];
        onlineItems.addAll(await widget.asyncItems!(filter));

        //Remove all old data
        _cachedItems.clear();
        //add offline items
        if (widget.items != null) {
          _cachedItems.addAll(widget.items!);
          //if filter online we filter only local list based on entered keyword (filter)
          if (widget.popupProps.isFilterOnline == true) {
            var filteredLocalList = applyFilter(filter);
            _cachedItems.clear();
            _cachedItems.addAll(filteredLocalList);
          }
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
        if (widget.items != null && widget.items!.isNotEmpty) {
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
  }

  void _addErrorToStream(Object error, [StackTrace? stackTrace]) {
    if (_itemsStream.isClosed) return;
    _itemsStream.addError(error, stackTrace);
  }

  Widget _itemWidgetSingleSelection(T item) {
    return (widget.popupProps.itemBuilder != null)
        ? InkWell(
            // ignore pointers in itemBuilder
            child: IgnorePointer(
              ignoring: true,
              child: widget.popupProps.itemBuilder!(
                context,
                item,
                !widget.popupProps.showSelectedItems
                    ? false
                    : _isSelectedItem(item),
              ),
            ),
            onTap: _isDisabled(item) ? null : () => _handleSelectedItem(item),
          )
        : ListTile(
            enabled: !_isDisabled(item),
            title: Text(_selectedItemAsString(item)),
            selected: !widget.popupProps.showSelectedItems
                ? false
                : _isSelectedItem(item),
            onTap: _isDisabled(item) ? null : () => _handleSelectedItem(item),
          );
  }

  Widget _itemWidgetMultiSelection(T item) {
    if (widget.popupProps.popupSelectionWidget != null)
      return CheckBoxWidget(
        checkBox: (cnt, checked) {
          return widget.popupProps.popupSelectionWidget!(
              context, item, checked);
        },
        layout: (context, isChecked) => _itemWidgetSingleSelection(item),
        isChecked: _isSelectedItem(item),
        isDisabled: _isDisabled(item),
        onChanged: (c) => _handleSelectedItem(item),
      );
    else
      return CheckBoxWidget(
        layout: (context, isChecked) => _itemWidgetSingleSelection(item),
        isChecked: _isSelectedItem(item),
        isDisabled: _isDisabled(item),
        onChanged: (c) => _handleSelectedItem(item),
      );
  }

  bool _isDisabled(T item) =>
      widget.popupProps.DisabledItemFn != null &&
      (widget.popupProps.DisabledItemFn!(item)) == true;

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
                    SingleActivator(LogicalKeyboardKey.space):
                        DoNothingAndStopPropagationTextIntent(),
                  },
                  child: TextField(
                    onChanged: (f) {
                      //if controller !=null , the change event will be handled by
                      // the controller
                      if (widget.popupProps.searchFieldProps.controller == null)
                        _debouncer(() {
                          _onTextChanged(f);
                        });
                    },
                    enableIMEPersonalizedLearning: widget.popupProps
                        .searchFieldProps.enableIMEPersonalizedLearning,
                    clipBehavior:
                        widget.popupProps.searchFieldProps.clipBehavior,
                    style: widget.popupProps.searchFieldProps.style,
                    controller: widget.popupProps.searchFieldProps.controller,
                    focusNode: widget.popupProps.focusNode,
                    autofocus: widget.popupProps.searchFieldProps.autofocus,
                    decoration: widget.popupProps.searchFieldProps.decoration,
                    keyboardType:
                        widget.popupProps.searchFieldProps.keyboardType,
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
                    toolbarOptions:
                        widget.popupProps.searchFieldProps.toolbarOptions,
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
                    cursorHeight:
                        widget.popupProps.searchFieldProps.cursorHeight,
                    cursorRadius:
                        widget.popupProps.searchFieldProps.cursorRadius,
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
                    buildCounter:
                        widget.popupProps.searchFieldProps.buildCounter,
                    scrollController:
                        widget.popupProps.searchFieldProps.scrollController,
                    scrollPhysics:
                        widget.popupProps.searchFieldProps.scrollPhysics,
                    autofillHints:
                        widget.popupProps.searchFieldProps.autofillHints,
                    restorationId:
                        widget.popupProps.searchFieldProps.restorationId,
                  ),
                ),
              ),
            )
        ]);
  }

  Widget _favoriteItemsWidget() {
    if (widget.popupProps.showFavoriteItems == true &&
        widget.popupProps.favoriteItems != null) {
      return StreamBuilder<List<T>>(
          stream: _itemsStream.stream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return _buildFavoriteItems(
                  widget.popupProps.favoriteItems!(snapshot.data!));
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
                mainAxisAlignment: widget.popupProps.favoriteItemsAlignment,
                children: favoriteItems
                    .map(
                      (f) => InkWell(
                        onTap: () => _handleSelectedItem(f),
                        child: Container(
                          margin: EdgeInsets.only(right: 4),
                          child: widget.popupProps.favoriteItemBuilder != null
                              ? widget.popupProps.favoriteItemBuilder!(
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
        _selectedItemsNotifier.value = List.from(_selectedItems)
          ..removeWhere((i) => _isEqual(newSelectedItem, i));
        if (widget.popupProps.popupOnItemRemoved != null)
          widget.popupProps.popupOnItemRemoved!(
              _selectedItems, newSelectedItem);
      } else {
        _selectedItemsNotifier.value = List.from(_selectedItems)
          ..add(newSelectedItem);
        if (widget.popupProps.popupOnItemAdded != null)
          widget.popupProps.popupOnItemAdded!(_selectedItems, newSelectedItem);
      }
    } else {
      closePopup();
      if (widget.onChanged != null)
        widget.onChanged!(List.filled(1, newSelectedItem));
    }
  }

  Widget _favoriteItemDefaultWidget(T item) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).primaryColorLight),
      child: Row(
        children: [
          Text(
            _selectedItemAsString(item),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.subtitle1,
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
      if (!_isSelectedItem(i) /*check if the item is already selected*/ &&
          !_isDisabled(i) /*escape disabled items*/) {
        newSelectedItems.add(i);
        if (widget.popupProps.popupOnItemAdded != null)
          widget.popupProps.popupOnItemAdded!(_selectedItems, i);
      }
    });
    _selectedItemsNotifier.value = List.from(newSelectedItems);
  }

  void selectAllItems() {
    selectItems(_cachedItems);
  }

  void deselectItems(List<T> itemsToDeselect) {
    List<T> newSelectedItems = _selectedItems;
    itemsToDeselect.forEach((i) {
      var index = _itemIndexInList(newSelectedItems, i);
      if (index > -1) /*check if the item is already selected*/ {
        newSelectedItems.removeAt(index);
        if (widget.popupProps.popupOnItemRemoved != null)
          widget.popupProps.popupOnItemRemoved!(_selectedItems, i);
      }
    });
    _selectedItemsNotifier.value = List.from(newSelectedItems);
  }

  void deselectAllItems() {
    deselectItems(_cachedItems);
  }
}

class Debouncer {
  final Duration? delay;
  Timer? _timer;

  Debouncer({this.delay});

  void call(Function action) {
    _timer?.cancel();
    _timer = Timer(
        delay ?? const Duration(milliseconds: 500), action as void Function());
  }
}
