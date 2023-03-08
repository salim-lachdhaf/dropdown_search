library dropdown_search;

import 'dart:async';

import 'package:dropdown_search/src/properties/clear_button_props.dart';
import 'package:dropdown_search/src/properties/dropdown_button_props.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'src/properties/dropdown_decorator_props.dart';
import 'src/properties/popup_props.dart';
import 'src/widgets/popup_menu.dart';
import 'src/widgets/selection_widget.dart';

export 'src/properties/bottom_sheet_props.dart';
export 'src/properties/clear_button_props.dart';
export 'src/properties/dialog_props.dart';
export 'src/properties/dropdown_button_props.dart';
export 'src/properties/dropdown_decorator_props.dart';
export 'src/properties/favorite_item_props.dart';
export 'src/properties/icon_button_props.dart';
export 'src/properties/list_view_props.dart';
export 'src/properties/menu_props.dart';
export 'src/properties/modal_bottom_sheet_props.dart';
export 'src/properties/popup_props.dart';
export 'src/properties/scrollbar_props.dart';
export 'src/properties/text_field_props.dart';

typedef Future<List<T>> DropdownSearchOnFind<T>(String text);
typedef String DropdownSearchItemAsString<T>(T item);
typedef bool DropdownSearchFilterFn<T>(T item, String filter);
typedef bool DropdownSearchCompareFn<T>(T item1, T item2);
typedef Widget DropdownSearchBuilder<T>(BuildContext context, T? selectedItem);
typedef Widget DropdownSearchBuilderMultiSelection<T>(
  BuildContext context,
  List<T> selectedItems,
);
typedef Widget DropdownSearchPopupItemBuilder<T>(
  BuildContext context,
  T item,
  bool isSelected,
);
typedef bool DropdownSearchPopupItemEnabled<T>(T item);
typedef Widget ErrorBuilder<T>(
  BuildContext context,
  String searchEntry,
  dynamic exception,
);
typedef Widget EmptyBuilder<T>(BuildContext context, String searchEntry);
typedef Widget LoadingBuilder<T>(BuildContext context, String searchEntry);
typedef Future<bool?> BeforeChange<T>(T? prevItem, T? nextItem);
typedef Future<bool?> BeforePopupOpening<T>(T? selectedItem);
typedef Future<bool?> BeforePopupOpeningMultiSelection<T>(List<T> selItems);
typedef Future<bool?> BeforeChangeMultiSelection<T>(
  List<T> prevItems,
  List<T> nextItems,
);
typedef Widget FavoriteItemsBuilder<T>(
  BuildContext context,
  T item,
  bool isSelected,
);
typedef Widget ValidationMultiSelectionBuilder<T>(
  BuildContext context,
  List<T> item,
);

typedef RelativeRect PositionCallback(
  RenderBox popupButtonObject,
  RenderBox overlay,
);

typedef void OnItemAdded<T>(List<T> selectedItems, T addedItem);
typedef void OnItemRemoved<T>(List<T> selectedItems, T removedItem);
typedef Widget PopupBuilder(BuildContext context, Widget popupWidget);

///[items] are the original item from [items] or/and [asyncItems]
typedef List<T> FavoriteItems<T>(List<T> items);

enum Mode { DIALOG, MODAL_BOTTOM_SHEET, MENU, BOTTOM_SHEET }

class DropdownSearch<T> extends StatefulWidget {
  ///offline items list
  final List<T> items;

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

  /// Used to configure the auto validation of [FormField] and [Form] widgets.
  final AutovalidateMode? autoValidateMode;

  /// An optional method to call with the final value when the form is saved via
  final FormFieldSetter<T>? onSaved;

  /// An optional method to call with the final value when the form is saved via
  final FormFieldSetter<List<T>>? onSavedMultiSelection;

  /// An optional method that validates an input. Returns an error string to
  /// display if the input is invalid, or null otherwise.
  final FormFieldValidator<T>? validator;

  /// An optional method that validates an input. Returns an error string to
  /// display if the input is invalid, or null otherwise.
  final FormFieldValidator<List<T>>? validatorMultiSelection;

  /// callback executed before applying value change
  final BeforeChange<T>? onBeforeChange;

  /// callback executed before applying values changes
  final BeforeChangeMultiSelection<T>? onBeforeChangeMultiSelection;

  ///define whatever we are in multi selection mode or single selection mode
  final bool isMultiSelectionMode;

  ///custom dropdown clear button icon properties
  final ClearButtonProps clearButtonProps;

  ///custom dropdown icon button properties
  final DropdownButtonProps dropdownButtonProps;

  ///custom props to single mode popup
  final PopupPropsMultiSelection<T> popupProps;

  ///dropdown decoration props
  final DropDownDecoratorProps dropdownDecoratorProps;

  ///a callBack will be called before opening le popup
  ///if the callBack return FALSE, the opening of the popup will be cancelled
  final BeforePopupOpening<T>? onBeforePopupOpening;

  ///a callBack will be called before opening le popup
  ///if the callBack return FALSE, the opening of the popup will be cancelled
  final BeforePopupOpeningMultiSelection<T>? onBeforePopupOpeningMultiSelection;

  DropdownSearch({
    Key? key,
    this.onSaved,
    this.validator,
    this.autoValidateMode = AutovalidateMode.disabled,
    this.onChanged,
    this.items = const [],
    this.selectedItem,
    this.asyncItems,
    this.dropdownBuilder,
    this.dropdownDecoratorProps = const DropDownDecoratorProps(),
    this.clearButtonProps = const ClearButtonProps(),
    this.dropdownButtonProps = const DropdownButtonProps(),
    this.enabled = true,
    this.filterFn,
    this.itemAsString,
    this.compareFn,
    this.onBeforeChange,
    this.onBeforePopupOpening,
    PopupProps<T> popupProps = const PopupProps.menu(),
  })  : assert(
          !popupProps.showSelectedItems || T == String || compareFn != null,
        ),
        this.popupProps = PopupPropsMultiSelection.from(popupProps),
        this.isMultiSelectionMode = false,
        this.dropdownBuilderMultiSelection = null,
        this.validatorMultiSelection = null,
        this.onBeforeChangeMultiSelection = null,
        this.selectedItems = const [],
        this.onSavedMultiSelection = null,
        this.onChangedMultiSelection = null,
        this.onBeforePopupOpeningMultiSelection = null,
        super(key: key);

  DropdownSearch.multiSelection({
    Key? key,
    this.autoValidateMode = AutovalidateMode.disabled,
    this.items = const [],
    this.asyncItems,
    this.dropdownDecoratorProps = const DropDownDecoratorProps(),
    this.clearButtonProps = const ClearButtonProps(),
    this.dropdownButtonProps = const DropdownButtonProps(),
    this.enabled = true,
    this.filterFn,
    this.itemAsString,
    this.compareFn,
    this.selectedItems = const [],
    this.popupProps = const PopupPropsMultiSelection.menu(),
    FormFieldSetter<List<T>>? onSaved,
    ValueChanged<List<T>>? onChanged,
    BeforeChangeMultiSelection<T>? onBeforeChange,
    BeforePopupOpeningMultiSelection<T>? onBeforePopupOpening,
    FormFieldValidator<List<T>>? validator,
    DropdownSearchBuilderMultiSelection<T>? dropdownBuilder,
  })  : assert(
          !popupProps.showSelectedItems || T == String || compareFn != null,
        ),
        this.onChangedMultiSelection = onChanged,
        this.onBeforePopupOpeningMultiSelection = onBeforePopupOpening,
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
        this.onBeforePopupOpening = null,
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
    _selectedItemsNotifier.value =
        isMultiSelectionMode ? List.from(widget.selectedItems) : _itemToList(widget.selectedItem);
  }

  @override
  void didUpdateWidget(DropdownSearch<T> oldWidget) {
    List<T> oldSelectedItems = isMultiSelectionMode ? oldWidget.selectedItems : _itemToList(oldWidget.selectedItem);

    List<T> newSelectedItems = isMultiSelectionMode ? widget.selectedItems : _itemToList(widget.selectedItem);

    if (!listEquals(oldSelectedItems, newSelectedItems)) {
      _selectedItemsNotifier.value = List.from(newSelectedItems);
    }

    ///this code check if we need to refresh the popup widget to update
    ///containerBuilder widget
    if (widget.popupProps.containerBuilder != oldWidget.popupProps.containerBuilder) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        _popupStateKey.currentState?.setState(() {});
      });
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
                style: Theme.of(context).textTheme.titleSmall,
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
          children: getSelectedItems.map((e) => defaultItemMultiSelectionMode(e)).toList(),
        );
      }
      return Text(
        _selectedItemAsString(getSelectedItem),
        style: widget.dropdownDecoratorProps.baseStyle,
        textAlign: widget.dropdownDecoratorProps.textAlign,
      );
    }

    return selectedItemWidget();
  }

  Widget _formField() {
    return isMultiSelectionMode ? _formFieldMultiSelection() : _formFieldSingleSelection();
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
            if(mounted) {
              state.didChange(getSelectedItem);
            }
          });
        }
        return ValueListenableBuilder<bool>(
            valueListenable: _isFocused,
            builder: (context, isFocused, w) {
              return InputDecorator(
                baseStyle: widget.dropdownDecoratorProps.baseStyle,
                textAlign: widget.dropdownDecoratorProps.textAlign,
                textAlignVertical: widget.dropdownDecoratorProps.textAlignVertical,
                isEmpty: getSelectedItem == null && widget.dropdownBuilder == null,
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
            if(mounted) {
              state.didChange(getSelectedItems);
            }
          });
        }
        return ValueListenableBuilder<bool>(
            valueListenable: _isFocused,
            builder: (context, isFocused, w) {
              return InputDecorator(
                baseStyle: widget.dropdownDecoratorProps.baseStyle,
                textAlign: widget.dropdownDecoratorProps.textAlign,
                textAlignVertical: widget.dropdownDecoratorProps.textAlignVertical,
                isEmpty: getSelectedItems.isEmpty && widget.dropdownBuilderMultiSelection == null,
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
    return (widget.dropdownDecoratorProps.dropdownSearchDecoration ??
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
        if (widget.clearButtonProps.isVisible && getSelectedItems.isNotEmpty)
          IconButton(
            style: widget.clearButtonProps.style,
            isSelected: widget.clearButtonProps.isSelected,
            selectedIcon: widget.clearButtonProps.selectedIcon,
            onPressed: widget.clearButtonProps.onPressed ?? clearButtonPressed,
            icon: widget.clearButtonProps.icon,
            constraints: widget.clearButtonProps.constraints,
            hoverColor: widget.clearButtonProps.hoverColor,
            highlightColor: widget.clearButtonProps.highlightColor,
            splashColor: widget.clearButtonProps.splashColor,
            color: widget.clearButtonProps.color,
            focusColor: widget.clearButtonProps.focusColor,
            iconSize: widget.clearButtonProps.iconSize,
            padding: widget.clearButtonProps.padding,
            splashRadius: widget.clearButtonProps.splashRadius,
            alignment: widget.clearButtonProps.alignment,
            autofocus: widget.clearButtonProps.autofocus,
            disabledColor: widget.clearButtonProps.disabledColor,
            enableFeedback: widget.clearButtonProps.enableFeedback,
            focusNode: widget.clearButtonProps.focusNode,
            mouseCursor: widget.clearButtonProps.mouseCursor,
            tooltip: widget.clearButtonProps.tooltip,
            visualDensity: widget.clearButtonProps.visualDensity,
          ),
        if (widget.dropdownButtonProps.isVisible)
          IconButton(
            style: widget.dropdownButtonProps.style,
            isSelected: widget.dropdownButtonProps.isSelected,
            selectedIcon: widget.dropdownButtonProps.selectedIcon,
            onPressed: widget.dropdownButtonProps.onPressed ?? dropdownButtonPressed,
            icon: widget.dropdownButtonProps.icon,
            constraints: widget.dropdownButtonProps.constraints,
            hoverColor: widget.dropdownButtonProps.hoverColor,
            highlightColor: widget.dropdownButtonProps.highlightColor,
            splashColor: widget.dropdownButtonProps.splashColor,
            color: widget.dropdownButtonProps.color,
            focusColor: widget.dropdownButtonProps.focusColor,
            iconSize: widget.dropdownButtonProps.iconSize,
            padding: widget.dropdownButtonProps.padding,
            splashRadius: widget.dropdownButtonProps.splashRadius,
            alignment: widget.dropdownButtonProps.alignment,
            autofocus: widget.dropdownButtonProps.autofocus,
            disabledColor: widget.dropdownButtonProps.disabledColor,
            enableFeedback: widget.dropdownButtonProps.enableFeedback,
            focusNode: widget.dropdownButtonProps.focusNode,
            mouseCursor: widget.dropdownButtonProps.mouseCursor,
            tooltip: widget.dropdownButtonProps.tooltip,
            visualDensity: widget.dropdownButtonProps.visualDensity,
          ),
      ],
    );
  }

  RelativeRect _position(RenderBox popupButtonObject, RenderBox overlay) {
    // Calculate the show-up area for the dropdown using button's size & position based on the `overlay` used as the coordinate space.
    return RelativeRect.fromSize(
      Rect.fromPoints(
        popupButtonObject.localToGlobal(popupButtonObject.size.bottomLeft(Offset.zero), ancestor: overlay),
        popupButtonObject.localToGlobal(popupButtonObject.size.bottomRight(Offset.zero), ancestor: overlay),
      ),
      Size(overlay.size.width, overlay.size.height),
    );
  }

  ///open dialog
  Future _openSelectDialog() {
    return showGeneralDialog(
      context: context,
      barrierDismissible: widget.popupProps.dialogProps.barrierDismissible,
      barrierLabel: widget.popupProps.dialogProps.barrierLabel,
      transitionDuration: widget.popupProps.dialogProps.transitionDuration,
      barrierColor: widget.popupProps.dialogProps.barrierColor ?? Colors.black54,
      useRootNavigator: widget.popupProps.dialogProps.useRootNavigator,
      anchorPoint: widget.popupProps.dialogProps.anchorPoint,
      transitionBuilder: widget.popupProps.dialogProps.transitionBuilder,
      pageBuilder: (context, animation, secondaryAnimation) {
        return AlertDialog(
          buttonPadding: widget.popupProps.dialogProps.buttonPadding,
          actionsOverflowButtonSpacing: widget.popupProps.dialogProps.actionsOverflowButtonSpacing,
          insetPadding: widget.popupProps.dialogProps.insetPadding,
          actionsPadding: widget.popupProps.dialogProps.actionsPadding,
          actionsOverflowDirection: widget.popupProps.dialogProps.actionsOverflowDirection,
          actionsOverflowAlignment: widget.popupProps.dialogProps.actionsOverflowAlignment,
          actionsAlignment: widget.popupProps.dialogProps.actionsAlignment,
          actions: widget.popupProps.dialogProps.actions,
          alignment: widget.popupProps.dialogProps.alignment,
          clipBehavior: widget.popupProps.dialogProps.clipBehavior,
          elevation: widget.popupProps.dialogProps.elevation,
          contentPadding: widget.popupProps.dialogProps.contentPadding,
          shape: widget.popupProps.dialogProps.shape,
          backgroundColor: widget.popupProps.dialogProps.backgroundColor,
          semanticLabel: widget.popupProps.dialogProps.semanticLabel,
          content: _popupWidgetInstance(),
        );
      },
    );
  }

  Future _openBottomSheet() {
    return showBottomSheet(
      context: context,
      enableDrag: widget.popupProps.bottomSheetProps.enableDrag,
      backgroundColor: widget.popupProps.bottomSheetProps.backgroundColor,
      clipBehavior: widget.popupProps.bottomSheetProps.clipBehavior,
      elevation: widget.popupProps.bottomSheetProps.elevation,
      shape: widget.popupProps.bottomSheetProps.shape,
      transitionAnimationController: widget.popupProps.bottomSheetProps.animation,
      constraints: widget.popupProps.bottomSheetProps.constraints,
      builder: (ctx) => _popupWidgetInstance(),
    ).closed;
  }

  ///open BottomSheet (Dialog mode)
  Future _openModalBottomSheet() {
    final sheetTheme = Theme.of(context).bottomSheetTheme;
    return showModalBottomSheet<T>(
      context: context,
      useSafeArea: widget.popupProps.modalBottomSheetProps.useSafeArea,
      barrierColor: widget.popupProps.modalBottomSheetProps.barrierColor,
      backgroundColor: widget.popupProps.modalBottomSheetProps.backgroundColor ??
          sheetTheme.modalBackgroundColor ??
          sheetTheme.backgroundColor ??
          Colors.white,
      isDismissible: widget.popupProps.modalBottomSheetProps.barrierDismissible,
      isScrollControlled: widget.popupProps.modalBottomSheetProps.isScrollControlled,
      enableDrag: widget.popupProps.modalBottomSheetProps.enableDrag,
      clipBehavior: widget.popupProps.modalBottomSheetProps.clipBehavior,
      elevation: widget.popupProps.modalBottomSheetProps.elevation,
      shape: widget.popupProps.modalBottomSheetProps.shape,
      anchorPoint: widget.popupProps.modalBottomSheetProps.anchorPoint,
      useRootNavigator: widget.popupProps.modalBottomSheetProps.useRootNavigator,
      transitionAnimationController: widget.popupProps.modalBottomSheetProps.animation,
      constraints: widget.popupProps.modalBottomSheetProps.constraints,
      builder: (ctx) => _popupWidgetInstance(),
    );
  }

  ///openMenu
  Future _openMenu() {
    // Here we get the render object of our physical button, later to get its size & position
    final popupButtonObject = context.findRenderObject() as RenderBox;
    // Get the render object of the overlay used in `Navigator` / `MaterialApp`, i.e. screen size reference
    var overlay = Overlay.of(context).context.findRenderObject() as RenderBox;

    return showCustomMenu<T>(
      menuModeProps: widget.popupProps.menuProps,
      context: context,
      position: (widget.popupProps.menuProps.positionCallback ?? _position)(
        popupButtonObject,
        overlay,
      ),
      child: _popupWidgetInstance(),
    );
  }

  Widget _popupWidgetInstance() {
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
      else if (widget.onChangedMultiSelection != null) widget.onChangedMultiSelection!(selectedItems);
    };

    if (widget.onBeforeChange != null) {
      widget.onBeforeChange!(getSelectedItem, selectedItems.isEmpty ? null : selectedItems.first).then((value) {
        if (value == true) {
          changeItem();
        }
      });
    } else if (widget.onBeforeChangeMultiSelection != null) {
      widget.onBeforeChangeMultiSelection!(getSelectedItems, selectedItems).then((value) {
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
  Future<void> _selectSearchMode() async {
    //handle onBefore popupOpening
    if (widget.onBeforePopupOpening != null) {
      if (await widget.onBeforePopupOpening!(getSelectedItem) == false) return;
    } else if (widget.onBeforePopupOpeningMultiSelection != null) {
      if (await widget.onBeforePopupOpeningMultiSelection!(getSelectedItems) == false) return;
    }

    _handleFocus(true);
    if (widget.popupProps.mode == Mode.MENU) {
      await _openMenu();
    } else if (widget.popupProps.mode == Mode.MODAL_BOTTOM_SHEET) {
      await _openModalBottomSheet();
    } else if (widget.popupProps.mode == Mode.BOTTOM_SHEET) {
      await _openBottomSheet();
    } else {
      await _openSelectDialog();
    }
    //dismiss either by selecting items OR clicking outside the popup
    widget.popupProps.onDismissed?.call();
    _handleFocus(false);
  }

  ///Change selected Value; this function is public USED to change the selected
  ///value PROGRAMMATICALLY, Otherwise you can use [_handleOnChangeSelectedItems]
  ///for multiSelection mode you can use [changeSelectedItems]
  void changeSelectedItem(T? selectedItem) => _handleOnChangeSelectedItems(_itemToList(selectedItem));

  ///Change selected Value; this function is public USED to change the selected
  ///value PROGRAMMATICALLY, Otherwise you can use [_handleOnChangeSelectedItems]
  ///for SingleSelection mode you can use [changeSelectedItem]
  void changeSelectedItems(List<T> selectedItems) => _handleOnChangeSelectedItems(selectedItems);

  ///function to remove an item from the list
  ///Useful in multiSelection mode to delete an item
  void removeItem(T itemToRemove) =>
      _handleOnChangeSelectedItems(getSelectedItems..removeWhere((i) => _isEqual(itemToRemove, i)));

  ///Change selected Value; this function is public USED to clear selected
  ///value PROGRAMMATICALLY, Otherwise you can use [_handleOnChangeSelectedItems]
  void clear() => _handleOnChangeSelectedItems([]);

  ///get selected value programmatically USED for SINGLE_SELECTION mode
  T? get getSelectedItem => getSelectedItems.isEmpty ? null : getSelectedItems.first;

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

  ///validate selected items programmatically passed in param [itemsToValidate]
  void popupValidate(List<T> itemsToValidate) {
    closeDropDownSearch();
    changeSelectedItems(itemsToValidate);
  }

  ///Public Function that return then UI based on searchMode
  ///[data] selected item to be passed to the UI
  ///If we close the popup , or maybe we just selected
  ///another widget we should clear the focus
  ///THIS USED FOR OPEN DROPDOWN_SEARCH PROGRAMMATICALLY,
  ///otherwise you can you [_selectSearchMode]
  void openDropDownSearch() => _selectSearchMode();

  ///return the state of the popup
  SelectionWidgetState<T>? get getPopupState => _popupStateKey.currentState;

  ///close dropdownSearch popup if it's open
  void closeDropDownSearch() => _popupStateKey.currentState?.closePopup();

  ///returns true if all popup's items are selected; other wise False
  bool get popupIsAllItemSelected => _popupStateKey.currentState?.isAllItemSelected ?? false;

  ///returns popup selected items
  List<T> get popupGetSelectedItems => _popupStateKey.currentState?.getSelectedItem ?? [];

  void updatePopupState() => _popupStateKey.currentState?.setState(() {});
}
