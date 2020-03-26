import 'package:flutter/material.dart';
import 'dart:async';

typedef Widget SelectOneItemBuilderType<T>(
    BuildContext context, T item, bool isSelected);

class SelectDialog<T> extends StatefulWidget {
  final T selectedValue;
  final List<T> itemsList;
  final bool showSearchBox;
  final bool isFilterOnline;
  final void Function(T) onChange;
  final Future<List<T>> Function(String text) onFind;
  final SelectOneItemBuilderType<T> itemBuilder;
  final InputDecoration searchBoxDecoration;
  final Color backgroundColor;
  final TextStyle titleStyle;
  final String Function(T item) itemAsString;
  final String hintText;

  const SelectDialog(
      {Key key,
      this.itemsList,
      this.showSearchBox,
      this.isFilterOnline,
      this.onChange,
      this.selectedValue,
      this.onFind,
      this.itemBuilder,
      this.searchBoxDecoration,
      this.backgroundColor = Colors.white,
      this.titleStyle,
      this.hintText,
      this.itemAsString})
      : super(key: key);

  static Future<T> showModal<T>(BuildContext context,
      {List<T> items,
      String label,
      bool isFilteredOnline = false,
      T selectedValue,
      bool showSearchBox,
      Future<List<T>> Function(String text) onFind,
      String Function(T item) itemAsString,
      SelectOneItemBuilderType<T> itemBuilder,
      void Function(T) onChange,
      InputDecoration searchBoxDecoration,
      Color backgroundColor,
      String hintText,
      TextStyle titleStyle}) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: backgroundColor,
          title: Text(
            label ?? "",
            style: titleStyle,
          ),
          content: SelectDialog<T>(
              itemAsString: itemAsString,
              selectedValue: selectedValue,
              isFilterOnline: isFilteredOnline,
              itemsList: items,
              onChange: onChange,
              onFind: onFind,
              showSearchBox: showSearchBox,
              itemBuilder: itemBuilder,
              searchBoxDecoration: searchBoxDecoration,
              backgroundColor: backgroundColor,
              hintText: hintText,
              titleStyle: titleStyle),
        );
      },
    );
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
      if (widget.onFind != null) _items.addAll(await widget.onFind(""));
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
      width: MediaQuery.of(context).size.width * .9,
      height: MediaQuery.of(context).size.height * .7,
      child: Column(
        children: <Widget>[
          if (widget.showSearchBox ?? true)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (f) => _debouncer(() {
                  _onTextChanged(f);
                }),
                decoration: widget.searchBoxDecoration ??
                    InputDecoration(
                      hintText: widget.hintText,
                      contentPadding: const EdgeInsets.all(2.0),
                    ),
              ),
            ),
          Expanded(
            child: Scrollbar(
              child: StreamBuilder<List<T>>(
                stream: itemsStream.stream,
                builder: (context, snapshot) {
                  if (snapshot.hasError)
                    return Center(
                        child: Text("erreur: ${snapshot?.error.toString()}"));
                  else if (!snapshot.hasData)
                    return Center(child: CircularProgressIndicator());
                  else if (snapshot.data.isEmpty)
                    return Center(child: Text("No data found"));
                  return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      var item = snapshot.data[index];
                      if (widget.itemBuilder != null)
                        return InkWell(
                          child: widget.itemBuilder(
                              context, item, item == widget.selectedValue),
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
                          selected: item == widget.selectedValue,
                          onTap: () {
                            widget.onChange(item);
                            Navigator.pop(context);
                          },
                        );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onTextChanged(String filter) async {
    if (widget.onFind != null && widget.isFilterOnline) {
      List<T> onlineItems = await widget.onFind(filter);
      if (onlineItems != null && onlineItems.isNotEmpty) {
        //remove already existant occurance on the list
        _items.removeWhere((i) => onlineItems.contains(i));

        //add new online items to list
        _items.addAll(onlineItems);
      }
    }

    itemsStream.add(_items.where((i) {
      if (widget.itemAsString != null) {
        return (widget.itemAsString(i))
                ?.toLowerCase()
                ?.contains(filter.toLowerCase()) ??
            List();
      }
      return i.toString().toLowerCase().contains(filter.toLowerCase());
    }).toList());
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
