import 'dart:async';
import 'package:flutter/material.dart';
import 'dropdownSearch.dart';

class SelectDialog<T> extends StatefulWidget {
  final T selectedValue;
  final List<T> items;
  final bool showSearchBox;
  final bool isFilteredOnline;
  final DropdownSearchOnChanged<T> onChange;
  final DropdownSearchOnFind<T> onFind;
  final DropdownSearchItemBuilder<T> itemBuilder;
  final InputDecoration searchBoxDecoration;
  final TextStyle dialogTitleStyle;
  final DropdownSearchItemAsString<T> itemAsString;
  final DropdownSearchFilterFn<T> filterFn;
  final String hintText;
  final double maxHeight;
  final String dialogTitle;
  final bool showSelectedItem;
  final DropdownSearchCompareFn<T> compareFn;

  ///custom layout for empty results
  final WidgetBuilder emptyBuilder;

  ///custom layout for loading items
  final WidgetBuilder loadingBuilder;

  ///custom layout for error
  final ErrorBuilder errorBuilder;

  ///the search box will be focused if true
  final bool autoFocusSearchBox;

  const SelectDialog(
      {Key key,
      this.dialogTitle,
      this.items,
      this.maxHeight,
      this.showSearchBox = true,
      this.isFilteredOnline = false,
      this.onChange,
      this.selectedValue,
      this.onFind,
      this.itemBuilder,
      this.searchBoxDecoration,
      this.dialogTitleStyle =
          const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      this.hintText,
      this.itemAsString,
      this.filterFn,
      this.showSelectedItem = false,
      this.compareFn,
      this.emptyBuilder,
      this.loadingBuilder,
      this.errorBuilder,
      this.autoFocusSearchBox = false})
      : super(key: key);

  @override
  _SelectDialogState<T> createState() => _SelectDialogState<T>();
}

class _SelectDialogState<T> extends State<SelectDialog<T>> {
  final FocusNode focusNode = new FocusNode();
  final StreamController<List<T>> _itemsStream = StreamController();
  final ValueNotifier<bool> _loadingNotifier = ValueNotifier(false);

  final List<T> _items = List<T>();
  final _debouncer = Debouncer();

  @override
  void initState() {
    super.initState();
    Future.delayed(
        Duration.zero, () => manageItemsByFilter("", isFistLoad: true));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.autoFocusSearchBox)
      FocusScope.of(context).requestFocus(focusNode);
  }

  @override
  void dispose() {
    _itemsStream.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.height * .9,
      height: widget.maxHeight ?? MediaQuery.of(context).size.height * .7,
      child: Column(
        children: <Widget>[
          _searchField(),
          Expanded(
            child: Stack(
              children: <Widget>[
                StreamBuilder<List<T>>(
                  stream: _itemsStream.stream,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return _errorWidget(snapshot?.error);
                    } else if (!snapshot.hasData) {
                      return _loadingWidget();
                    } else if (snapshot.data.isEmpty) {
                      if (widget.emptyBuilder != null)
                        return widget.emptyBuilder(context);
                      else
                        return Center(child: Text("No data found"));
                    }
                    return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        var item = snapshot.data[index];
                        return _itemWidget(item);
                      },
                    );
                  },
                ),
                _loadingWidget()
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(dynamic error) {
    showDialog(
        context: context,
        barrierDismissible: false,
        child: AlertDialog(
          title: Text("Error while getting online items"),
          content: _errorWidget(error),
          actions: <Widget>[
            FlatButton(
              child: new Text("OK"),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            )
          ],
        ));
  }

  Widget _errorWidget(dynamic error) {
    if (widget.errorBuilder != null)
      return widget.errorBuilder(context, error);
    else
      return Center(child: Text(error?.toString()));
  }

  Widget _loadingWidget() {
    return ValueListenableBuilder(
        valueListenable: _loadingNotifier,
        builder: (context, bool isLoading, wid) {
          if (isLoading) {
            if (widget.loadingBuilder != null)
              return widget.loadingBuilder(context);
            else
              return Center(child: CircularProgressIndicator());
          }
          return Container();
        });
  }

  void _onTextChanged(String filter) async {
    manageItemsByFilter(filter);
  }

  ///Function that filter item (online and offline) base on user filter
  ///[filter] is the filter keyword
  ///[isFistLoad] true if it's the first time we load data from online, false other wises
  void manageItemsByFilter(String filter, {bool isFistLoad = false}) async {
    _loadingNotifier.value = true;

    List<T> applyFilter(String filter) {
      return _items.where((i) {
        if (widget.filterFn != null)
          return (widget.filterFn(i, filter));
        else if (i.toString().toLowerCase().contains(filter.toLowerCase()))
          return true;
        else if (widget.itemAsString != null) {
          return (widget.itemAsString(i))
                  ?.toLowerCase()
                  ?.contains(filter.toLowerCase()) ??
              false;
        }
        return false;
      }).toList();
    }

    //load offline data for the first time
    if (isFistLoad && widget.items != null) _items.addAll(widget.items);

    //manage offline items
    if (widget.onFind != null && (widget.isFilteredOnline || isFistLoad)) {
      try {
        final List<T> onlineItems = List();
        onlineItems.addAll(await widget.onFind(filter) ?? List());

        //Remove all old data
        _items.clear();
        //add offline items
        if (widget.items != null) _items.addAll(widget.items);
        //add new online items to list
        _items.addAll(onlineItems);
      } catch (e) {
        _itemsStream.addError(e);
        //if offline items count > 0 , the error will be not visible for the user
        //As solution we show it in dialog
        if (widget.items != null && widget.items.isNotEmpty) {
          _showErrorDialog(e);
        }
      }
    }

    _itemsStream.add(applyFilter(filter));
    _loadingNotifier.value = false;
  }

  Widget _itemWidget(T item) {
    if (widget.itemBuilder != null)
      return InkWell(
        child: widget.itemBuilder(
            context, item, _manageSelectedItemVisibility(item)),
        onTap: () {
          widget.onChange(item);
          Navigator.pop(context);
        },
      );
    else
      return ListTile(
        title: Text(widget.itemAsString != null
            ? widget.itemAsString(item)
            : item.toString()),
        selected: _manageSelectedItemVisibility(item),
        onTap: () {
          widget.onChange(item);
          Navigator.pop(context);
        },
      );
  }

  /// selected item will be highlighted only when [widget.showSelectedItem] is true,
  /// if our object is String [widget.compareFn] is not required , other wises it's required
  bool _manageSelectedItemVisibility(T item) {
    if (!widget.showSelectedItem) return false;

    if (T == String) {
      return item == widget.selectedValue;
    } else {
      return widget.compareFn(item, widget.selectedValue);
    }
  }

  Widget _searchField() {
    return Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
      if (widget.dialogTitle != null)
        Text(widget.dialogTitle, style: widget.dialogTitleStyle),
      if (widget.showSearchBox)
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              focusNode: focusNode,
              onChanged: (f) => _debouncer(() {
                _onTextChanged(f);
              }),
              decoration: widget.searchBoxDecoration ??
                  InputDecoration(
                    hintText: widget.hintText,
                    border: OutlineInputBorder(),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
            ))
    ]);
  }
}

class Debouncer {
  final Duration delay;
  Timer _timer;

  Debouncer({this.delay = const Duration(milliseconds: 500)});

  call(Function action) {
    _timer?.cancel();
    _timer = Timer(delay, action);
  }
}
