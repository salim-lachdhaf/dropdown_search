import 'dart:async';
import 'dart:ui' as ui show BoxHeightStyle, BoxWidthStyle;

import 'package:dropdown_search/src/selection_list_view_props.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import './scrollbar_props.dart';
import './text_field_props.dart';
import '../dropdown_search.dart';
import 'checkbox_widget.dart';

class SelectionWidget<T> extends StatefulWidget {
  final List<T> selectedValues;
  final List<T>? items;
  final bool showSearchBox;
  final bool isFilteredOnline;
  final ValueChanged<List<T>>? onChanged;
  final DropdownSearchOnFind<T>? onFind;
  final DropdownSearchPopupItemBuilder<T>? itemBuilder;
  final DropdownSearchItemAsString<T>? itemAsString;
  final DropdownSearchFilterFn<T>? filterFn;
  final String? hintText;

  final double? maxHeight;
  final double? dialogMaxWidth;
  final Widget? popupTitle;
  final bool showSelectedItems;
  final DropdownSearchCompareFn<T>? compareFn;
  final DropdownSearchPopupItemEnabled<T>? itemDisabled;

  ///custom layout for empty results
  final EmptyBuilder? emptyBuilder;

  ///custom layout for loading items
  final LoadingBuilder? loadingBuilder;

  ///custom layout for error
  final ErrorBuilder? errorBuilder;

  ///delay before searching
  final Duration? searchDelay;

  ///show or hide favorites items
  final bool showFavoriteItems;

  ///build favorites chips
  final FavoriteItemsBuilder<T>? favoriteItemBuilder;

  ///favorite items alignment
  final MainAxisAlignment? favoriteItemsAlignment;

  ///favorites item
  final FavoriteItems<T>? favoriteItems;

  /// object that passes all props to search field
  final TextFieldProps? searchFieldProps;

  /// scrollbar properties
  final ScrollbarProps? scrollbarProps;

  final bool isMultiSelectionMode;

  /// callback executed before applying values changes
  final BeforeChangeMultiSelection<T>? onBeforeChangeMultiSelection;

  ///called when a new item added on Multi selection mode
  final OnItemAdded<T>? popupOnItemAdded;

  ///called when a new item added on Multi selection mode
  final OnItemRemoved<T>? popupOnItemRemoved;

  ///widget used to show checked items in multiSelection mode
  final DropdownSearchPopupItemBuilder<T>? popupSelectionWidget;

  ///widget used to validate items in multiSelection mode
  final ValidationMultiSelectionBuilder<T>? popupValidationMultiSelectionWidget;

  /// props for selection list view
  final SelectionListViewProps selectionListViewProps;

  /// props for selection focus node
  final FocusNode focusNode;

  const SelectionWidget({
    Key? key,
    this.popupTitle,
    this.items,
    this.maxHeight,
    this.showSearchBox = false,
    this.isFilteredOnline = false,
    this.onChanged,
    this.selectedValues = const [],
    this.onFind,
    this.itemBuilder,
    this.hintText,
    this.itemAsString,
    this.filterFn,
    this.showSelectedItems = false,
    this.compareFn,
    this.emptyBuilder,
    this.loadingBuilder,
    this.errorBuilder,
    this.dialogMaxWidth,
    this.itemDisabled,
    this.searchDelay,
    this.favoriteItemBuilder,
    this.favoriteItems,
    this.searchFieldProps,
    this.showFavoriteItems = false,
    this.favoriteItemsAlignment = MainAxisAlignment.start,
    this.scrollbarProps,
    this.onBeforeChangeMultiSelection,
    this.popupOnItemAdded,
    this.popupOnItemRemoved,
    this.popupSelectionWidget,
    this.isMultiSelectionMode = false,
    this.popupValidationMultiSelectionWidget,
    this.selectionListViewProps = const SelectionListViewProps(),
    required this.focusNode,
  }) : super(key: key);

  @override
  _SelectionWidgetState<T> createState() => _SelectionWidgetState<T>();
}

class _SelectionWidgetState<T> extends State<SelectionWidget<T>> {
  final FocusNode focusNode = new FocusNode();
  final StreamController<List<T>> _itemsStream = StreamController.broadcast();
  final ValueNotifier<bool> _loadingNotifier = ValueNotifier(false);
  final List<T> _syncItems = [];
  final ValueNotifier<List<T>> _selectedItemsNotifier = ValueNotifier([]);
  late Debouncer _debouncer;

  List<T> get _selectedItems => _selectedItemsNotifier.value;

  @override
  void initState() {
    super.initState();
    _debouncer = Debouncer(delay: widget.searchDelay);
    _selectedItemsNotifier.value = widget.selectedValues;

    Future.delayed(
      Duration.zero,
      () => _manageItemsByFilter(
          widget.searchFieldProps?.controller?.text ?? '',
          isFistLoad: true),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.searchFieldProps?.autofocus == true) //handle null and false
      FocusScope.of(context).requestFocus(focusNode);
  }

  @override
  void dispose() {
    _itemsStream.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    bool isTablet = deviceSize.width > deviceSize.height;
    double maxHeight = deviceSize.height * (isTablet ? .8 : .6);
    double maxWidth = deviceSize.width * (isTablet ? .7 : .9);

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(),
      width: widget.dialogMaxWidth ?? maxWidth,
      constraints: BoxConstraints(maxHeight: widget.maxHeight ?? maxHeight),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _searchField(),
          _favoriteItemsWidget(),
          Expanded(
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
                      if (widget.emptyBuilder != null)
                        return widget.emptyBuilder!(
                          context,
                          widget.searchFieldProps?.controller?.text,
                        );
                      else
                        return const Center(
                          child: const Text("No data found"),
                        );
                    }
                    return MediaQuery.removePadding(
                      removeBottom: true,
                      removeTop: true,
                      context: context,
                      child: Scrollbar(
                        controller: widget.scrollbarProps?.controller,
                        isAlwaysShown: widget.scrollbarProps?.isAlwaysShown,
                        showTrackOnHover:
                            widget.scrollbarProps?.showTrackOnHover,
                        hoverThickness: widget.scrollbarProps?.hoverThickness,
                        thickness: widget.scrollbarProps?.thickness,
                        radius: widget.scrollbarProps?.radius,
                        notificationPredicate:
                            widget.scrollbarProps?.notificationPredicate,
                        interactive: widget.scrollbarProps?.interactive,
                        child: ListView.builder(
                          shrinkWrap: widget.selectionListViewProps.shrinkWrap,
                          padding: widget.selectionListViewProps.padding,
                          scrollDirection:
                              widget.selectionListViewProps.scrollDirection,
                          reverse: widget.selectionListViewProps.reverse,
                          controller: widget.selectionListViewProps.controller,
                          primary: widget.selectionListViewProps.primary,
                          physics: widget.selectionListViewProps.physics,
                          itemExtent: widget.selectionListViewProps.itemExtent,
                          addAutomaticKeepAlives: widget
                              .selectionListViewProps.addAutomaticKeepAlives,
                          addRepaintBoundaries: widget
                              .selectionListViewProps.addRepaintBoundaries,
                          addSemanticIndexes:
                              widget.selectionListViewProps.addSemanticIndexes,
                          cacheExtent:
                              widget.selectionListViewProps.cacheExtent,
                          semanticChildCount:
                              widget.selectionListViewProps.semanticChildCount,
                          dragStartBehavior:
                              widget.selectionListViewProps.dragStartBehavior,
                          keyboardDismissBehavior: widget
                              .selectionListViewProps.keyboardDismissBehavior,
                          restorationId:
                              widget.selectionListViewProps.restorationId,
                          clipBehavior:
                              widget.selectionListViewProps.clipBehavior,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            var item = snapshot.data![index];
                            return widget.isMultiSelectionMode
                                ? _itemWidgetMultiSelection(item)
                                : _itemWidgetSingleSelection(item);
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
      ),
    );
  }

  Widget _multiSelectionValidation() {
    if (!widget.isMultiSelectionMode) return Container();

    final onValidate = () {
      Navigator.pop(context);
      if (widget.onChanged != null) widget.onChanged!(_selectedItems);
    };
    if (widget.popupValidationMultiSelectionWidget != null)
      return InkWell(
        child: widget.popupValidationMultiSelectionWidget!(
            context, _selectedItems),
        onTap: onValidate,
      );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        Divider(),
        Padding(
          padding: const EdgeInsets.only(bottom: 8, left: 8, right: 8),
          child: ElevatedButton(
            onPressed: onValidate,
            child: Text("OK"),
          ),
        )
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

  Widget _errorWidget(dynamic error) {
    if (widget.errorBuilder != null)
      return widget.errorBuilder!(
        context,
        widget.searchFieldProps?.controller?.text,
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
            if (widget.loadingBuilder != null)
              return widget.loadingBuilder!(
                context,
                widget.searchFieldProps?.controller?.text,
              );
            else
              return Padding(
                padding: const EdgeInsets.all(24.0),
                child: const Center(
                  child: const CircularProgressIndicator(),
                ),
              );
          }
          return Container();
        });
  }

  void _onTextChanged(String filter) async {
    _manageItemsByFilter(filter);
  }

  ///Function that filter item (online and offline) base on user filter
  ///[filter] is the filter keyword
  ///[isFirstLoad] true if it's the first time we load data from online, false other wises
  void _manageItemsByFilter(String filter, {bool isFistLoad = false}) async {
    _loadingNotifier.value = true;

    List<T> applyFilter(String? filter) {
      return _syncItems.where((i) {
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
    if (isFistLoad && widget.items != null) _syncItems.addAll(widget.items!);

    //manage offline items
    if (widget.onFind != null && (widget.isFilteredOnline || isFistLoad)) {
      try {
        final List<T> onlineItems = [];
        onlineItems.addAll(await widget.onFind!(filter));

        //Remove all old data
        _syncItems.clear();
        //add offline items
        if (widget.items != null) {
          _syncItems.addAll(widget.items!);
          //if filter online we filter only local list based on entered keyword (filter)
          if (widget.isFilteredOnline == true) {
            var filteredLocalList = applyFilter(filter);
            _syncItems.clear();
            _syncItems.addAll(filteredLocalList);
          }
        }
        //add new online items to list
        _syncItems.addAll(onlineItems);

        //don't filter data , they are already filtered online and local data are already filtered
        if (widget.isFilteredOnline == true)
          _addDataToStream(_syncItems);
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
    return (widget.itemBuilder != null)
        ? InkWell(
            // ignore pointers in itemBuilder
            child: IgnorePointer(
              ignoring: true,
              child: widget.itemBuilder!(
                context,
                item,
                !widget.showSelectedItems ? false : _isSelectedItem(item),
              ),
            ),
            onTap: _isDisabled(item) ? null : () => _handleSelectedItem(item),
          )
        : ListTile(
            enabled: !_isDisabled(item),
            title: Text(_selectedItemAsString(item)),
            selected: !widget.showSelectedItems ? false : _isSelectedItem(item),
            onTap: _isDisabled(item) ? null : () => _handleSelectedItem(item),
          );
  }

  Widget _itemWidgetMultiSelection(T item) {
    if (widget.popupSelectionWidget != null)
      return CheckBoxWidget(
        checkBox: (cnt, checked) {
          return widget.popupSelectionWidget!(context, item, checked);
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
      widget.itemDisabled != null && (widget.itemDisabled!(item)) == true;

  /// selected item will be highlighted only when [widget.showSelectedItems] is true,
  /// if our object is String [widget.compareFn] is not required , other wises it's required
  bool _isSelectedItem(T item) {
    if (widget.compareFn != null)
      return _selectedItems.where((i) => widget.compareFn!(item, i)).isNotEmpty;
    else
      return _selectedItems.contains(item);
  }

  Widget _searchField() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          widget.popupTitle ?? const SizedBox.shrink(),
          if (widget.showSearchBox)
            Padding(
              padding:
                  widget.searchFieldProps?.padding ?? const EdgeInsets.all(8.0),
              child: TextField(
                style: widget.searchFieldProps?.style,
                controller: widget.searchFieldProps?.controller,
                focusNode: focusNode,
                onChanged: (f) => _debouncer(() {
                  _onTextChanged(f);
                }),
                decoration: widget.searchFieldProps?.decoration ??
                    InputDecoration(
                      hintText: widget.hintText,
                      border: const OutlineInputBorder(),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16),
                    ),
                keyboardType: widget.searchFieldProps?.keyboardType,
                textInputAction: widget.searchFieldProps?.textInputAction,
                textCapitalization:
                    widget.searchFieldProps?.textCapitalization ??
                        TextCapitalization.none,
                strutStyle: widget.searchFieldProps?.strutStyle,
                textAlign:
                    widget.searchFieldProps?.textAlign ?? TextAlign.start,
                textAlignVertical: widget.searchFieldProps?.textAlignVertical,
                textDirection: widget.searchFieldProps?.textDirection,
                readOnly: widget.searchFieldProps?.readOnly ?? false,
                toolbarOptions: widget.searchFieldProps?.toolbarOptions,
                showCursor: widget.searchFieldProps?.showCursor,
                obscuringCharacter:
                    widget.searchFieldProps?.obscuringCharacter ?? '•',
                obscureText: widget.searchFieldProps?.obscureText ?? false,
                autocorrect: widget.searchFieldProps?.autocorrect ?? true,
                smartDashesType: widget.searchFieldProps?.smartDashesType,
                smartQuotesType: widget.searchFieldProps?.smartQuotesType,
                enableSuggestions:
                    widget.searchFieldProps?.enableSuggestions ?? true,
                maxLines: widget.searchFieldProps?.maxLines ?? 1,
                minLines: widget.searchFieldProps?.minLines,
                expands: widget.searchFieldProps?.expands ?? false,
                maxLengthEnforcement:
                    widget.searchFieldProps?.maxLengthEnforcement,
                maxLength: widget.searchFieldProps?.maxLength,
                onAppPrivateCommand:
                    widget.searchFieldProps?.onAppPrivateCommand,
                inputFormatters: widget.searchFieldProps?.inputFormatters,
                enabled: widget.searchFieldProps?.enabled,
                cursorWidth: widget.searchFieldProps?.cursorWidth ?? 2.0,
                cursorHeight: widget.searchFieldProps?.cursorHeight,
                cursorRadius: widget.searchFieldProps?.cursorRadius,
                cursorColor: widget.searchFieldProps?.cursorColor,
                selectionHeightStyle:
                    widget.searchFieldProps?.selectionHeightStyle ??
                        ui.BoxHeightStyle.tight,
                selectionWidthStyle:
                    widget.searchFieldProps?.selectionWidthStyle ??
                        ui.BoxWidthStyle.tight,
                keyboardAppearance: widget.searchFieldProps?.keyboardAppearance,
                scrollPadding: widget.searchFieldProps?.scrollPadding ??
                    const EdgeInsets.all(20.0),
                dragStartBehavior: widget.searchFieldProps?.dragStartBehavior ??
                    DragStartBehavior.start,
                enableInteractiveSelection:
                    widget.searchFieldProps?.enableInteractiveSelection ?? true,
                selectionControls: widget.searchFieldProps?.selectionControls,
                onTap: widget.searchFieldProps?.onTap,
                mouseCursor: widget.searchFieldProps?.mouseCursor,
                buildCounter: widget.searchFieldProps?.buildCounter,
                scrollController: widget.searchFieldProps?.scrollController,
                scrollPhysics: widget.searchFieldProps?.scrollPhysics,
                autofillHints: widget.searchFieldProps?.autofillHints,
                restorationId: widget.searchFieldProps?.restorationId,
              ),
            )
        ]);
  }

  Widget _favoriteItemsWidget() {
    if (widget.showFavoriteItems == true) {
      return StreamBuilder<List<T>>(
          stream: _itemsStream.stream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return _buildFavoriteItems(widget.favoriteItems!(snapshot.data!));
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
                mainAxisAlignment:
                    widget.favoriteItemsAlignment ?? MainAxisAlignment.start,
                children: favoriteItems
                    .map(
                      (f) => InkWell(
                        onTap: () => _handleSelectedItem(f),
                        child: Container(
                          margin: EdgeInsets.only(right: 4),
                          child: widget.favoriteItemBuilder != null
                              ? widget.favoriteItemBuilder!(context, f)
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
          ..remove(newSelectedItem);
        if (widget.popupOnItemRemoved != null)
          widget.popupOnItemRemoved!(_selectedItems, newSelectedItem);
      } else {
        _selectedItemsNotifier.value = List.from(_selectedItems)
          ..add(newSelectedItem);
        if (widget.popupOnItemAdded != null)
          widget.popupOnItemAdded!(_selectedItems, newSelectedItem);
      }
    } else {
      Navigator.pop(context);
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
      child: Text(
        _selectedItemAsString(item),
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.subtitle1,
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
