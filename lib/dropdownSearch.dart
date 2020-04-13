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

class DropdownSearch<T> extends StatelessWidget {
  final String label;
  final bool showSearchBox;
  final bool isFilteredOnline;
  final bool showClearButton;
  final TextStyle labelStyle;
  final List<T> items;
  final T selectedItem;
  final DropdownSearchOnFind<T> onFind;
  final DropdownSearchOnChanged<T> onChanged;
  final DropdownSearchBuilder<T> dropdownBuilder;
  final DropdownSearchItemBuilder<T> dropdownItemBuilder;
  final DropdownSearchValidation<T> validate;
  final InputDecoration searchBoxDecoration;
  final Color backgroundColor;
  final String dialogTitle;
  final TextStyle dialogTitleStyle;
  final double dropdownItemBuilderHeight;
  final String Function(T item) itemAsString;
  final Function(T item, String filter) filterFn;
  final bool enabled;
  final Mode mode;
  final double maxHeight;

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
      this.itemAsString})
      : assert(onChanged != null),
        super(key: key);

  //menu Mode parameters
  final LayerLink _layerLink = LayerLink();
  OverlayEntry _overlayEntry;

  //general parameters
  final ValueNotifier<T> selectedItemNotifier = ValueNotifier(null);
  final ValueNotifier<String> validateMessageNotifier = ValueNotifier(null);
  BuildContext myContext;

  @override
  Widget build(BuildContext context) {
    myContext = context;
    //init general parameters and listeners
    selectedItemNotifier.value = selectedItem;
    if (validate != null) {
      validateMessageNotifier.value = validate(selectedItem);
    }

    return CompositedTransformTarget(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (label != null && dropdownBuilder != null)
              Text(
                label,
                style: labelStyle ?? Theme.of(context).textTheme.subhead,
              ),
            if (label != null) SizedBox(height: 5),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ValueListenableBuilder<T>(
                  valueListenable: selectedItemNotifier,
                  builder: (context, data, wt) {
                    return IgnorePointer(
                      ignoring: !enabled,
                      child: GestureDetector(
                          onTap: () {
                            _selectSearchMode(data);
                          },
                          child: (dropdownBuilder != null)
                              ? Stack(children: <Widget>[
                                  dropdownBuilder(context, data,
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
                if (validate != null)
                  ValueListenableBuilder(
                    valueListenable: validateMessageNotifier,
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
        link: this._layerLink);
  }

  Widget _defaultSelectItemWidget(BuildContext context, T data) {
    return TextFormField(
      readOnly: true,
      controller: TextEditingController(text: _selectedItemAsString(data)),
      decoration: InputDecoration(
          labelText: label,
          labelStyle: labelStyle,
          border: OutlineInputBorder(),
          suffixIcon: _manageTrailingIcons(context, data)),
    );
  }

  ///function that return the String value of an object
  String _selectedItemAsString(T data) {
    if (data == null) {
      return "";
    } else if (itemAsString == null) {
      return data.toString();
    } else {
      return itemAsString(data);
    }
  }

  ///function that manage Trailing icons(close, dropDown)
  Widget _manageTrailingIcons(BuildContext context, T data) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (data != null && showClearButton)
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
    return SelectDialog.showModal<T>(
      myContext,
      dialogTitle: dialogTitle,
      isMenuMode: false,
      maxHeight: maxHeight,
      isFilteredOnline: isFilteredOnline,
      itemAsString: itemAsString,
      filterFn: filterFn,
      items: items,
      label: label,
      onFind: onFind,
      showSearchBox: showSearchBox,
      itemBuilder: dropdownItemBuilder,
      selectedValue: data,
      searchBoxDecoration: searchBoxDecoration,
      backgroundColor: backgroundColor,
      dialogTitleStyle: dialogTitleStyle,
      onChange: _handleOnChangeSelectedItem,
    );
  }

  PersistentBottomSheetController<T> _openBottomSheet(T data) {
    return SelectDialog.showAsBottomSheet<T>(
      myContext,
      isMenuMode: false,
      dialogTitle: dialogTitle,
      maxHeight: maxHeight,
      isFilteredOnline: isFilteredOnline,
      itemAsString: itemAsString,
      filterFn: filterFn,
      items: items,
      label: label,
      onFind: onFind,
      showSearchBox: showSearchBox,
      itemBuilder: dropdownItemBuilder,
      selectedValue: data,
      searchBoxDecoration: searchBoxDecoration,
      backgroundColor: backgroundColor,
      dialogTitleStyle: dialogTitleStyle,
      onChange: _handleOnChangeSelectedItem,
    );
  }

  void _handleOnChangeSelectedItem(T selectedItem) {
    selectedItemNotifier.value = selectedItem;
    if (validate != null) {
      validateMessageNotifier.value = validate(selectedItem);
    }
    onChanged(selectedItem);
    if (mode == Mode.MENU) {
      _closeMenu();
    }
  }

  OverlayEntry _createOverlayEntry(T data) {
    RenderBox renderBox = myContext.findRenderObject();
    var size = renderBox.size;

    return OverlayEntry(
        builder: (context) => Positioned(
              width: size.width,
              child: CompositedTransformFollower(
                link: this._layerLink,
                showWhenUnlinked: false,
                offset: Offset(0.0, size.height),
                child: Material(
                  elevation: 4.0,
                  child: SelectDialog(
                    maxHeight: maxHeight ?? 300,
                    isMenuMode: true,
                    itemAsString: itemAsString,
                    itemsList: items,
                    onFind: onFind,
                    showSearchBox: showSearchBox,
                    itemBuilder: dropdownItemBuilder,
                    selectedValue: data,
                    searchBoxDecoration: searchBoxDecoration,
                    backgroundColor: backgroundColor,
                    dialogTitleStyle: dialogTitleStyle,
                    onChange: _handleOnChangeSelectedItem,
                  ),
                ),
              ),
            ));
  }

  ///Function that return then UI based on searchMode
  ///@param data: data to be passed to the UI
  void _selectSearchMode(T data) {
    if (mode == Mode.MENU) {
      _openMenu(data: data);
    } else if (mode == Mode.BOTTOM_SHEET) {
      _openBottomSheet(data);
    } else {
      _openSelectDialog(data);
    }
  }

  void _openMenu({T data}) {
    if (_overlayEntry == null) {
      _overlayEntry = this._createOverlayEntry(data);
      Overlay.of(myContext).insert(this._overlayEntry);
    }
  }

  void _closeMenu() {
    if (_overlayEntry != null) {
      _overlayEntry.remove();
      _overlayEntry = null;
    }
  }
}

enum Mode { DIALOG, BOTTOM_SHEET, MENU }
