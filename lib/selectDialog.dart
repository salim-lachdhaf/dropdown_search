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
  final Color backgroundColor;
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

  const SelectDialog(
      {Key key,
      this.dialogTitle,
      this.items,
      this.maxHeight,
      this.showSearchBox,
      this.isFilteredOnline,
      this.onChange,
      this.selectedValue,
      this.onFind,
      this.itemBuilder,
      this.searchBoxDecoration,
      this.backgroundColor,
      this.dialogTitleStyle,
      this.hintText,
      this.itemAsString,
      this.filterFn,
      this.showSelectedItem,
      this.compareFn,
      this.emptyBuilder,
      this.loadingBuilder,
      this.errorBuilder})
      : super(key: key);

  @override
  _SelectDialogState<T> createState() => _SelectDialogState<T>();
}

class _SelectDialogState<T> extends State<SelectDialog<T>> {
  StreamController<List<T>> itemsStream = StreamController();

  final List<T> _items = List();
  final _debouncer = Debouncer();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      if (widget.onFind != null) {
        var founded = await widget.onFind("").catchError(itemsStream.addError);
        _items.addAll(founded ?? List());
      }
      if (widget.items != null) _items.addAll(widget.items);

      if (_items.isNotEmpty) itemsStream.add(_items);
    });
  }

  @override
  void dispose() {
    itemsStream.close();
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
            child: StreamBuilder<List<T>>(
              stream: itemsStream.stream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  if (widget.errorBuilder != null)
                    return widget.errorBuilder(context, snapshot.error);
                  else
                    return Center(child: Text(snapshot?.error?.toString()));
                } else if (!snapshot.hasData) {
                  if (widget.loadingBuilder != null)
                    return widget.loadingBuilder(context);
                  else
                    return Center(child: CircularProgressIndicator());
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
          ),
        ],
      ),
    );
  }

  void _onTextChanged(String filter) async {
    if (widget.onFind != null && widget.isFilteredOnline) {
      List<T> onlineItems = await widget
          .onFind(filter)
          .catchError((e) => itemsStream.addError(e));
      if (onlineItems != null) {
        //Remove all old data
        _items.clear();
        //add offline items
        if (widget.items != null) _items.addAll(widget.items);
        //add new online items to list
        _items.addAll(onlineItems);
      }
    }

    itemsStream.add(_items.where((i) {
      if (widget.filterFn != null)
        return (widget.filterFn(i, filter));
      else if (widget.itemAsString != null) {
        return (widget.itemAsString(i))
                ?.toLowerCase()
                ?.contains(filter.toLowerCase()) ??
            List();
      }
      return i.toString().toLowerCase().contains(filter.toLowerCase());
    }).toList());
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
