library dropdown_search;

import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'dropdownSearchBbloc.dart';
import 'selectDialog.dart';

typedef Future<List<T>> DropdownSearchFindType<T>(String text);
typedef void DropdownSearchChangedType<T>(T selectedItem);
typedef Widget DropdownSearchBuilderType<T>(
    BuildContext context, T selectedItem, String itemAsString);
typedef String DropdownSearchValidationType<T>(T selectedItem);
typedef Widget DropdownSearchItemBuilderType<T>(
  BuildContext context,
  T item,
  bool isSelected,
);

class DropdownSearch<T> extends StatefulWidget {
  final String label;
  final bool showSearchBox;
  final bool showClearButton;
  final TextStyle labelStyle;
  final List<T> items;
  final T selectedItem;
  final DropdownSearchFindType<T> onFind;
  final DropdownSearchChangedType<T> onChanged;
  final DropdownSearchBuilderType<T> dropdownBuilder;
  final DropdownSearchItemBuilderType<T> dropdownItemBuilder;
  final DropdownSearchValidationType<T> validate;
  final InputDecoration searchBoxDecoration;
  final Color backgroundColor;
  final String dialogTitle;
  final TextStyle dialogTitleStyle;
  final double dropdownBuilderHeight;
  final String Function(T item) itemAsString;

  const DropdownSearch(
      {Key key,
      @required this.onChanged,
      this.label,
      this.dialogTitle,
      this.labelStyle,
      this.items,
      this.selectedItem,
      this.onFind,
      this.dropdownBuilderHeight = 40,
      this.dropdownBuilder,
      this.dropdownItemBuilder,
      this.showSearchBox = true,
      this.showClearButton = false,
      this.validate,
      this.searchBoxDecoration,
      this.backgroundColor,
      this.dialogTitleStyle,
      this.itemAsString})
      : assert(onChanged != null),
        super(key: key);

  @override
  _DropdownSearchState<T> createState() => _DropdownSearchState<T>();
}

class _DropdownSearchState<T> extends State<DropdownSearch<T>> {
  DropdownSearchBloc<T> bloc;

  @override
  void initState() {
    super.initState();
    bloc = DropdownSearchBloc<T>(
      seedValue: widget.selectedItem,
      validate: widget.validate,
    );
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (widget.label != null)
          Text(
            widget.label,
            style: widget.labelStyle ?? Theme.of(context).textTheme.subhead,
          ),
        if (widget.label != null) SizedBox(height: 5),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            StreamBuilder<T>(
              stream: bloc.selected$,
              builder: (context, snapshot) {
                return GestureDetector(
                  onTap: () {
                    SelectDialog.showModal(
                      context,
                      itemAsString: widget.itemAsString,
                      items: widget.items,
                      label: widget.dialogTitle == null
                          ? widget.label
                          : widget.dialogTitle,
                      onFind: widget.onFind,
                      showSearchBox: widget.showSearchBox,
                      itemBuilder: widget.dropdownItemBuilder,
                      selectedValue: snapshot.data,
                      searchBoxDecoration: widget.searchBoxDecoration,
                      backgroundColor: widget.backgroundColor,
                      titleStyle: widget.dialogTitleStyle,
                      onChange: (item) {
                        bloc.selected$.add(item);
                        widget.onChanged(item);
                      },
                    );
                  },
                  child: (widget.dropdownBuilder != null)
                      ? Stack(children: <Widget>[
                          widget.dropdownBuilder(context, snapshot.data,
                              _manageSelectedItemDesignation(snapshot)),
                          Positioned.fill(
                              right: 5,
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: _manageTrailingIcon(snapshot),
                              ))
                        ])
                      : Container(
                          padding: EdgeInsets.fromLTRB(15, 5, 5, 5),
                          height: widget.dropdownBuilderHeight,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              width: 1,
                              color: Theme.of(context).dividerColor,
                            ),
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(_manageSelectedItemDesignation(snapshot)),
                              Align(
                                  alignment: Alignment.centerRight,
                                  child: _manageTrailingIcon(snapshot)),
                            ],
                          ),
                        ),
                );
              },
            ),
            if (widget.validate != null)
              StreamBuilder<String>(
                stream: bloc.validateMessageOut,
                builder: (context, snapshot) {
                  return ConstrainedBox(
                    constraints: BoxConstraints(minHeight: 15),
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        snapshot.data ?? "",
                        style: Theme.of(context).textTheme.body1.copyWith(
                            color: snapshot.hasData
                                ? Theme.of(context).errorColor
                                : Colors.transparent),
                      ),
                    ),
                  );
                },
              )
          ],
        ),
      ],
    );
  }

  String _manageSelectedItemDesignation(snapshot) {
    if (snapshot.data == null) {
      return "";
    } else if (widget.itemAsString == null) {
      return snapshot.data.toString();
    } else {
      return widget.itemAsString(snapshot.data);
    }
  }

  Widget _manageTrailingIcon(snapshot) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (snapshot.data != null && widget.showClearButton)
          GestureDetector(
            onTap: () {
              bloc.selected$.add(null);
              widget.onChanged(null);
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 0),
              child: Icon(
                Icons.clear,
                size: 25,
                color: Colors.black54,
              ),
            ),
          ),
        if (snapshot.data == null || !widget.showClearButton)
          Icon(
            Icons.arrow_drop_down,
            size: 25,
            color: Colors.black54,
          ),
      ],
    );
  }
}
