library dropdown_search;

import 'package:dropdown_search/popupMenu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'selectDialog.dart';
import 'dart:async';

typedef Future<List<T>> DropdownSearchOnFind<T>(String text);
typedef String DropdownSearchItemAsString<T>(T item);
typedef bool DropdownSearchFilterFn<T>(T item, String filter);
typedef bool DropdownSearchCompareFn<T>(T item, T selectedItem);
typedef void DropdownSearchOnChanged<T>(T selectedItem);
typedef Widget DropdownSearchBuilder<T>(
    BuildContext context, T selectedItem, String itemAsString);
typedef String DropdownSearchValidation<T>(T selectedItem);
typedef Widget DropdownSearchItemBuilder<T>(
  BuildContext context,
  T item,
  bool isSelected,
);
typedef Widget ErrorBuilder<T>(BuildContext context, dynamic exception);

class DropdownSearch<T> extends StatefulWidget {
  ///DropDownSearch label
  final String label;

  ///show/hide the search box
  final bool showSearchBox;

  ///true if the filter on items is applied onlie (via API)
  final bool isFilteredOnline;

  ///show/hide clear selected item
  final bool showClearButton;

  ///text style for the DropdownSearch label
  final TextStyle labelStyle;

  ///offline items list
  final List<T> items;

  ///selected item
  final T selectedItem;

  ///function that returns item from API
  final DropdownSearchOnFind<T> onFind;

  ///called when a new item is selected
  final DropdownSearchOnChanged<T> onChanged;

  ///to customize list of items UI
  final DropdownSearchBuilder<T> dropdownBuilder;

  ///to customize selected item
  final DropdownSearchItemBuilder<T> dropdownItemBuilder;

  ///function to apply the validation formula
  final DropdownSearchValidation<T> validate;

  ///decoration for search box
  final InputDecoration searchBoxDecoration;

  ///the title for dialog/menu/bottomSheet
  final Color backgroundColor;

  ///custom widget for the popup
  final Widget popupTitle;

  ///customize the fields the be shown
  final DropdownSearchItemAsString<T> itemAsString;

  ///	custom filter function
  final DropdownSearchFilterFn<T> filterFn;

  ///enable/disable dropdownSearch
  final bool enabled;

  ///MENU / DIALOG/ BOTTOM_SHEET
  final Mode mode;

  ///the max height for dialog/bottomSheet/Menu
  final double maxHeight;

  ///the max width for dialog/bottomSheet/Menu
  final double dialogMaxWidth;

  ///select the selected item in the menu/dialog/bottomSheet of items
  final bool showSelectedItem;

  ///function that compares two object with the same type to detected if it's the selected item or not
  final DropdownSearchCompareFn<T> compareFn;

  ///input decoration
  final InputDecoration dropdownSearchDecoration;

  ///custom layout for empty results
  final WidgetBuilder emptyBuilder;

  ///custom layout for loading items
  final WidgetBuilder loadingBuilder;

  ///custom layout for error
  final ErrorBuilder errorBuilder;

  ///the search box will be focused if true
  final bool autoFocusSearchBox;

  ///custom shape
  final ShapeBorder shape;

  DropdownSearch(
      {Key key,
      @required this.onChanged,
      this.mode = Mode.DIALOG,
      this.label,
      this.isFilteredOnline = false,
      this.popupTitle,
      this.labelStyle,
      this.items,
      this.selectedItem,
      this.onFind,
      this.dropdownBuilder,
      this.dropdownItemBuilder,
      this.showSearchBox = false,
      this.showClearButton = false,
      this.validate,
      this.searchBoxDecoration,
      this.backgroundColor = Colors.white,
      this.enabled = true,
      this.maxHeight,
      this.filterFn,
      this.itemAsString,
      this.showSelectedItem = false,
      this.compareFn,
      this.dropdownSearchDecoration,
      this.emptyBuilder,
      this.loadingBuilder,
      this.errorBuilder,
      this.autoFocusSearchBox = false,
      this.dialogMaxWidth,
      this.shape})
      : assert(onChanged != null),
        assert(!showSelectedItem || T == String || compareFn != null),
        super(key: key);

  @override
  _DropdownSearchState<T> createState() => _DropdownSearchState<T>();
}

class _DropdownSearchState<T> extends State<DropdownSearch<T>> {
  final ValueNotifier<T> _selectedItemNotifier = ValueNotifier(null);
  final ValueNotifier<String> _validateMessageNotifier = ValueNotifier(null);

  @override
  Widget build(BuildContext context) {
    //init general parameters and listeners
    _selectedItemNotifier.value = widget.selectedItem;
    if (widget.validate != null) {
      _validateMessageNotifier.value = widget.validate(widget.selectedItem);
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        if (widget.label != null && widget.dropdownBuilder != null)
          Text(
            widget.label,
            style: widget.labelStyle ?? Theme.of(context).textTheme.subhead,
          ),
        if (widget.label != null && widget.dropdownBuilder != null)
          SizedBox(height: 5),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            ValueListenableBuilder<T>(
              valueListenable: _selectedItemNotifier,
              builder: (context, T data, wt) {
                return IgnorePointer(
                  ignoring: !widget.enabled,
                  child: GestureDetector(
                      onTap: () {
                        _selectSearchMode(data);
                      },
                      child: (widget.dropdownBuilder != null)
                          ? Stack(
                              alignment: Alignment.center,
                              children: <Widget>[
                                  widget.dropdownBuilder(context, data,
                                      _selectedItemAsString(data)),
                                  Positioned.fill(
                                      right: 5,
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child:
                                            _manageTrailingIcons(context, data),
                                      ))
                                ])
                          : _defaultSelectItemWidget(context, data)),
                );
              },
            ),
            _errorValidationWidget()
          ],
        ),
      ],
    );
  }

  Widget _errorValidationWidget() {
    if (widget.validate != null) {
      return ValueListenableBuilder(
        valueListenable: _validateMessageNotifier,
        builder: (context, String msg, w) {
          if (msg != null && msg.isNotEmpty) {
            return Padding(
              padding: const EdgeInsets.all(5),
              child: Text(msg,
                  style: Theme.of(context)
                      .textTheme
                      .body1
                      .copyWith(color: Theme.of(context).errorColor)),
            );
          } else {
            return SizedBox.shrink();
          }
        },
      );
    }
    return SizedBox.shrink();
  }

  Widget _defaultSelectItemWidget(BuildContext context, T data) {
    return TextFormField(
        readOnly: true,
        enabled: widget.enabled,
        controller: TextEditingController(text: _selectedItemAsString(data)),
        decoration: widget.dropdownSearchDecoration ??
            InputDecoration(
                labelText: widget.label,
                labelStyle: widget.labelStyle,
                border: const OutlineInputBorder(),
                suffixIcon: _manageTrailingIcons(context, data)));
  }

  ///function that return the String value of an object
  String _selectedItemAsString(T data) {
    if (data == null) {
      return "";
    } else if (widget.itemAsString == null) {
      return data.toString();
    } else {
      return widget.itemAsString(data);
    }
  }

  ///function that manage Trailing icons(close, dropDown)
  Widget _manageTrailingIcons(BuildContext context, T data) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (data != null && widget.showClearButton)
          IconButton(
              icon: const Icon(
                Icons.clear,
                size: 25,
                color: Colors.black54,
              ),
              onPressed: () => _handleOnChangeSelectedItem(null)),
        IconButton(
            icon: const Icon(
              Icons.arrow_drop_down,
              size: 25,
              color: Colors.black54,
            ),
            onPressed: () => _selectSearchMode(data)),
      ],
    );
  }

  ///open dialog
  Future<void> _openSelectDialog(T data) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(0),
          shape: widget.shape,
          backgroundColor: widget.backgroundColor,
          content: _selectDialogInstance(data),
        );
      },
    );
  }

  ///open BottomSheet (Dialog mode)
  Future<T> _openBottomSheet(T data) {
    return showModalBottomSheet<T>(
        isScrollControlled: true,
        backgroundColor: widget.backgroundColor,
        shape: widget.shape,
        context: context,
        builder: (context) {
          return SingleChildScrollView(
              child: Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: _selectDialogInstance(data, defaultHeight: 350),
          ));
        });
  }

  ///openMenu
  Future<T> _openMenu(T data) {
    // Here we get the render object of our physical button, later to get its size & position
    final RenderBox popupButtonObject = context.findRenderObject();
    // Get the render object of the overlay used in `Navigator` / `MaterialApp`, i.e. screen size reference
    final RenderBox overlay = Overlay.of(context).context.findRenderObject();
    // Calculate the show-up area for the dropdown using button's size & position based on the `overlay` used as the coordinate space.
    final RelativeRect position = RelativeRect.fromSize(
        Rect.fromPoints(
          popupButtonObject.localToGlobal(
              popupButtonObject.size.bottomLeft(Offset.zero),
              ancestor: overlay),
          popupButtonObject.localToGlobal(
              popupButtonObject.size.bottomRight(Offset.zero),
              ancestor: overlay),
        ),
        Size(overlay.size.width, overlay.size.height));
    return customShowMenu<T>(
        shape: widget.shape,
        color: widget.backgroundColor,
        context: context,
        position: position,
        elevation: 8,
        items: [
          CustomPopupMenuItem(
              enabled: false,
              child: Container(
                  width: popupButtonObject.size.width,
                  child: _selectDialogInstance(data, defaultHeight: 224)))
        ]);
  }

  SelectDialog<T> _selectDialogInstance(T data, {double defaultHeight}) {
    return SelectDialog<T>(
        popupTitle: widget.popupTitle,
        maxHeight: widget.maxHeight ?? defaultHeight,
        isFilteredOnline: widget.isFilteredOnline,
        itemAsString: widget.itemAsString,
        filterFn: widget.filterFn,
        items: widget.items,
        onFind: widget.onFind,
        showSearchBox: widget.showSearchBox,
        itemBuilder: widget.dropdownItemBuilder,
        selectedValue: data,
        searchBoxDecoration: widget.searchBoxDecoration,
        onChange: _handleOnChangeSelectedItem,
        showSelectedItem: widget.showSelectedItem,
        compareFn: widget.compareFn,
        emptyBuilder: widget.emptyBuilder,
        loadingBuilder: widget.loadingBuilder,
        errorBuilder: widget.errorBuilder,
        autoFocusSearchBox: widget.autoFocusSearchBox,
        dialogMaxWidth: widget.dialogMaxWidth);
  }

  ///handle on change value , if the validation is active , we validate the new selected item
  void _handleOnChangeSelectedItem(T selectedItem) {
    _selectedItemNotifier.value = selectedItem;
    if (widget.validate != null) {
      _validateMessageNotifier.value = widget.validate(selectedItem);
    }
    widget.onChanged(selectedItem);
  }

  ///Function that return then UI based on searchMode
  ///[data] selected item to be passed to the UI
  void _selectSearchMode(T data) {
    if (widget.mode == Mode.MENU) {
      _openMenu(data);
    } else if (widget.mode == Mode.BOTTOM_SHEET) {
      _openBottomSheet(data);
    } else {
      _openSelectDialog(data);
    }
  }
}

enum Mode { DIALOG, BOTTOM_SHEET, MENU }
