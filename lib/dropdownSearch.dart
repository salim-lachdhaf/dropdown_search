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

  @override
  _DropdownSearchState<T> createState() => _DropdownSearchState<T>();
}

class _DropdownSearchState<T> extends State<DropdownSearch<T>> {
  //menu Mode parameters
  final LayerLink _layerLink = LayerLink();
  OverlayEntry _overlayEntry;

  //general parameters
  ValueNotifier<T> selectedItemNotifier = ValueNotifier(null);
  ValueNotifier<String> validateMessageNotifier = ValueNotifier(null);

  @override
  void initState() {
    super.initState();
    //init general parameters and listeners
    selectedItemNotifier.value = widget.selectedItem;
    if (widget.validate != null) {
      validateMessageNotifier.value = widget.validate(widget.selectedItem);
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  valueListenable: selectedItemNotifier,
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
                                            _manageTrailingIcon(context, data),
                                      ))
                                ])
                              : _defaultSelectItemWidget(context, data)),
                    );
                  },
                ),
                if (widget.validate != null)
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
          labelText: widget.label,
          labelStyle: widget.labelStyle,
          border: OutlineInputBorder(),
          suffixIcon: _manageTrailingIcon(context, data)),
    );
  }

  String _selectedItemAsString(T data) {
    if (data == null) {
      return "";
    } else if (widget.itemAsString == null) {
      return data.toString();
    } else {
      return widget.itemAsString(data);
    }
  }

  Widget _manageTrailingIcon(BuildContext context, T data) {
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

  Future<void> _openSelectDialog(T data) {
    return SelectDialog.showModal<T>(
      context,
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
    );
  }

  PersistentBottomSheetController<T> _openBottomSheet(T data) {
    return SelectDialog.showAsBottomSheet<T>(
      context,
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
    );
  }

  void _handleOnChangeSelectedItem(T selectedItem) {
    selectedItemNotifier.value = selectedItem;
    if (widget.validate != null) {
      validateMessageNotifier.value = widget.validate(selectedItem);
    }
    widget.onChanged(selectedItem);
    if (widget.mode == Mode.MENU) {
      _toggleMenu();
    }
  }

  OverlayEntry _createOverlayEntry(T data) {
    RenderBox renderBox = context.findRenderObject();
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
                  ),
                ),
              ),
            ));
  }

  void _selectSearchMode(T data) {
    if (widget.mode == Mode.MENU) {
      _toggleMenu(data: data);
    } else if (widget.mode == Mode.BOTTOM_SHEET) {
      _openBottomSheet(data);
    } else {
      _openSelectDialog(data);
    }
  }

  void _toggleMenu({T data}) {
    if (_overlayEntry == null) {
      _overlayEntry = this._createOverlayEntry(data);
      Overlay.of(context).insert(this._overlayEntry);
    } else {
      this._overlayEntry.remove();
      _overlayEntry = null;
    }
  }
}

enum Mode { DIALOG, BOTTOM_SHEET, MENU }
