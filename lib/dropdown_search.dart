library dropdown_search;

import 'dart:async';

import 'package:dropdown_search/src/popupMenu.dart';
import 'package:dropdown_search/src/properties/icon_button_props.dart';
import 'package:dropdown_search/src/properties/popup_props.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'src/properties/popup_safearea_props.dart';
import 'src/selection_widget.dart';

export 'src/properties/icon_button_props.dart';
export 'src/properties/list_view_props.dart';
export 'src/properties/popup_props.dart';
export 'src/properties/popup_safearea_props.dart';
export 'src/properties/scrollbar_props.dart';
export 'src/properties/text_field_props.dart';

typedef Future<List<T>> DropdownSearchOnFind<T>(String? text);
typedef String DropdownSearchItemAsString<T>(T? item);
typedef bool DropdownSearchFilterFn<T>(T? item, String? filter);
typedef bool DropdownSearchCompareFn<T>(T? item, T? selectedItem);
typedef Widget DropdownSearchBuilder<T>(BuildContext context, T? selectedItem);
typedef Widget DropdownSearchBuilderMultiSelection<T>(
    BuildContext context, List<T> selectedItems);
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
typedef Future<bool?> BeforeChange<T>(T? prevItem, T? nextItem);
typedef Future<bool?> BeforeChangeMultiSelection<T>(
    List<T> prevItems, List<T> nextItems);
typedef Widget FavoriteItemsBuilder<T>(
    BuildContext context, T item, bool isSelected);
typedef Widget ValidationMultiSelectionBuilder<T>(
    BuildContext context, List<T> item);

typedef RelativeRect PositionCallback(
    RenderBox popupButtonObject, RenderBox overlay);

typedef void OnItemAdded<T>(List<T> selectedItems, T addedItem);
typedef void OnItemRemoved<T>(List<T> selectedItems, T removedItem);

///[items] are the original item from [items] or/and [asyncItems]
typedef List<T> FavoriteItems<T>(List<T> items);

enum Mode { DIALOG, MODAL_BOTTOM_SHEET, MENU, BOTTOM_SHEET }

class DropdownSearch<T> extends StatefulWidget {
  ///true if the filter on items is applied onlie (via API)
  final bool isFilteredOnline;

  ///show/hide clear selected item
  final bool showClearButton;

  ///offline items list
  final List<T>? items;

  ///selected item
  final T? selectedItem;

  ///selected items
  final List<T> selectedItems;

  ///function that returns item from API
  final DropdownSearchOnFind<T>? asyncItems;

  ///called when a new item is selected
  final ValueChanged<T?>? onChanged;

  ///called when a new items are selected
  final ValueChanged<List<T>>? onChangedMultiSelection;

  ///to customize list of items UI
  final DropdownSearchBuilder<T>? dropdownBuilder;

  ///to customize list of items UI in MultiSelection mode
  final DropdownSearchBuilderMultiSelection<T>? dropdownBuilderMultiSelection;

  ///customize the fields the be shown
  final DropdownSearchItemAsString<T>? itemAsString;

  ///	custom filter function
  final DropdownSearchFilterFn<T>? filterFn;

  ///enable/disable dropdownSearch
  final bool enabled;

  ///function that compares two object with the same type to detected if it's the selected item or not
  final DropdownSearchCompareFn<T>? compareFn;

  ///dropdownSearch input decoration
  final InputDecoration? dropdownSearchDecoration;

  /// style on which to base the label
  final TextStyle? dropdownSearchTextStyle;

  /// How the text in the decoration should be aligned horizontally.
  final TextAlign? dropdownSearchTextAlign;

  /// How the text should be aligned vertically.
  final TextAlignVertical? dropdownSearchTextAlignVertical;

  final AutovalidateMode? autoValidateMode;

  /// An optional method to call with the final value when the form is saved via
  final FormFieldSetter<T>? onSaved;

  /// An optional method to call with the final value when the form is saved via
  final FormFieldSetter<List<T>>? onSavedMultiSelection;

  /// An optional method that validates an input. Returns an error string to
  /// display if the input is invalid, or null otherwise.
  final FormFieldValidator<T>? validator;
  final FormFieldValidator<List<T>>? validatorMultiSelection;

  /// callback executed before applying value change
  final BeforeChange<T>? onBeforeChange;

  /// callback executed before applying values changes
  final BeforeChangeMultiSelection<T>? onBeforeChangeMultiSelection;

  ///set properties of popup safe area
  final PopupSafeAreaProps popupSafeArea;

  ///define whatever we are in multi selection mode or single selection mode
  final bool isMultiSelectionMode;

  /// props for selection focus node
  final FocusNode? focusNode;

  ///custom dropdown clear button icon properties
  final IconButtonProps? clearButtonProps;

  ///custom dropdown icon button properties
  final IconButtonProps? dropdownButtonProps;

  ///custom props to menu mode
  final PopupProps<T> popupProps;

  DropdownSearch({
    Key? key,
    this.onSaved,
    this.validator,
    this.autoValidateMode = AutovalidateMode.disabled,
    this.onChanged,
    this.isFilteredOnline = false,
    this.items,
    this.selectedItem,
    this.asyncItems,
    this.dropdownBuilder,
    this.clearButtonProps,
    this.showClearButton = false,
    this.enabled = true,
    this.filterFn,
    this.itemAsString,
    this.compareFn,
    this.dropdownSearchDecoration,
    this.dropdownButtonProps,
    this.onBeforeChange,
    this.popupSafeArea = const PopupSafeAreaProps(),
    this.dropdownSearchTextStyle,
    this.dropdownSearchTextAlign,
    this.dropdownSearchTextAlignVertical,
    this.focusNode,
    this.popupProps = const PopupProps(),
  })  : assert(
          !popupProps.showSelectedItems || T == String || compareFn != null,
        ),
        this.isMultiSelectionMode = false,
        this.dropdownBuilderMultiSelection = null,
        this.validatorMultiSelection = null,
        this.onBeforeChangeMultiSelection = null,
        this.selectedItems = const [],
        this.onSavedMultiSelection = null,
        this.onChangedMultiSelection = null,
        super(key: key);

  DropdownSearch.multiSelection({
    Key? key,
    this.autoValidateMode = AutovalidateMode.disabled,
    this.isFilteredOnline = false,
    this.items,
    this.asyncItems,
    this.showClearButton = false,
    this.clearButtonProps,
    this.enabled = true,
    this.filterFn,
    this.itemAsString,
    this.compareFn,
    this.dropdownSearchDecoration,
    this.dropdownButtonProps,
    this.popupSafeArea = const PopupSafeAreaProps(),
    this.dropdownSearchTextStyle,
    this.dropdownSearchTextAlign,
    this.dropdownSearchTextAlignVertical,
    this.selectedItems = const [],
    FormFieldSetter<List<T>>? onSaved,
    ValueChanged<List<T>>? onChanged,
    BeforeChangeMultiSelection<T>? onBeforeChange,
    FormFieldValidator<List<T>>? validator,
    DropdownSearchBuilderMultiSelection<T>? dropdownBuilder,
    this.focusNode,
    this.popupProps = const PopupProps.multiSelection(),
  })  : assert(
          !popupProps.showSelectedItems || T == String || compareFn != null,
        ),
        this.onChangedMultiSelection = onChanged,
        this.onSavedMultiSelection = onSaved,
        this.onBeforeChangeMultiSelection = onBeforeChange,
        this.validatorMultiSelection = validator,
        this.dropdownBuilderMultiSelection = dropdownBuilder,
        this.isMultiSelectionMode = true,
        this.dropdownBuilder = null,
        this.validator = null,
        this.onBeforeChange = null,
        this.selectedItem = null,
        this.onSaved = null,
        this.onChanged = null,
        super(key: key);

  @override
  DropdownSearchState<T> createState() => DropdownSearchState<T>();
}

class DropdownSearchState<T> extends State<DropdownSearch<T>> {
  final ValueNotifier<List<T>> _selectedItemsNotifier = ValueNotifier([]);
  final ValueNotifier<bool> _isFocused = ValueNotifier(false);
  final _popupStateKey = GlobalKey<SelectionWidgetState<T>>();

  @override
  void initState() {
    super.initState();
    _selectedItemsNotifier.value = isMultiSelectionMode
        ? List.from(widget.selectedItems)
        : _itemToList(widget.selectedItem);
  }

  @override
  void didUpdateWidget(DropdownSearch<T> oldWidget) {
    List<T> oldSelectedItems = isMultiSelectionMode
        ? oldWidget.selectedItems
        : _itemToList(oldWidget.selectedItem);

    List<T> newSelectedItems = isMultiSelectionMode
        ? widget.selectedItems
        : _itemToList(widget.selectedItem);

    if (!listEquals(oldSelectedItems, newSelectedItems)) {
      _selectedItemsNotifier.value = List.from(newSelectedItems);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<T?>>(
      valueListenable: _selectedItemsNotifier,
      builder: (context, data, wt) {
        return IgnorePointer(
          ignoring: !widget.enabled,
          child: InkWell(
            onTap: () => _selectSearchMode(),
            child: _formField(),
          ),
        );
      },
    );
  }

  List<T> _itemToList(T? item) {
    List<T?> nullableList = List.filled(1, item);
    return nullableList.whereType<T>().toList();
  }

  Widget _defaultSelectedItemWidget() {
    Widget defaultItemMultiSelectionMode(T item) {
      return Container(
        height: 32,
        padding: EdgeInsets.only(left: 8, right: 1),
        margin: EdgeInsets.symmetric(horizontal: 2, vertical: 1),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).primaryColorLight,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                _selectedItemAsString(item),
                style: Theme.of(context).textTheme.subtitle2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            MaterialButton(
              height: 20,
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(0),
              minWidth: 20,
              onPressed: () {
                removeItem(item);
              },
              child: Icon(
                Icons.close_outlined,
                size: 20,
              ),
            )
          ],
        ),
      );
    }

    Widget selectedItemWidget() {
      if (widget.dropdownBuilder != null) {
        return widget.dropdownBuilder!(
          context,
          getSelectedItem,
        );
      } else if (widget.dropdownBuilderMultiSelection != null)
        return widget.dropdownBuilderMultiSelection!(
          context,
          getSelectedItems,
        );
      else if (isMultiSelectionMode) {
        return Wrap(
          children: getSelectedItems
              .map((e) => defaultItemMultiSelectionMode(e))
              .toList(),
        );
      }
      return Text(_selectedItemAsString(getSelectedItem),
          style: Theme.of(context).textTheme.subtitle1);
    }

    return selectedItemWidget();
  }

  Widget _formField() {
    return isMultiSelectionMode
        ? _formFieldMultiSelection()
        : _formFieldSingleSelection();
  }

  Widget _formFieldSingleSelection() {
    return FormField<T>(
      enabled: widget.enabled,
      onSaved: widget.onSaved,
      validator: widget.validator,
      autovalidateMode: widget.autoValidateMode,
      initialValue: widget.selectedItem,
      builder: (FormFieldState<T> state) {
        if (state.value != getSelectedItem) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            state.didChange(getSelectedItem);
          });
        }
        return ValueListenableBuilder<bool>(
            valueListenable: _isFocused,
            builder: (context, isFocused, w) {
              return InputDecorator(
                baseStyle: widget.dropdownSearchTextStyle,
                textAlign: widget.dropdownSearchTextAlign,
                textAlignVertical: widget.dropdownSearchTextAlignVertical,
                isEmpty:
                    getSelectedItem == null && widget.dropdownBuilder == null,
                isFocused: isFocused,
                decoration: _manageDropdownDecoration(state),
                child: _defaultSelectedItemWidget(),
              );
            });
      },
    );
  }

  Widget _formFieldMultiSelection() {
    return FormField<List<T>>(
      enabled: widget.enabled,
      onSaved: widget.onSavedMultiSelection,
      validator: widget.validatorMultiSelection,
      autovalidateMode: widget.autoValidateMode,
      initialValue: widget.selectedItems,
      builder: (FormFieldState<List<T>> state) {
        if (state.value != getSelectedItems) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            state.didChange(getSelectedItems);
          });
        }
        return ValueListenableBuilder<bool>(
            valueListenable: _isFocused,
            builder: (context, isFocused, w) {
              return InputDecorator(
                baseStyle: widget.dropdownSearchTextStyle,
                textAlign: widget.dropdownSearchTextAlign,
                textAlignVertical: widget.dropdownSearchTextAlignVertical,
                isEmpty: getSelectedItems.isEmpty &&
                    widget.dropdownBuilderMultiSelection == null,
                isFocused: isFocused,
                decoration: _manageDropdownDecoration(state),
                child: _defaultSelectedItemWidget(),
              );
            });
      },
    );
  }

  ///manage dropdownSearch field decoration
  InputDecoration _manageDropdownDecoration(FormFieldState state) {
    return (widget.dropdownSearchDecoration ??
            const InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
              border: OutlineInputBorder(),
            ))
        .applyDefaults(Theme.of(state.context).inputDecorationTheme)
        .copyWith(
          enabled: widget.enabled,
          suffixIcon: _manageSuffixIcons(),
          errorText: state.errorText,
        );
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
  Widget _manageSuffixIcons() {
    final clearButtonPressed = () => clear();
    final dropdownButtonPressed = () => _selectSearchMode();

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        if (widget.showClearButton == true && getSelectedItems.isNotEmpty)
          IconButton(
            icon: widget.clearButtonProps?.icon ??
                const Icon(Icons.clear, size: 24),
            onPressed: clearButtonPressed,
            constraints: widget.clearButtonProps?.constraints,
            hoverColor: widget.clearButtonProps?.hoverColor,
            highlightColor: widget.clearButtonProps?.highlightColor,
            splashColor: widget.clearButtonProps?.splashColor,
            color: widget.clearButtonProps?.color,
            focusColor: widget.clearButtonProps?.focusColor,
            iconSize: widget.clearButtonProps?.iconSize ?? 24.0,
            padding:
                widget.clearButtonProps?.padding ?? const EdgeInsets.all(8.0),
            splashRadius: widget.clearButtonProps?.splashRadius,
            alignment: widget.clearButtonProps?.alignment ?? Alignment.center,
            autofocus: widget.clearButtonProps?.autofocus ?? false,
            disabledColor: widget.clearButtonProps?.disabledColor,
            enableFeedback: widget.clearButtonProps?.enableFeedback ?? false,
            focusNode: widget.clearButtonProps?.focusNode,
            mouseCursor: widget.clearButtonProps?.mouseCursor ??
                SystemMouseCursors.click,
            tooltip: widget.clearButtonProps?.tooltip,
            visualDensity: widget.clearButtonProps?.visualDensity,
          ),
        IconButton(
          icon: widget.dropdownButtonProps?.icon ??
              const Icon(Icons.arrow_drop_down, size: 24),
          onPressed: dropdownButtonPressed,
          constraints: widget.dropdownButtonProps?.constraints,
          hoverColor: widget.dropdownButtonProps?.hoverColor,
          highlightColor: widget.dropdownButtonProps?.highlightColor,
          splashColor: widget.dropdownButtonProps?.splashColor,
          color: widget.dropdownButtonProps?.color,
          focusColor: widget.dropdownButtonProps?.focusColor,
          iconSize: widget.dropdownButtonProps?.iconSize ?? 24.0,
          padding:
              widget.dropdownButtonProps?.padding ?? const EdgeInsets.all(8.0),
          splashRadius: widget.dropdownButtonProps?.splashRadius,
          alignment: widget.dropdownButtonProps?.alignment ?? Alignment.center,
          autofocus: widget.dropdownButtonProps?.autofocus ?? false,
          disabledColor: widget.dropdownButtonProps?.disabledColor,
          enableFeedback: widget.dropdownButtonProps?.enableFeedback ?? false,
          focusNode: widget.dropdownButtonProps?.focusNode,
          mouseCursor: widget.dropdownButtonProps?.mouseCursor ??
              SystemMouseCursors.click,
          tooltip: widget.dropdownButtonProps?.tooltip,
          visualDensity: widget.dropdownButtonProps?.visualDensity,
        ),
      ],
    );
  }

  ///open dialog
  Future _openSelectDialog() {
    return showGeneralDialog(
      barrierDismissible: widget.popupProps.barrierDismissible,
      barrierLabel: widget.popupProps.barrierLabel,
      transitionDuration: widget.popupProps.transitionDuration,
      barrierColor: widget.popupProps.barrierColor ?? const Color(0x80000000),
      context: context,
      useRootNavigator: widget.popupProps.useRootNavigator,
      pageBuilder: (context, animation, secondaryAnimation) {
        return SafeArea(
          top: widget.popupSafeArea.top,
          bottom: widget.popupSafeArea.bottom,
          left: widget.popupSafeArea.left,
          right: widget.popupSafeArea.right,
          child: AlertDialog(
            clipBehavior: widget.popupProps.clipBehavior,
            elevation: widget.popupProps.elevation,
            contentPadding: EdgeInsets.all(0),
            shape: widget.popupProps.shape,
            backgroundColor: widget.popupProps.color,
            semanticLabel: widget.popupProps.semanticLabel,
            contentTextStyle: widget.popupProps.textStyle,
            content: Container(
              child: _selectDialogInstance(),
              constraints: widget.popupProps.constraints,
            ),
          ),
        );
      },
    );
  }

  //todo handle max height
  _openBottomSheet() {
    return showBottomSheet(
        context: context,
        backgroundColor: widget.popupProps.color ?? Colors.transparent,
        clipBehavior: widget.popupProps.clipBehavior,
        elevation: widget.popupProps.elevation,
        shape: widget.popupProps.shape,
        transitionAnimationController: widget.popupProps.animation,
        constraints: widget.popupProps.constraints,
        builder: (ctx) {
          return _selectDialogInstance();
        });
  }

  ///open BottomSheet (Dialog mode)
  Future _openModalBottomSheet() {
    return showModalBottomSheet<T>(
        context: context,
        enableDrag: false,
        barrierColor: widget.popupProps.barrierColor,
        backgroundColor: widget.popupProps.color ?? Colors.transparent,
        isDismissible: widget.popupProps.barrierDismissible,
        isScrollControlled: true,
        clipBehavior: widget.popupProps.clipBehavior,
        elevation: widget.popupProps.elevation,
        shape: widget.popupProps.shape,
        useRootNavigator: widget.popupProps.useRootNavigator,
        transitionAnimationController: widget.popupProps.animation,
        constraints: widget.popupProps.constraints,
        builder: (ctx) {
          final MediaQueryData mediaQueryData = MediaQuery.of(ctx);
          EdgeInsets padding = mediaQueryData.padding;
          if (mediaQueryData.padding.bottom == 0.0 &&
              mediaQueryData.viewInsets.bottom != 0.0)
            padding =
                padding.copyWith(bottom: mediaQueryData.viewPadding.bottom);

          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: _selectDialogInstance(),
            ),
          );
        });
  }

  RelativeRect _position(RenderBox popupButtonObject, RenderBox overlay) {
    // Calculate the show-up area for the dropdown using button's size & position based on the `overlay` used as the coordinate space.
    return RelativeRect.fromSize(
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
  }

  ///openMenu
  Future _openMenu() {
    // Here we get the render object of our physical button, later to get its size & position
    final popupButtonObject = context.findRenderObject() as RenderBox;
    // Get the render object of the overlay used in `Navigator` / `MaterialApp`, i.e. screen size reference
    var overlay = Overlay.of(context)!.context.findRenderObject() as RenderBox;

    return showMenuTest<T>(
      menuModeProps: widget.popupProps,
      context: context,
      position: (widget.popupProps.positionCallback ?? _position)(
        popupButtonObject,
        overlay,
      ),
      child: Container(
        child: _selectDialogInstance(),
        constraints: widget.popupProps.constraints,
      ),
    );
  }

  Widget _selectDialogInstance() {
    return SelectionWidget<T>(
      key: _popupStateKey,
      popupProps: widget.popupProps,
      itemAsString: widget.itemAsString,
      filterFn: widget.filterFn,
      items: widget.items,
      asyncItems: widget.asyncItems,
      onChanged: _handleOnChangeSelectedItems,
      compareFn: widget.compareFn,
      isMultiSelectionMode: isMultiSelectionMode,
      defaultSelectedItems: List.from(getSelectedItems),
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
  void _handleOnChangeSelectedItems(List<T> selectedItems) {
    final changeItem = () {
      _selectedItemsNotifier.value = List.from(selectedItems);
      if (widget.onChanged != null)
        widget.onChanged!(getSelectedItem);
      else if (widget.onChangedMultiSelection != null)
        widget.onChangedMultiSelection!(selectedItems);
    };

    if (widget.onBeforeChange != null) {
      widget.onBeforeChange!(getSelectedItem,
              selectedItems.isEmpty ? null : selectedItems.first)
          .then((value) {
        if (value == true) {
          changeItem();
        }
      });
    } else if (widget.onBeforeChangeMultiSelection != null) {
      widget.onBeforeChangeMultiSelection!(getSelectedItems, selectedItems)
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

  ///compared two items base on user params
  bool _isEqual(T i1, T i2) {
    if (widget.compareFn != null)
      return widget.compareFn!(i1, i2);
    else
      return i1 == i2;
  }

  ///Function that return then UI based on searchMode
  ///[data] selected item to be passed to the UI
  ///If we close the popup , or maybe we just selected
  ///another widget we should clear the focus
  Future _selectSearchMode() async {
    _handleFocus(true);
    if (widget.popupProps.mode == Mode.MENU) {
      await _openMenu();
    } else if (widget.popupProps.mode == Mode.MODAL_BOTTOM_SHEET) {
      await _openModalBottomSheet();
    } else if (widget.popupProps.mode == Mode.BOTTOM_SHEET) {
      Future.value(_openBottomSheet());
    } else {
      await _openSelectDialog();
    }
    //todo pass these to popup
    _handleFocus(false);
    widget.popupProps.onDismissed?.call();
  }

  ///Change selected Value; this function is public USED to change the selected
  ///value PROGRAMMATICALLY, Otherwise you can use [_handleOnChangeSelectedItems]
  ///for multiSelection mode you can use [changeSelectedItems]
  void changeSelectedItem(T? selectedItem) =>
      _handleOnChangeSelectedItems(_itemToList(selectedItem));

  ///Change selected Value; this function is public USED to change the selected
  ///value PROGRAMMATICALLY, Otherwise you can use [_handleOnChangeSelectedItems]
  ///for SingleSelection mode you can use [changeSelectedItem]
  void changeSelectedItems(List<T> selectedItems) =>
      _handleOnChangeSelectedItems(selectedItems);

  ///function to remove an item from the list
  ///Useful i multiSelection mode to delete an item
  void removeItem(T itemToRemove) => _handleOnChangeSelectedItems(
      getSelectedItems..removeWhere((i) => _isEqual(itemToRemove, i)));

  ///Change selected Value; this function is public USED to clear selected
  ///value PROGRAMMATICALLY, Otherwise you can use [_handleOnChangeSelectedItems]
  void clear() => _handleOnChangeSelectedItems([]);

  ///get selected value programmatically USED for SINGLE_SELECTION mode
  T? get getSelectedItem =>
      getSelectedItems.isEmpty ? null : getSelectedItems.first;

  ///get selected values programmatically
  List<T> get getSelectedItems => _selectedItemsNotifier.value;

  ///check if the dropdownSearch is focused
  bool get isFocused => _isFocused.value;

  ///return true if we are in multiSelection mode , false otherwise
  bool get isMultiSelectionMode => widget.isMultiSelectionMode;

  ///Deselect items programmatically on the popup of selection
  void popupDeselectItems(List<T> itemsToDeselect) {
    _popupStateKey.currentState?.deselectItems(itemsToDeselect);
  }

  ///Deselect ALL items programmatically on the popup of selection
  void popupDeselectAllItems() {
    _popupStateKey.currentState?.deselectAllItems();
  }

  ///select ALL items programmatically on the popup of selection
  void popupSelectAllItems() {
    _popupStateKey.currentState?.selectAllItems();
  }

  ///select items programmatically on the popup of selection
  void popupSelectItems(List<T> itemsToSelect) {
    _popupStateKey.currentState?.selectItems(itemsToSelect);
  }

  ///validate selected items programmatically on the popup of selection
  void popupOnValidate() {
    _popupStateKey.currentState?.onValidate();
  }

  ///Public Function that return then UI based on searchMode
  ///[data] selected item to be passed to the UI
  ///If we close the popup , or maybe we just selected
  ///another widget we should clear the focus
  ///THIS USED FOR OPEN DROPDOWN_SEARCH PROGRAMMATICALLY,
  ///otherwise you can you [_selectSearchMode]
  void openDropDownSearch() => _selectSearchMode();

  ///close dropdownSearch popup if it's open
  void closeDropDownSearch() => _popupStateKey.currentState?.closePopup();
}
