library dropdown_search;

import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'selectDialog.dart';
import 'dart:async';

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

class DropdownSearch<T> extends StatelessWidget {
  final String label;
  final bool showSearchBox;
  final bool isFilteredOnline;
  final bool showClearButton;
  final TextStyle labelStyle;
  final List<T> items;
  T selectedItem;
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

  DropdownSearch(
      {Key key,
      @required this.onChanged,
      this.label,
      this.isFilteredOnline = false,
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

  ValueNotifier<T> selectedItemNotifier = ValueNotifier(null);
  ValueNotifier<String> validateMessageNotifier = ValueNotifier(null);

  @override
  Widget build(BuildContext context) {
    selectedItemNotifier.value = selectedItem;
    if (validate != null) {
      validateMessageNotifier.value = validate(selectedItem);
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (label != null)
          Text(
            label,
            style: labelStyle ?? Theme.of(context).textTheme.subhead,
          ),
        if (label != null) SizedBox(height: 5),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ValueListenableBuilder(
              valueListenable: selectedItemNotifier,
              builder: (context, data, wt) {
                return GestureDetector(
                  onTap: () {
                    SelectDialog.showModal<T>(
                      context,
                      isFilteredOnline: isFilteredOnline,
                      itemAsString: itemAsString,
                      items: items,
                      label: dialogTitle == null ? label : dialogTitle,
                      onFind: onFind,
                      showSearchBox: showSearchBox,
                      itemBuilder: dropdownItemBuilder,
                      selectedValue: data,
                      searchBoxDecoration: searchBoxDecoration,
                      backgroundColor: backgroundColor,
                      titleStyle: dialogTitleStyle,
                      onChange: (item) {
                        selectedItem  = item; //fix widget rebuild issue
                        selectedItemNotifier.value = item;
                        if (validate != null) {
                          validateMessageNotifier.value = validate(item);
                        }
                        onChanged(item);
                      },
                    );
                  },
                  child: (dropdownBuilder != null)
                      ? Stack(children: <Widget>[
                          dropdownBuilder(context, data,
                              _manageSelectedItemDesignation(data)),
                          Positioned.fill(
                              right: 5,
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: _manageTrailingIcon(data),
                              ))
                        ])
                      : Container(
                          padding: EdgeInsets.fromLTRB(15, 5, 5, 5),
                          height: dropdownBuilderHeight,
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
                              Text(_manageSelectedItemDesignation(data)),
                              Align(
                                  alignment: Alignment.centerRight,
                                  child: _manageTrailingIcon(data)),
                            ],
                          ),
                        ),
                );
              },
            ),
            if (validate != null)
              ValueListenableBuilder(
                valueListenable: validateMessageNotifier,
                builder: (context, msg, w) {
                  return ConstrainedBox(
                    constraints: BoxConstraints(minHeight: 15),
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        msg ?? "",
                        style: Theme.of(context).textTheme.body1.copyWith(
                            color: msg != null
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

  String _manageSelectedItemDesignation(data) {
    if (data == null) {
      return "";
    } else if (itemAsString == null) {
      return data.toString();
    } else {
      return itemAsString(data);
    }
  }

  Widget _manageTrailingIcon(data) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (data != null && showClearButton)
          GestureDetector(
            onTap: () {
              selectedItemNotifier.value = null;
              onChanged(null);
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
        if (data == null || !showClearButton)
          Icon(
            Icons.arrow_drop_down,
            size: 25,
            color: Colors.black54,
          ),
      ],
    );
  }
}
