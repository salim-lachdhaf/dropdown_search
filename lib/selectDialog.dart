import 'dart:async';

import 'package:flutter/material.dart';

typedef Widget SelectOneItemBuilderType<T>(
    BuildContext context, T item, bool isSelected);

class SelectDialog<T> extends StatefulWidget {
  final T selectedValue;
  final List<T> itemsList;
  final bool showSearchBox;
  final bool isFilteredOnline;
  final void Function(T) onChange;
  final Future<List<T>> Function(String text) onFind;
  final SelectOneItemBuilderType<T> itemBuilder;
  final InputDecoration searchBoxDecoration;
  final Color backgroundColor;
  final TextStyle dialogTitleStyle;
  final String Function(T item) itemAsString;
  final bool Function(T item, String filter) filterFn;
  final String hintText;
  final bool isMenuMode;
  final double maxHeight;
  final String dialogTitle;
  final bool showSelectedItem;
  final bool Function(T item, T selectedItem) compareFn;

  const SelectDialog(
      {Key key,
      this.dialogTitle,
      this.itemsList,
      this.maxHeight,
      this.isMenuMode,
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
      this.compareFn})
      : super(key: key);

  static Future<T> showModal<T>(BuildContext context,
      {List<T> items,
      String label,
      String dialogTitle,
      isMenuMode,
      double maxHeight,
      bool isFilteredOnline,
      T selectedValue,
      bool showSearchBox,
      Future<List<T>> Function(String text) onFind,
      String Function(T item) itemAsString,
      bool Function(T item, String filter) filterFn,
      SelectOneItemBuilderType<T> itemBuilder,
      void Function(T) onChange,
      InputDecoration searchBoxDecoration,
      Color backgroundColor,
      String hintText,
      TextStyle dialogTitleStyle,
      showSelectedItem,
      bool Function(T item, T selectedItem) compareFn}) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: backgroundColor,
          content: SelectDialog<T>(
              isMenuMode: isMenuMode,
              dialogTitle: dialogTitle,
              maxHeight: maxHeight,
              isFilteredOnline: isFilteredOnline,
              itemAsString: itemAsString,
              filterFn: filterFn,
              selectedValue: selectedValue,
              itemsList: items,
              onChange: onChange,
              onFind: onFind,
              showSearchBox: showSearchBox,
              itemBuilder: itemBuilder,
              searchBoxDecoration: searchBoxDecoration,
              backgroundColor: backgroundColor,
              hintText: hintText,
              dialogTitleStyle: dialogTitleStyle,
              showSelectedItem: showSelectedItem,
              compareFn: compareFn),
        );
      },
    );
  }

  static PersistentBottomSheetController<T> showAsBottomSheet<T>(
      BuildContext context,
      {List<T> items,
      String label,
      isMenuMode,
      bool isFilteredOnline,
      T selectedValue,
      bool showSearchBox,
      String dialogTitle,
      Future<List<T>> Function(String text) onFind,
      String Function(T item) itemAsString,
      bool Function(T item, String filter) filterFn,
      SelectOneItemBuilderType<T> itemBuilder,
      void Function(T) onChange,
      InputDecoration searchBoxDecoration,
      Color backgroundColor,
      String hintText,
      double maxHeight,
      TextStyle dialogTitleStyle,
      showSelectedItem,
      bool Function(T item, T selectedItem) compareFn}) {
    return showBottomSheet<T>(
        context: context,
        builder: (context) {
          return Container(
              height: maxHeight ?? 350,
              width: double.infinity,
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8), topRight: Radius.circular(8)),
                border: Border.all(color: Colors.blue, width: 2),
              ),
              child: SelectDialog<T>(
                  dialogTitle: dialogTitle,
                  isMenuMode: isMenuMode,
                  itemAsString: itemAsString,
                  filterFn: filterFn,
                  isFilteredOnline: isFilteredOnline,
                  selectedValue: selectedValue,
                  itemsList: items,
                  onChange: onChange,
                  maxHeight: maxHeight,
                  onFind: onFind,
                  showSearchBox: showSearchBox,
                  itemBuilder: itemBuilder,
                  searchBoxDecoration: searchBoxDecoration,
                  backgroundColor: backgroundColor,
                  hintText: hintText,
                  dialogTitleStyle: dialogTitleStyle,
                  showSelectedItem: showSelectedItem,
                  compareFn: compareFn));
        });
  }

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
      if (widget.onFind != null)
        _items.addAll(
            await widget.onFind("").catchError((e) => itemsStream.addError(e)));
      if (widget.itemsList != null) _items.addAll(widget.itemsList);

      itemsStream.add(_items);
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
                if (snapshot.hasError)
                  return Center(child: Text(snapshot?.error?.toString()));
                else if (!snapshot.hasData)
                  return Center(child: CircularProgressIndicator());
                else if (snapshot.data.isEmpty)
                  return Center(child: Text("No data found"));
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
      if (onlineItems != null && onlineItems.isNotEmpty) {
        //Remove all old data
        _items.clear();
        //add offline items
        if (widget.itemsList != null) _items.addAll(widget.itemsList);
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
          if (!widget.isMenuMode) Navigator.pop(context);
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
          if (!widget.isMenuMode) Navigator.pop(context);
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
