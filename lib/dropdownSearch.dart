library dropdown_search;

import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'selectDialog.dart';
import 'dart:async';

typedef Future<List<T>> DropdownSearchOnFind<T>(String text);
typedef void DropdownSearchOnChanged<T>(T selectedItem);
typedef Widget DropdownSearchBuilder<T>(
    BuildContext context, T selectedItem, String itemAsString);
typedef String DropdownSearchValidation<T>(T selectedItem);
typedef Widget DropdownSearchItemBuilder<T>(
  BuildContext context,
  T item,
  bool isSelected,
);

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

  ///background color for the dialog/menu/bottomSheet
  final InputDecoration searchBoxDecoration;

  ///the title for dialog/menu/bottomSheet
  final Color backgroundColor;

  ///text style for the dialog title
  final String dialogTitle;

  ///the height of the selected item UI
  final TextStyle dialogTitleStyle;

  ///customize the fields the be shown
  final double dropdownItemBuilderHeight;

  ///customize the fields the be shown
  final String Function(T item) itemAsString;

  ///	custom filter function
  final Function(T item, String filter) filterFn;

  ///enable/disable dropdownSearch
  final bool enabled;

  ///MENU / DIALOG/ BOTTOM_SHEET
  final Mode mode;

  ///the max height for dialog/bottomSheet/Menu
  final double maxHeight;

  ///select the selected item in the menu/dialog/bottomSheet of items
  final bool showSelectedItem;

  ///function that compares two object with the same type to detected if it's the selected item or not
  final bool Function(T item, T selectedItem) compareFn;

  DropdownSearch(
      {Key key,
      @required this.onChanged,
      this.mode = Mode.DIALOG,
      this.label,
      this.isFilteredOnline = false,
      this.dialogTitle,
      this.dialogTitleStyle =
          const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      this.labelStyle,
      this.items,
      this.selectedItem,
      this.onFind,
      this.dropdownItemBuilderHeight = 40,
      this.dropdownBuilder,
      this.dropdownItemBuilder,
      this.showSearchBox = true,
      this.showClearButton = false,
      this.validate,
      this.searchBoxDecoration,
      this.backgroundColor = Colors.white,
      this.enabled = true,
      this.maxHeight,
      this.filterFn,
      this.itemAsString,
      this.showSelectedItem = false,
      this.compareFn})
      : assert(onChanged != null),
        assert(!showSelectedItem || T == String || compareFn != null),
        super(key: key);

  @override
  _DropdownSearchState<T> createState() => _DropdownSearchState<T>();
}

class _DropdownSearchState<T> extends State<DropdownSearch<T>> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry _overlayEntry;

  final ValueNotifier<T> _selectedItemNotifier = ValueNotifier(null);
  final ValueNotifier<String> _validateMessageNotifier = ValueNotifier(null);

  @override
  Widget build(BuildContext context) {
    //init general parameters and listeners
    _selectedItemNotifier.value = widget.selectedItem;
    if (widget.validate != null) {
      _validateMessageNotifier.value = widget.validate(widget.selectedItem);
    }

    return CompositedTransformTarget(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (widget.label != null && widget.dropdownBuilder != null)
              Text(
                widget.label,
                style: widget.labelStyle ?? Theme.of(context).textTheme.subhead,
              ),
            if (widget.label != null) SizedBox(height: 5),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ValueListenableBuilder<T>(
                  valueListenable: _selectedItemNotifier,
                  builder: (context, data, wt) {
                    return IgnorePointer(
                      ignoring: !widget.enabled,
                      child: GestureDetector(
                          onTap: () {
                            _selectSearchMode(data);
                          },
                          child: (widget.dropdownBuilder != null)
                              ? Stack(children: <Widget>[
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
                if (widget.validate != null)
                  ValueListenableBuilder(
                    valueListenable: _validateMessageNotifier,
                    builder: (context, msg, w) {
                      return ConstrainedBox(
                        constraints: BoxConstraints(minHeight: 15),
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: Text(msg ?? "",
                              style: Theme.of(context).textTheme.body1.copyWith(
                                  color: Theme.of(context).errorColor)),
                        ),
                      );
                    },
                  )
              ],
            ),
          ],
        ),
        link: _layerLink);
  }

  Widget _defaultSelectItemWidget(BuildContext context, T data) {
    return TextFormField(
      readOnly: true,
      controller: TextEditingController(text: _selectedItemAsString(data)),
      decoration: InputDecoration(
          labelText: widget.label,
          labelStyle: widget.labelStyle,
          border: OutlineInputBorder(),
          suffixIcon: _manageTrailingIcons(context, data)),
    );
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
              icon: Icon(
                Icons.clear,
                size: 25,
                color: Colors.black54,
              ),
              onPressed: () => _handleOnChangeSelectedItem(null)),
        IconButton(
            icon: Icon(
              Icons.arrow_drop_down,
              size: 25,
              color: Colors.black54,
            ),
            onPressed: () => _selectSearchMode(data)),
      ],
    );
  }

  ///open dialog (Dialog mode)
  Future<void> _openSelectDialog(T data) {
    return SelectDialog.showModal<T>(context,
        dialogTitle: widget.dialogTitle,
        isMenuMode: false,
        maxHeight: widget.maxHeight,
        isFilteredOnline: widget.isFilteredOnline,
        itemAsString: widget.itemAsString,
        filterFn: widget.filterFn,
        items: widget.items,
        label: widget.label,
        onFind: widget.onFind,
        showSearchBox: widget.showSearchBox,
        itemBuilder: widget.dropdownItemBuilder,
        selectedValue: data,
        searchBoxDecoration: widget.searchBoxDecoration,
        backgroundColor: widget.backgroundColor,
        dialogTitleStyle: widget.dialogTitleStyle,
        onChange: _handleOnChangeSelectedItem,
        showSelectedItem: widget.showSelectedItem,
        compareFn: widget.compareFn);
  }

  PersistentBottomSheetController<T> _openBottomSheet(T data) {
    return SelectDialog.showAsBottomSheet<T>(context,
        isMenuMode: false,
        dialogTitle: widget.dialogTitle,
        maxHeight: widget.maxHeight,
        isFilteredOnline: widget.isFilteredOnline,
        itemAsString: widget.itemAsString,
        filterFn: widget.filterFn,
        items: widget.items,
        label: widget.label,
        onFind: widget.onFind,
        showSearchBox: widget.showSearchBox,
        itemBuilder: widget.dropdownItemBuilder,
        selectedValue: data,
        searchBoxDecoration: widget.searchBoxDecoration,
        backgroundColor: widget.backgroundColor,
        dialogTitleStyle: widget.dialogTitleStyle,
        onChange: _handleOnChangeSelectedItem,
        showSelectedItem: widget.showSelectedItem,
        compareFn: widget.compareFn);
  }

  void _handleOnChangeSelectedItem(T selectedItem) {
    _selectedItemNotifier.value = selectedItem;
    if (widget.validate != null) {
      _validateMessageNotifier.value = widget.validate(selectedItem);
    }
    widget.onChanged(selectedItem);
    if (widget.mode == Mode.MENU) {
      _closeMenu();
    }
  }

  OverlayEntry _createOverlayEntry(T data) {
    RenderBox renderBox = context.findRenderObject();
    var size = renderBox.size;

    return OverlayEntry(
        builder: (context) => Positioned(
              width: size.width,
              child: CompositedTransformFollower(
                link: _layerLink,
                showWhenUnlinked: false,
                offset: Offset(0.0, size.height),
                child: Material(
                  elevation: 4.0,
                  child: SelectDialog(
                      maxHeight: widget.maxHeight ?? 300,
                      isMenuMode: true,
                      itemAsString: widget.itemAsString,
                      itemsList: widget.items,
                      onFind: widget.onFind,
                      showSearchBox: widget.showSearchBox,
                      itemBuilder: widget.dropdownItemBuilder,
                      selectedValue: data,
                      searchBoxDecoration: widget.searchBoxDecoration,
                      backgroundColor: widget.backgroundColor,
                      dialogTitleStyle: widget.dialogTitleStyle,
                      onChange: _handleOnChangeSelectedItem,
                      showSelectedItem: widget.showSelectedItem,
                      compareFn: widget.compareFn),
                ),
              ),
            ));
  }

  ///Function that return then UI based on searchMode
  ///[data] to be passed to the UI
  void _selectSearchMode(T data) {
    if (widget.mode == Mode.MENU) {
      _toggleMenu(data: data);
    } else if (widget.mode == Mode.BOTTOM_SHEET) {
      _openBottomSheet(data);
    } else {
      _openSelectDialog(data);
    }
  }

  void _openMenu({T data}) {
    if (_overlayEntry == null) {
      _overlayEntry = _createOverlayEntry(data);
      Overlay.of(context).insert(_overlayEntry);
    }
  }

  void _closeMenu() {
    if (_overlayEntry != null) {
      _overlayEntry.remove();
      _overlayEntry = null;
    }
  }

  void _toggleMenu({T data}) {
    if (_overlayEntry == null) {
      _openMenu(data: data);
    } else {
      _closeMenu();
    }
  }
}

enum Mode { DIALOG, BOTTOM_SHEET, MENU }
