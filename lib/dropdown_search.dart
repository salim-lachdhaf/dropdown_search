library dropdown_search;

import 'dart:async';

import 'package:dropdown_search/src/popup_safearea.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'src/popupMenu.dart';
import 'src/selectDialog.dart';

export 'src/popup_safearea.dart';

typedef Future<List<T>> DropdownSearchOnFind<T>(String text);
typedef String DropdownSearchItemAsString<T>(T item);
typedef bool DropdownSearchFilterFn<T>(T item, String filter);
typedef bool DropdownSearchCompareFn<T>(T item, T? selectedItem);
typedef Widget DropdownSearchBuilder<T>(
    BuildContext context, T? selectedItem, String itemAsString);
typedef Widget DropdownSearchPopupItemBuilder<T>(
  BuildContext context,
  T item,
  bool isSelected,
);
typedef bool DropdownSearchPopupItemEnabled<T>(T item);
typedef Widget ErrorBuilder<T>(
    BuildContext context, String? searchEntry, dynamic exception);
typedef Widget EmptyBuilder<T>(BuildContext context, String? searchEntry);
typedef Widget LoadingBuilder<T>(BuildContext context, String? searchEntry);
typedef Widget IconButtonBuilder(BuildContext context);
typedef Future<bool?> BeforeChange<T>(T prevItem, T nextItem);

typedef Widget FavoriteItemsBuilder<T>(BuildContext context, T item);

///[items] are the original item from [items] or/and [onFind]
typedef List<T> FavoriteItems<T>(List<T> items);

enum Mode { DIALOG, BOTTOM_SHEET, MENU }

class DropdownSearch<T> extends StatefulWidget {
  ///DropDownSearch label
  final String? label;

  ///DropDownSearch hint
  final String? hint;

  ///show/hide the search box
  final bool showSearchBox;

  ///true if the filter on items is applied onlie (via API)
  final bool isFilteredOnline;

  ///show/hide clear selected item
  final bool showClearButton;

  ///offline items list
  final List<T>? items;

  ///selected item
  final T? selectedItem;

  ///function that returns item from API
  final DropdownSearchOnFind<T>? onFind;

  ///called when a new item is selected
  final ValueChanged<T?>? onChanged;

  ///to customize list of items UI
  final DropdownSearchBuilder<T>? dropdownBuilder;

  ///to customize selected item
  final DropdownSearchPopupItemBuilder<T>? popupItemBuilder;

  ///decoration for search box
  final InputDecoration? searchBoxDecoration;

  ///the title for dialog/menu/bottomSheet
  final Color? popupBackgroundColor;

  ///custom widget for the popup title
  final Widget? popupTitle;

  ///customize the fields the be shown
  final DropdownSearchItemAsString<T>? itemAsString;

  ///	custom filter function
  final DropdownSearchFilterFn<T>? filterFn;

  ///enable/disable dropdownSearch
  final bool enabled;

  ///MENU / DIALOG/ BOTTOM_SHEET
  final Mode mode;

  ///the max height for dialog/bottomSheet/Menu
  final double? maxHeight;

  ///the max width for the dialog
  final double? dialogMaxWidth;

  ///select the selected item in the menu/dialog/bottomSheet of items
  final bool showSelectedItem;

  ///function that compares two object with the same type to detected if it's the selected item or not
  final DropdownSearchCompareFn<T>? compareFn;

  ///dropdownSearch input decoration
  final InputDecoration? dropdownSearchDecoration;

  ///custom layout for empty results
  final EmptyBuilder? emptyBuilder;

  ///custom layout for loading items
  final LoadingBuilder? loadingBuilder;

  ///custom layout for error
  final ErrorBuilder? errorBuilder;

  ///the search box will be focused if true
  final bool autoFocusSearchBox;

  ///custom shape for the popup
  final ShapeBorder? popupShape;

  final AutovalidateMode autoValidateMode;

  /// An optional method to call with the final value when the form is saved via
  final FormFieldSetter<T>? onSaved;

  /// An optional method that validates an input. Returns an error string to
  /// display if the input is invalid, or null otherwise.
  final FormFieldValidator<T>? validator;

  ///custom dropdown clear button icon widget
  final Widget? clearButton;

  ///custom clear button widget builder
  final IconButtonBuilder? clearButtonBuilder;

  ///custom dropdown icon button widget
  final Widget? dropDownButton;

  //custom style of the searchBox
  final TextStyle? searchBoxStyle;

  ///custom dropdown button widget builder
  final IconButtonBuilder? dropdownButtonBuilder;

  ///whether to manage the clear and dropdown icons via InputDecoration suffixIcon
  final bool showAsSuffixIcons;

  ///If true, the dropdownBuilder will continue the uses of material behavior
  ///This will be useful if you want to handle a custom UI only if the item !=null
  final bool dropdownBuilderSupportsNullItem;

  ///defines if an item of the popup is enabled or not, if the item is disabled,
  ///it cannot be clicked
  final DropdownSearchPopupItemEnabled<T>? popupItemDisabled;

  ///set a custom color for the popup barrier
  final Color? popupBarrierColor;

  ///text controller to set default search word for example
  final TextEditingController? searchBoxController;

  ///called when popup is dismissed
  final VoidCallback? onPopupDismissed;

  /// callback executed before applying value change
  ///delay before searching, change it to Duration(milliseconds: 0)
  ///if you do not use online search
  final Duration? searchDelay;

  /// callback executed before applying value change
  final BeforeChange<T?>? onBeforeChange;

  ///show or hide favorites items
  final bool showFavoriteItems;

  ///to customize favorites chips
  final FavoriteItemsBuilder<T>? favoriteItemBuilder;

  ///favorites items list
  final FavoriteItems<T>? favoriteItems;

  ///favorite items alignment
  final MainAxisAlignment? favoriteItemsAlignment;

  ///set properties of popup safe area
  final PopupSafeArea popupSafeArea;

  DropdownSearch({
    Key? key,
    this.onSaved,
    this.validator,
    this.autoValidateMode = AutovalidateMode.disabled,
    this.onChanged,
    this.mode = Mode.DIALOG,
    this.label,
    this.hint,
    this.isFilteredOnline = false,
    this.popupTitle,
    this.items,
    this.selectedItem,
    this.onFind,
    this.dropdownBuilder,
    this.popupItemBuilder,
    this.showSearchBox = false,
    this.showClearButton = false,
    this.searchBoxDecoration,
    this.popupBackgroundColor,
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
    this.clearButton,
    this.clearButtonBuilder,
    this.dropDownButton,
    this.dropdownButtonBuilder,
    this.showAsSuffixIcons = false,
    this.dropdownBuilderSupportsNullItem = false,
    this.popupShape,
    this.popupItemDisabled,
    this.popupBarrierColor,
    this.onPopupDismissed,
    this.searchBoxController,
    this.searchDelay,
    this.onBeforeChange,
    this.favoriteItemBuilder,
    this.favoriteItems,
    this.showFavoriteItems = false,
    this.favoriteItemsAlignment = MainAxisAlignment.start,
    this.searchBoxStyle,
    this.popupSafeArea = const PopupSafeArea(),
  })  : assert(!showSelectedItem || T == String || compareFn != null),
        super(key: key);

  @override
  DropdownSearchState<T> createState() => DropdownSearchState<T>();
}

class DropdownSearchState<T> extends State<DropdownSearch<T>> {
  final ValueNotifier<T?> _selectedItemNotifier = ValueNotifier(null);
  final ValueNotifier<bool> _isFocused = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    _selectedItemNotifier.value = widget.selectedItem;
  }

  @override
  void didUpdateWidget(DropdownSearch<T> oldWidget) {
    final oldSelectedItem = oldWidget.selectedItem;
    final newSelectedItem = widget.selectedItem;
    if (oldSelectedItem != newSelectedItem) {
      _selectedItemNotifier.value = newSelectedItem;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<T?>(
      valueListenable: _selectedItemNotifier,
      builder: (context, data, wt) {
        return IgnorePointer(
          ignoring: !widget.enabled,
          child: GestureDetector(
            onTap: () => _selectSearchMode(data),
            child: _formField(data),
          ),
        );
      },
    );
  }

  Widget _defaultSelectItemWidget(T? data) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: widget.dropdownBuilder != null
              ? widget.dropdownBuilder!(
                  context,
                  data,
                  _selectedItemAsString(data),
                )
              : Text(_selectedItemAsString(data),
                  style: Theme.of(context).textTheme.subtitle1),
        ),
        if (!widget.showAsSuffixIcons) _manageTrailingIcons(data),
      ],
    );
  }

  Widget _formField(T? value) {
    return FormField(
      enabled: widget.enabled,
      onSaved: widget.onSaved,
      validator: widget.validator,
      autovalidateMode: widget.autoValidateMode,
      initialValue: widget.selectedItem,
      builder: (FormFieldState<T> state) {
        if (state.value != value) {
          WidgetsBinding.instance!.addPostFrameCallback((_) {
            state.didChange(value);
          });
        }
        return ValueListenableBuilder<bool>(
            valueListenable: _isFocused,
            builder: (context, isFocused, w) {
              return InputDecorator(
                isEmpty: value == null &&
                    (widget.dropdownBuilder == null ||
                        widget.dropdownBuilderSupportsNullItem),
                isFocused: isFocused,
                decoration: _manageDropdownDecoration(state, value),
                child: _defaultSelectItemWidget(value),
              );
            });
      },
    );
  }

  ///manage dropdownSearch field decoration
  InputDecoration _manageDropdownDecoration(FormFieldState state, T? data) {
    return (widget.dropdownSearchDecoration ??
            InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                border: OutlineInputBorder()))
        .applyDefaults(Theme.of(state.context).inputDecorationTheme)
        .copyWith(
            enabled: widget.enabled,
            labelText: widget.label,
            hintText: widget.hint,
            suffixIcon:
                widget.showAsSuffixIcons ? _manageTrailingIcons(data) : null,
            errorText: state.errorText);
  }

  ///function that return the String value of an object
  String _selectedItemAsString(T? data) {
    if (data == null) {
      return "";
    } else if (widget.itemAsString != null) {
      return widget.itemAsString!(data);
    } else {
      return data.toString();
    }
  }

  ///function that manage Trailing icons(close, dropDown)
  Widget _manageTrailingIcons(T? data) {
    final clearButtonPressed = () => _handleOnChangeSelectedItem(null);
    final dropdownButtonPressed = () => _selectSearchMode(data);

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        if (data != null && widget.showClearButton == true)
          widget.clearButtonBuilder != null
              ? GestureDetector(
                  onTap: clearButtonPressed,
                  child: widget.clearButtonBuilder!(context),
                )
              : IconButton(
                  icon: widget.clearButton ?? const Icon(Icons.clear, size: 24),
                  onPressed: clearButtonPressed,
                ),
        widget.dropdownButtonBuilder != null
            ? GestureDetector(
                onTap: dropdownButtonPressed,
                child: widget.dropdownButtonBuilder!(context),
              )
            : IconButton(
                icon: widget.dropDownButton ??
                    const Icon(Icons.arrow_drop_down, size: 24),
                onPressed: dropdownButtonPressed,
              ),
      ],
    );
  }

  ///open dialog
  Future<T?> _openSelectDialog(T? data) {
    return showGeneralDialog(
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      transitionDuration: const Duration(milliseconds: 400),
      barrierColor: widget.popupBarrierColor ?? const Color(0x80000000),
      context: context,
      pageBuilder: (context, animation, secondaryAnimation) {
        return SafeArea(
          top: widget.popupSafeArea.top,
          bottom: widget.popupSafeArea.bottom,
          left: widget.popupSafeArea.left,
          right: widget.popupSafeArea.right,
          child: AlertDialog(
            contentPadding: EdgeInsets.all(0),
            shape: widget.popupShape,
            backgroundColor: widget.popupBackgroundColor,
            content: _selectDialogInstance(data),
          ),
        );
      },
    );
  }

  ///open BottomSheet (Dialog mode)
  Future<T?> _openBottomSheet(T? data) {
    return showModalBottomSheet<T>(
        barrierColor: widget.popupBarrierColor,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        shape: widget.popupShape,
        context: context,
        builder: (ctx) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            builder: (_, child) {
              return SafeArea(
                top: widget.popupSafeArea.top,
                bottom: widget.popupSafeArea.bottom,
                left: widget.popupSafeArea.left,
                right: widget.popupSafeArea.right,
                child: Container(
                  color:
                      widget.popupBackgroundColor ?? Theme.of(ctx).canvasColor,
                  child: _selectDialogInstance(data, defaultHeight: 350),
                ),
              );
            },
          );
        });
  }

  ///openMenu
  Future<T?> _openMenu(T? data) {
    // Here we get the render object of our physical button, later to get its size & position
    final RenderBox popupButtonObject = context.findRenderObject() as RenderBox;
    // Get the render object of the overlay used in `Navigator` / `MaterialApp`, i.e. screen size reference
    final RenderBox overlay =
        Overlay.of(context)!.context.findRenderObject() as RenderBox;
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
      Size(overlay.size.width, overlay.size.height),
    );
    return customShowMenu<T>(
        popupSafeArea: widget.popupSafeArea,
        barrierColor: widget.popupBarrierColor,
        shape: widget.popupShape,
        color: widget.popupBackgroundColor,
        context: context,
        position: position,
        elevation: 8,
        items: [
          CustomPopupMenuItem(
            enabled: false,
            child: Container(
              width: popupButtonObject.size.width,
              child: _selectDialogInstance(data, defaultHeight: 224),
            ),
          ),
        ]);
  }

  SelectDialog<T> _selectDialogInstance(T? data, {double? defaultHeight}) {
    return SelectDialog<T>(
      searchBoxStyle: widget.searchBoxStyle,
      popupTitle: widget.popupTitle,
      maxHeight: widget.maxHeight ?? defaultHeight,
      isFilteredOnline: widget.isFilteredOnline,
      itemAsString: widget.itemAsString,
      filterFn: widget.filterFn,
      items: widget.items,
      onFind: widget.onFind,
      showSearchBox: widget.showSearchBox,
      itemBuilder: widget.popupItemBuilder,
      selectedValue: data,
      searchBoxDecoration: widget.searchBoxDecoration,
      onChanged: _handleOnChangeSelectedItem,
      showSelectedItem: widget.showSelectedItem,
      compareFn: widget.compareFn,
      emptyBuilder: widget.emptyBuilder,
      loadingBuilder: widget.loadingBuilder,
      errorBuilder: widget.errorBuilder,
      autoFocusSearchBox: widget.autoFocusSearchBox,
      dialogMaxWidth: widget.dialogMaxWidth,
      itemDisabled: widget.popupItemDisabled,
      searchBoxController:
          widget.searchBoxController ?? TextEditingController(),
      searchDelay: widget.searchDelay,
      showFavoriteItems: widget.showFavoriteItems,
      favoriteItems: widget.favoriteItems,
      favoriteItemBuilder: widget.favoriteItemBuilder,
      favoriteItemsAlignment: widget.favoriteItemsAlignment,
    );
  }

  ///Function that manage focus listener
  ///set true only if the widget already not focused to prevent unnecessary build
  ///same thing for clear focus,
  void _handleFocus(bool isFocused) {
    if (isFocused && !_isFocused.value) {
      FocusScope.of(context).unfocus();
      _isFocused.value = true;
    } else if (!isFocused && _isFocused.value) _isFocused.value = false;
  }

  ///handle on change value , if the validation is active , we validate the new selected item
  void _handleOnChangeSelectedItem(T? selectedItem) {
    final changeItem = () {
      _selectedItemNotifier.value = selectedItem;
      if (widget.onChanged != null) widget.onChanged!(selectedItem);
    };

    if (widget.onBeforeChange != null) {
      widget.onBeforeChange!(_selectedItemNotifier.value, selectedItem)
          .then((value) {
        if (value == true) {
          changeItem();
        }
      });
    } else {
      changeItem();
    }

    _handleFocus(false);
  }

  ///Function that return then UI based on searchMode
  ///[data] selected item to be passed to the UI
  ///If we close the popup , or maybe we just selected
  ///another widget we should clear the focus
  Future<T?> _selectSearchMode(T? data) async {
    _handleFocus(true);
    T? selectedItem;
    if (widget.mode == Mode.MENU) {
      selectedItem = await _openMenu(data);
    } else if (widget.mode == Mode.BOTTOM_SHEET) {
      selectedItem = await _openBottomSheet(data);
    } else {
      selectedItem = await _openSelectDialog(data);
    }
    _handleFocus(false);
    widget.onPopupDismissed?.call();

    return selectedItem;
  }

  ///Public Function that return then UI based on searchMode
  ///[data] selected item to be passed to the UI
  ///If we close the popup , or maybe we just selected
  ///another widget we should clear the focus
  ///THIS USED FOR OPEN DROPDOWN_SEARCH PROGRAMMATICALLY,
  ///otherwise you can you [_selectSearchMode]
  Future<T?> openDropDownSearch() =>
      _selectSearchMode(_selectedItemNotifier.value);

  ///Change selected Value; this function is public USED to change the selected
  ///value PROGRAMMATICALLY, Otherwise you can use [_handleOnChangeSelectedItem]
  void changeSelectedItem(T selectedItem) =>
      _handleOnChangeSelectedItem(selectedItem);

  ///Change selected Value; this function is public USED to clear selected
  ///value PROGRAMMATICALLY, Otherwise you can use [_handleOnChangeSelectedItem]
  void clear() => _handleOnChangeSelectedItem(null);

  ///get selected value programmatically
  T? get getSelectedItem => _selectedItemNotifier.value;

  ///check if the dropdownSearch is focused
  bool get isFocused => _isFocused.value;
}
