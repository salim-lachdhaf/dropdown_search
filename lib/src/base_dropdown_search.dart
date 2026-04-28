import 'dart:async';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:dropdown_search/src/popups/autocomplete_overlay.dart';
import 'package:dropdown_search/src/popups/bottom_sheets.dart';
import 'package:dropdown_search/src/popups/dialogs.dart';
import 'package:dropdown_search/src/popups/menu.dart';
import 'package:dropdown_search/src/popups/modal_bottom_sheet.dart';
import 'package:dropdown_search/src/utils.dart';
import 'package:dropdown_search/src/widgets/custom_chip.dart';
import 'package:dropdown_search/src/widgets/custom_icon_button.dart';
import 'package:dropdown_search/src/widgets/custom_inkwell.dart';
import 'package:dropdown_search/src/widgets/custom_wrap.dart';
import 'package:dropdown_search/src/widgets/hover_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'widgets/custom_scroll_view.dart';

typedef DropdownSearchOnFind<T> = FutureOr<List<T>> Function(
    String filter, LoadProps? loadProps);
typedef DropdownSearchItemAsString<T> = String Function(T item);
typedef DropdownSearchFilterFn<T> = bool Function(T item, String filter);
typedef DropdownSearchCompareFn<T> = bool Function(T item1, T item2);
typedef DropdownSearchBuilder<T> = Widget Function(
    BuildContext context, T? selectedItem);
typedef DropdownSearchBuilderMultiSelection<T> = Widget Function(
    BuildContext context, List<T> selectedItems);
typedef DropdownSearchPopupItemBuilder<T> = Widget Function(
    BuildContext context, T item, bool isDisabled, bool isSelected);
typedef DropdownSearchPopupItemEnabled<T> = bool Function(T item);
typedef ErrorBuilder = Widget Function(
    BuildContext context, String searchEntry, dynamic exception);
typedef EmptyBuilder = Widget Function(
    BuildContext context, String searchEntry);
typedef LoadingBuilder = Widget Function(
    BuildContext context, String searchEntry);
typedef BeforeChange<T> = FutureOr<bool> Function(T? prevItem, T? nextItem);
typedef BeforePopupOpening<T> = FutureOr<bool> Function(T? selectedItem);
typedef BeforePopupOpeningMultiSelection<T> = FutureOr<bool> Function(List<T> selectedItem);
typedef BeforeChangeMultiSelection<T> = FutureOr<bool> Function(List<T> prevItems, List<T> nextItems);

typedef ValidationMultiSelectionBuilder<T> = Widget Function(BuildContext context, List<T> items, void Function() validate);
typedef PositionCallback = RelativeRect Function(RenderBox dropdownBox, RenderBox overlay);
typedef OnItemAdded<T> = void Function(List<T> selectedItems, T addedItem);
typedef OnItemRemoved<T> = void Function(List<T> selectedItems, T removedItem);
typedef OnClearMultiSelection<T> = void Function();
typedef OnClear<T> = void Function();
typedef OnBeforeClearMultiSelection<T> = FutureOr<bool> Function(
    List<T> selectedItems);
typedef OnBeforeClear<T> = FutureOr<bool> Function(T? selectedItem);
typedef ContainerBuilder<T> = Widget Function(
    BuildContext context, Widget child);

enum PopupMode { dialog, modalBottomSheet, menu, bottomSheet, autocomplete }

enum Mode { form, custom }

enum UiMode { adaptive, material, cupertino }

abstract class BaseDropdownSearch<T> extends StatefulWidget {
  ///selected items
  final List<T> selectedItems;

  ///items/data
  final DropdownSearchOnFind<T>? items;

  ///called when a new item is selected
  final ValueChanged<T?>? onSelected;

  ///called when a new items are selected
  final ValueChanged<List<T>>? onSelectedMultiSelection;

  ///to customize list of items UI
  final DropdownSearchBuilder<T>? dropdownBuilder;

  ///to customize list of items UI in MultiSelection mode
  final DropdownSearchBuilderMultiSelection<T>? dropdownBuilderMultiSelection;

  /// scroll props for selected item on the dropdown.
  /// example :
  /// ```dart
  ///   SizedBox(
  ///        height: 50,
  ///       child: DropdownSearch<int>.multiSelection(
  ///               items: (f, cs) => [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15],
  ///               selectedItemsScrollProps: ScrollProps(),
  ///         ),
  ///    ),
  ///```
  final ScrollProps? selectedItemsScrollProps;

  final WrapProps? selectedItemsWrapProps;

  final ChipProps? chipProps;

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

  ///custom suffix widget props
  final DropdownSuffixProps suffixProps;

  ///dropdown click properties
  final ClickProps clickProps;

  ///custom popup properties
  final BasePopupProps<T> popupProps;

  ///dropdown decoration props
  final DropDownDecoratorProps decoratorProps;

  /// default text props that are going to be passed through the context to `selectedItem`
  final TextProps textProps;

  ///a callBack will be called before opening le popup
  ///if the callBack return FALSE, the opening of the popup will be cancelled
  final BeforePopupOpening<T>? onBeforePopupOpening;

  ///a callBack will be called before opening le popup
  ///if the callBack return FALSE, the opening of the popup will be cancelled
  final BeforePopupOpeningMultiSelection<T>? onBeforePopupOpeningMultiSelection;

  ///a callBack will be called before clearing all item by clicking on clear button
  ///if the callBack return FALSE, the CLEAR will be cancelled
  final OnBeforeClear<T>? onBeforeClear;
  final OnBeforeClearMultiSelection<T>? onBeforeClearMultiSelection;

  ///a callBack will be called after clearing all item by clicking on clear button
  final OnClear<T>? onClear;
  final OnClearMultiSelection<T>? onClearMultiSelection;

  final Mode mode;

  final UiToApply uiMode;

  final Object? groupId;

  /// Called when the focus state changes.
  final void Function(bool)? onFocusChange;

  BaseDropdownSearch({
    super.key,
    this.groupId,
    T? selectedItem,
    this.mode = Mode.form,
    this.autoValidateMode = AutovalidateMode.disabled,
    this.onSelected,
    this.items,
    this.dropdownBuilder,
    this.suffixProps = const DropdownSuffixProps(),
    ClickProps? clickProps,
    this.enabled = true,
    this.filterFn,
    this.itemAsString,
    this.compareFn,
    this.onBeforeChange,
    this.onBeforePopupOpening,
    required this.uiMode,
    required this.popupProps,
    //form properties
    this.onSaved,
    this.validator,
    this.chipProps,
    DropDownDecoratorProps? decoratorProps,
    this.textProps = const TextProps(),
    this.onFocusChange,
    this.onBeforeClear,
    this.onClear,
  })  : assert(
          T == String || T == int || T == double || compareFn != null,
          '`compareFn` is required',
        ),
        assert(
          mode != Mode.custom || dropdownBuilder != null,
          'Please implement your `dropdownBuilder`',
        ),
        assert(
          mode != Mode.custom ||
              (decoratorProps == null && onSaved == null && validator == null),
          'Custom mode has no form properties',
        ),
        assert(
          popupProps.mode != PopupMode.autocomplete || clickProps == null,
          "autocomplete mode has no clickProps",
        ),
        assert(
          popupProps.mode != PopupMode.autocomplete || mode != Mode.custom,
          "autocomplete mode and custom mode can't be used together",
        ),
        clickProps = clickProps ?? const ClickProps(),
        decoratorProps = decoratorProps ?? const DropDownDecoratorProps(),
        selectedItems = _itemToList(selectedItem),
        //to correct
        isMultiSelectionMode = false,
        dropdownBuilderMultiSelection = null,
        validatorMultiSelection = null,
        onBeforeChangeMultiSelection = null,
        onSavedMultiSelection = null,
        onSelectedMultiSelection = null,
        onBeforePopupOpeningMultiSelection = null,
        selectedItemsScrollProps = null,
        onClearMultiSelection = null,
        onBeforeClearMultiSelection = null,
        selectedItemsWrapProps = null;

  BaseDropdownSearch.multiSelection({
    super.key,
    this.groupId,
    this.mode = Mode.form,
    this.autoValidateMode = AutovalidateMode.disabled,
    this.items,
    this.suffixProps = const DropdownSuffixProps(),
    ClickProps? clickProps,
    this.enabled = true,
    this.filterFn,
    this.itemAsString,
    this.compareFn,
    this.selectedItems = const [],
    this.selectedItemsScrollProps,
    required this.popupProps,
    required this.uiMode,
    this.selectedItemsWrapProps,
    ValueChanged<List<T>>? onSelected,
    BeforeChangeMultiSelection<T>? onBeforeChange,
    BeforePopupOpeningMultiSelection<T>? onBeforePopupOpening,
    this.onFocusChange,
    DropdownSearchBuilderMultiSelection<T>? dropdownBuilder,
    //form properties
    FormFieldSetter<List<T>>? onSaved,
    FormFieldValidator<List<T>>? validator,
    DropDownDecoratorProps? decoratorProps,
    OnBeforeClearMultiSelection<T>? onBeforeClear,
    OnClearMultiSelection<T>? onClear,
    this.chipProps,
    this.textProps = const TextProps(),
  })  : assert(
          T == String || T == int || T == double || compareFn != null,
          '`compareFn` is required',
        ),
        assert(
          mode != Mode.custom || dropdownBuilder != null,
          'Please implement your `dropdownBuilder`',
        ),
        assert(
          mode != Mode.custom ||
              (decoratorProps == null && onSaved == null && validator == null),
          "Custom mode has no form properties",
        ),
        assert(
          popupProps.mode != PopupMode.autocomplete || clickProps == null,
          "autocomplete mode has no clickProps",
        ),
        assert(
          popupProps.mode != PopupMode.autocomplete || mode != Mode.custom,
          "autocomplete mode and custom mode can't be used together",
        ),
        clickProps = clickProps ?? const ClickProps(),
        decoratorProps = decoratorProps ?? const DropDownDecoratorProps(),
        onSelectedMultiSelection = onSelected,
        onBeforePopupOpeningMultiSelection = onBeforePopupOpening,
        onSavedMultiSelection = onSaved,
        onBeforeChangeMultiSelection = onBeforeChange,
        validatorMultiSelection = validator,
        dropdownBuilderMultiSelection = dropdownBuilder,
        onBeforeClearMultiSelection = onBeforeClear,
        onClearMultiSelection = onClear,
        isMultiSelectionMode = true,
        dropdownBuilder = null,
        validator = null,
        onBeforeChange = null,
        onSaved = null,
        onSelected = null,
        onClear = null,
        onBeforeClear = null,
        onBeforePopupOpening = null;

  static List<T> _itemToList<T>(T? item) {
    List<T?> nullableList = List.filled(1, item);
    return nullableList.whereType<T>().toList();
  }

  @override
  DropdownSearchState<T> createState() => DropdownSearchState<T>();
}

class DropdownSearchState<T> extends State<BaseDropdownSearch<T>> {
  final ValueNotifier<List<T>> _selectedItemsNotifier = ValueNotifier([]);
  final ValueNotifier<bool> _isFocused = ValueNotifier(false);
  final _popupStateKey = GlobalKey<DropdownSearchPopupState<T>>();
  CustomOverlayEntry? _customOverlyEntry;
  final autoCompleteFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _selectedItemsNotifier.value = List.from(widget.selectedItems);

    if (widget.popupProps.mode == PopupMode.autocomplete) {
      HardwareKeyboard.instance
          .addHandler(_handleAutoCompleteBackPressKeyPress);
    }

    _isFocused.addListener(() {
      widget.onFocusChange?.call(_isFocused.value);
    });
  }

  bool _handleAutoCompleteBackPressKeyPress(KeyEvent event) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace) {
      if (_popupStateKey.currentState?.searchBoxController.text.isEmpty ==
          true) {
        final item = getSelectedItems.last;
        removeItem(item);
        _popupStateKey.currentState?.deselectItems([item]);
      }
    }

    return false;
  }

  @override
  void didUpdateWidget(BaseDropdownSearch<T> oldWidget) {
    if (!listEquals(oldWidget.selectedItems, widget.selectedItems)) {
      _selectedItemsNotifier.value = List.from(widget.selectedItems);
    }

    ///this code check if we need to refresh the popup widget to update
    ///containerBuilder widget
    if (widget.popupProps.containerBuilder !=
        oldWidget.popupProps.containerBuilder) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        _popupStateKey.currentState?.setState(() {});
      });
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<T>>(
      valueListenable: _selectedItemsNotifier,
      builder: (context, data, wt) {
        return IgnorePointer(
          ignoring: !widget.enabled,
          child: CustomInkWell(
            clickProps: widget.popupProps.mode == PopupMode.autocomplete
                ? ClickProps(
                    canRequestFocus: false,
                    focusColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    mouseCursor: WidgetStateMouseCursor.textable,
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                  )
                : widget.clickProps,
            onTap: () =>
                widget.popupProps.mode == PopupMode.autocomplete && isFocused
                    ? null
                    : openDropDownSearch(),
            child: _dropDown(),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    closeDropDownSearch();
    autoCompleteFocusNode.dispose();
    _isFocused.dispose();
    HardwareKeyboard.instance
        .removeHandler(_handleAutoCompleteBackPressKeyPress);
    super.dispose();
  }

  Widget _dropDown() {
    if (widget.mode == Mode.custom) {
      return _customField();
    } else if (widget.popupProps.mode == PopupMode.autocomplete) {
      return _autocompleteFormFieldMultiSelection();
    } else {
      return _formField();
    }
  }

  Widget _autocompleteFormFieldMultiSelection() {
    return TapRegion(
      groupId: widget.groupId,
      child: FormField<List<T>>(
        enabled: widget.enabled,
        onSaved: widget.onSavedMultiSelection,
        validator: widget.validatorMultiSelection,
        autovalidateMode: widget.autoValidateMode,
        initialValue: widget.selectedItems,
        builder: (FormFieldState<List<T>> state) {
          if (!listEquals(state.value, getSelectedItems)) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                state.didChange(getSelectedItems);
              }
            });
          }
          return ValueListenableBuilder<bool>(
            valueListenable: _isFocused,
            builder: (context, isFocused, w) {
              final selectedItems = _buildSelectedItemsWidget();
              return HoverBuilder(builder: (context, isHovering) {
                return InputDecorator(
                  baseStyle: _getDecoratorBaseTextStyle(),
                  textAlign: widget.decoratorProps.textAlign,
                  textAlignVertical: widget.decoratorProps.textAlignVertical,
                  isEmpty: getSelectedItem == null,
                  isFocused: isFocused,
                  expands: widget.decoratorProps.expands,
                  isHovering: widget.decoratorProps.isHovering ?? isHovering,
                  decoration: _manageDropdownDecoration(state),
                  child: isFocused
                      ? Row(
                          children: [
                            if (selectedItems != null)
                              Flexible(child: selectedItems),
                            if (selectedItems != null)
                              Padding(padding: EdgeInsets.only(left: 4)),
                            Expanded(
                              child: TextFormField(
                                focusNode: autoCompleteFocusNode,
                                controller: _popupStateKey
                                    .currentState?.searchBoxController,
                                decoration:
                                    InputDecoration(border: InputBorder.none),
                              ),
                            ),
                          ],
                        )
                      : selectedItems,
                );
              });
            },
          );
        },
      ),
    );
  }

  Widget? _buildSelectedItemsWidget() {
    Widget? defaultSelectedItems(List<T> items) {
      if (items.isEmpty) return null;
      return CustomSingleScrollView(
        scrollProps: widget.selectedItemsScrollProps ?? ScrollProps(),
        child: CustomWrap(
          props: widget.selectedItemsWrapProps ??
              WrapProps(
                spacing: 6,
                runSpacing: 6,
                crossAxisAlignment: WrapCrossAlignment.center,
              ),
          children: items.map((e) {
            return CustomChip(
              label: Text(_itemAsString(e)),
              props: ChipProps(
                onDeleted: widget.enabled ? () => removeItem(e) : null,
                shape: widget.uiMode == UiToApply.cupertino
                    ? RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(18)))
                    : null,
                padding: const EdgeInsets.all(0),
                selected: true,
                deleteIcon: widget.uiMode == UiToApply.cupertino
                    ? Icon(CupertinoIcons.multiply_circle_fill)
                    : null,
              ).merge(widget.chipProps),
            );
          }).toList(),
        ),
      );
    }

    Widget? defaultSelectedItemWidget(T? item) {
      if (item == null) return null;
      return Text(
        _itemAsString(item),
      );
    }

    Widget? selectedItem = defaultSelectedItemWidget(getSelectedItem);

    if (widget.dropdownBuilder != null) {
      selectedItem = widget.dropdownBuilder!(context, getSelectedItem);
    } else if (widget.dropdownBuilderMultiSelection != null) {
      selectedItem =
          widget.dropdownBuilderMultiSelection!(context, getSelectedItems);
    } else if (isMultiSelectionMode) {
      selectedItem = defaultSelectedItems(getSelectedItems);
    }

    if (selectedItem != null) {
      return DefaultTextStyle.merge(
        style: _getTextStyle(),
        child: selectedItem,
        textAlign: widget.textProps.textAlign,
        softWrap: widget.textProps.softWrap,
        overflow: widget.textProps.overflow,
        maxLines: widget.textProps.maxLines,
        textWidthBasis: widget.textProps.textWidthBasis,
      );
    }

    return null;
  }

  TextStyle? _getDecoratorBaseTextStyle() {
    return widget.enabled
        ? widget.decoratorProps.baseStyle
        : TextStyle(color: Theme.of(context).disabledColor)
            .merge(widget.decoratorProps.baseStyle);
  }

  TextStyle? _getTextStyle() {
    return widget.enabled
        ? widget.textProps.style
        : TextStyle(color: Theme.of(context).disabledColor)
            .merge(widget.textProps.style);
  }

  Widget _formField() {
    return isMultiSelectionMode
        ? _formFieldMultiSelection()
        : _formFieldSingleSelection();
  }

  Widget _customField() => _buildSelectedItemsWidget() ?? SizedBox.shrink();

  Widget _formFieldSingleSelection() {
    return FormField<T>(
      enabled: widget.enabled,
      onSaved: widget.onSaved,
      validator: widget.validator,
      autovalidateMode: widget.autoValidateMode,
      initialValue: getSelectedItem,
      builder: (FormFieldState<T> state) {
        if (state.value != getSelectedItem) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              state.didChange(getSelectedItem);
            }
          });
        }
        return ValueListenableBuilder<bool>(
            valueListenable: _isFocused,
            builder: (context, isFocused, w) {
              return HoverBuilder(builder: (context, isHovering) {
                return InputDecorator(
                  baseStyle: _getDecoratorBaseTextStyle(),
                  textAlign: widget.decoratorProps.textAlign,
                  textAlignVertical: widget.decoratorProps.textAlignVertical,
                  isEmpty: getSelectedItem == null,
                  isFocused: isFocused,
                  expands: widget.decoratorProps.expands,
                  isHovering: widget.decoratorProps.isHovering ?? isHovering,
                  decoration: _manageDropdownDecoration(state),
                  child: _buildSelectedItemsWidget(),
                );
              });
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
        if (!listEquals(state.value, getSelectedItems)) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              state.didChange(getSelectedItems);
            }
          });
        }
        return ValueListenableBuilder<bool>(
          valueListenable: _isFocused,
          builder: (context, isFocused, w) {
            return HoverBuilder(builder: (context, isHovering) {
              return InputDecorator(
                baseStyle: _getDecoratorBaseTextStyle(),
                textAlign: widget.decoratorProps.textAlign,
                textAlignVertical: widget.decoratorProps.textAlignVertical,
                isEmpty: getSelectedItems.isEmpty,
                expands: widget.decoratorProps.expands,
                isHovering: widget.decoratorProps.isHovering ?? isHovering,
                isFocused: isFocused,
                decoration: _manageDropdownDecoration(state),
                child: _buildSelectedItemsWidget(),
              );
            });
          },
        );
      },
    );
  }

  ///manage dropdownSearch field decoration
  InputDecoration _manageDropdownDecoration(FormFieldState state) {
    final cupertinoBorder = OutlineInputBorder(
      borderRadius: kCupertinoBorderRadius,
      borderSide: kCupertinoBorderSide,
    );

    final cupertinoDecoration = InputDecoration(
      border: cupertinoBorder,
      enabledBorder: cupertinoBorder,
      focusedBorder: cupertinoBorder,
      filled: true,
      fillColor: kCupertinoTextFieldBG,
      hoverColor: kCupertinoTextFieldBG,
      contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0),
    );

    final materialDefaultDecoration = const InputDecoration(
      contentPadding: EdgeInsets.fromLTRB(12, 4, 12, 4),
      border: OutlineInputBorder(),
    );

    final decoration = widget.decoratorProps.decoration ??
        (widget.uiMode == UiToApply.cupertino
            ? cupertinoDecoration
            : materialDefaultDecoration);
    return decoration
        .applyDefaults(Theme.of(state.context).inputDecorationTheme)
        .copyWith(
          enabled: widget.enabled,
          suffixIcon: _manageSuffixIcons(),
          errorText: state.errorText,
        );
  }

  ///function that return the String value of an object
  String _itemAsString(T? data) {
    if (data == null) {
      return "";
    } else if (widget.itemAsString != null) {
      return widget.itemAsString!(data);
    }

    return data.toString();
  }

  ///function that manage Trailing icons(clear, dropDown)
  Widget? _manageSuffixIcons() {
    Widget? getClearButton() {
      final props = widget.suffixProps.clearButtonProps;
      if (props == null || !props.isVisible || getSelectedItems.isEmpty) {
        return null;
      }
      return CustomIconButton(
        props: props,
        onPressed: () => clear(),
        icon: props.icon ??
            Icon(widget.uiMode == UiToApply.cupertino
                ? CupertinoIcons.clear_circled_solid
                : Icons.clear),
      );
    }

    Widget? getDropdownButton() {
      final dropDownButton =
          widget.suffixProps.dropdownButtonProps ?? DropdownButtonProps();
      if (!dropDownButton.isVisible) return null;

      //icon required
      final dropDownClosedIcon = dropDownButton.icon ??
          Icon(widget.uiMode == UiToApply.cupertino
              ? CupertinoIcons.chevron_down
              : Icons.arrow_drop_down);

      final icon = dropDownButton.iconOpened == null
          ? dropDownClosedIcon
          : (isFocused ? dropDownButton.iconOpened! : dropDownClosedIcon);

      final button = CustomIconButton(
        key: ValueKey(isFocused), //useful for AnimatedSwitch uses for example
        props: dropDownButton,
        icon: icon,
        onPressed: () => toggleDropDownSearch(),
      );

      return dropDownButton.animationBuilder(button, isFocused);
    }

    final dropdownButton = getDropdownButton();
    final clearButton = getClearButton();

    if (dropdownButton == null && clearButton == null) return null;

    return Row(
      textDirection: widget.suffixProps.direction,
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        if (clearButton != null) clearButton,
        if (dropdownButton != null) dropdownButton,
      ],
    );
  }

  Future _openPopup() {
    if (widget.popupProps.mode == PopupMode.dialog) {
      return _openSelectDialog();
    } else if (widget.popupProps.mode == PopupMode.modalBottomSheet) {
      return _openModalBottomSheet();
    } else if (widget.popupProps.mode == PopupMode.bottomSheet) {
      return _openBottomSheet();
    } else if (widget.popupProps.mode == PopupMode.autocomplete) {
      return _openAutoCompleteMenu();
    }

    return _openMenu();
  }

  Future _openAutoCompleteMenu() {
    if (_customOverlyEntry?.isOpen() == true) return Future.value();

    autoCompleteFocusNode.requestFocus();

    if (widget.uiMode == UiToApply.cupertino) {
      _customOverlyEntry = CupertinoCustomOverlyEntry(
          child: _popupWidgetInstance(),
          constraints: widget.popupProps.constraints,
          onTapOutside: (event) => closeDropDownSearch(),
          props: isMultiSelectionMode
              ? (widget.popupProps as CupertinoMultiSelectionPopupProps<T>)
                  .autoCompleteProps
              : (widget.popupProps as CupertinoPopupProps<T>)
                  .autoCompleteProps);
    } else {
      _customOverlyEntry = MaterialCustomOverlyEntry(
          child: _popupWidgetInstance(),
          constraints: widget.popupProps.constraints,
          onTapOutside: (event) => closeDropDownSearch(),
          props: isMultiSelectionMode
              ? (widget.popupProps as MultiSelectionPopupProps<T>)
                  .autoCompleteProps
              : (widget.popupProps as PopupProps<T>).autoCompleteProps);
    }
    return _customOverlyEntry!.open(context);
  }

  ///open dialog
  Future _openSelectDialog() {
    if (widget.uiMode == UiToApply.cupertino) {
      return openCupertinoDialog(
        context,
        _popupWidgetInstance(),
        isMultiSelectionMode
            ? (widget.popupProps as CupertinoMultiSelectionPopupProps<T>)
                .dialogProps
            : (widget.popupProps as CupertinoPopupProps<T>).dialogProps,
        [
          CupertinoDialogAction(
            child: Text("Cancel"),
            isDestructiveAction: true,
            onPressed: () => closeDropDownSearch(),
          ),
          if (isMultiSelectionMode)
            CupertinoDialogAction(
              child: Text("OK"),
              isDefaultAction: true,
              onPressed: () => _popupStateKey.currentState?.onValidate(),
            ),
        ],
      );
    }

    return openMaterialDialog(
      context,
      _popupWidgetInstance(),
      isMultiSelectionMode
          ? (widget.popupProps as MultiSelectionPopupProps<T>).dialogProps
          : (widget.popupProps as PopupProps<T>).dialogProps,
    );
  }

  Future _openBottomSheet() {
    if (widget.uiMode == UiToApply.cupertino) {
      return openCupertinoBottomSheet(
        context,
        _popupWidgetInstance(),
        isMultiSelectionMode
            ? (widget.popupProps as CupertinoMultiSelectionPopupProps<T>)
                .bottomSheetProps
            : (widget.popupProps as CupertinoPopupProps<T>).bottomSheetProps,
      );
    }

    return openMaterialBottomSheet(
      context,
      _popupWidgetInstance(),
      isMultiSelectionMode
          ? (widget.popupProps as MultiSelectionPopupProps<T>).bottomSheetProps
          : (widget.popupProps as PopupProps<T>).bottomSheetProps,
    );
  }

  ///open BottomSheet (Dialog mode)
  Future _openModalBottomSheet() {
    if (widget.uiMode == UiToApply.cupertino) {
      return openCupertinoModalBottomSheet(
        context,
        _popupWidgetInstance(),
        isMultiSelectionMode
            ? (widget.popupProps as CupertinoMultiSelectionPopupProps<T>)
                .modalBottomSheetProps
            : (widget.popupProps as CupertinoPopupProps<T>)
                .modalBottomSheetProps,
        isMultiSelectionMode
            ? [
                CupertinoActionSheetAction(
                    onPressed: () => popupOnValidate(), child: Text('OK'))
              ]
            : null,
      );
    }

    return openMaterialModalBottomSheet(
      context,
      _popupWidgetInstance(),
      isMultiSelectionMode
          ? (widget.popupProps as MultiSelectionPopupProps<T>)
              .modalBottomSheetProps
          : (widget.popupProps as PopupProps<T>).modalBottomSheetProps,
    );
  }

  ///openMenu
  Future _openMenu() {
    if (widget.uiMode == UiToApply.cupertino) {
      final menuProps = isMultiSelectionMode
          ? (widget.popupProps as CupertinoMultiSelectionPopupProps<T>)
              .menuProps
          : (widget.popupProps as CupertinoPopupProps<T>).menuProps;

      return CupertinoCustomMenu<T>(
        props: menuProps,
        child: _popupWidgetInstance(),
        constraints: widget.popupProps.constraints,
        context: context,
      ).openMenu();
    } else {
      final menuProps = isMultiSelectionMode
          ? (widget.popupProps as MultiSelectionPopupProps<T>).menuProps
          : (widget.popupProps as PopupProps<T>).menuProps;
      return MaterialCustomMenu<T>(
        props: menuProps,
        child: _popupWidgetInstance(),
        constraints: widget.popupProps.constraints,
        context: context,
      ).openMenu();
    }
  }

  Widget _popupWidgetInstance() {
    return DropdownSearchPopup<T>(
      key: _popupStateKey,
      uiMode: widget.uiMode,
      props: widget.popupProps,
      itemAsString: widget.itemAsString,
      filterFn: widget.filterFn,
      items: widget.items,
      onSelected: _handleOnChangeSelectedItems,
      compareFn: widget.compareFn,
      isMultiSelectionMode: isMultiSelectionMode,
      defaultSelectedItems: List.from(getSelectedItems),
      dropdownMode: widget.popupProps.mode,
      onClose: () => closeDropDownSearch(),
    );
  }

  ///Function that manage focus listener
  ///set true only if the widget already not focused to prevent unnecessary build
  ///same thing for clear focus,
  void _handleFocus(bool isFocused) {
    if (isFocused && !_isFocused.value) {
      FocusScope.of(context).unfocus();
      _isFocused.value = true;
    } else if (!isFocused && _isFocused.value) {
      _isFocused.value = false;
    }
  }

  ///handle on change value , if the validation is active , we validate the new selected item
  void _handleOnChangeSelectedItems(List<T> selectedItems) {
    changeItem() {
      _selectedItemsNotifier.value = List.from(selectedItems);
      if (widget.onSelected != null) {
        widget.onSelected!(getSelectedItem);
      } else if (widget.onSelectedMultiSelection != null) {
        widget.onSelectedMultiSelection!(selectedItems);
      }
    }

    if (widget.onBeforeChange != null) {
      Future.value(
        widget.onBeforeChange!(getSelectedItem,
            selectedItems.isEmpty ? null : selectedItems.first),
      ).then((allowed) => allowed ? changeItem() : null);
    } else if (widget.onBeforeChangeMultiSelection != null) {
      Future.value(
        widget.onBeforeChangeMultiSelection!(getSelectedItems, selectedItems),
      ).then((allowed) => allowed ? changeItem() : null);
    } else {
      changeItem();
    }
  }

  ///compared two items base on user params
  bool _isEqual(T i1, T i2) {
    if (widget.compareFn != null) {
      return widget.compareFn!(i1, i2);
    } else {
      return i1 == i2;
    }
  }

  ///Function that return then UI based on searchMode
  ///[data] selected item to be passed to the UI
  ///If we close the popup , or maybe we just selected
  ///another widget we should clear the focus
  Future<void> _selectSearchMode() async {
    //fix Duplicate GlobalKey detected in widget tree.
    //if the popup not yet disposed do nothing => solve issue fast click
    if (_popupStateKey.currentState != null) return;

    //handle onBefore popupOpening
    if (widget.onBeforePopupOpening != null) {
      if (await widget.onBeforePopupOpening!(getSelectedItem) == false) return;
    } else if (widget.onBeforePopupOpeningMultiSelection != null) {
      if (await widget.onBeforePopupOpeningMultiSelection!(getSelectedItems) ==
          false) {
        return;
      }
    }

    _handleFocus(true);
    await _openPopup();
    _handleFocus(false);
  }

  void _handleOnCleared() {
    if (widget.onClear != null) {
      widget.onClear!();
    } else if (widget.onClearMultiSelection != null) {
      widget.onClearMultiSelection!();
    }
  }

  ///Change selected Value; this function is public USED to change the selected
  ///value PROGRAMMATICALLY, Otherwise you can use [_handleOnChangeSelectedItems]
  ///for multiSelection mode you can use [changeSelectedItems]
  void changeSelectedItem(T? selectedItem) => _handleOnChangeSelectedItems(
      BaseDropdownSearch._itemToList(selectedItem));

  ///Change selected Value; this function is public USED to change the selected
  ///value PROGRAMMATICALLY, Otherwise you can use [_handleOnChangeSelectedItems]
  ///for SingleSelection mode you can use [changeSelectedItem]
  void changeSelectedItems(List<T> selectedItems) =>
      _handleOnChangeSelectedItems(selectedItems);

  ///function to remove an item from the list
  ///Useful in multiSelection mode to delete an item
  void removeItem(T itemToRemove) => _handleOnChangeSelectedItems(
      getSelectedItems..removeWhere((i) => _isEqual(itemToRemove, i)));

  ///Change selected Value; this function is public USED to clear selected
  ///value PROGRAMMATICALLY, Otherwise you can use [_handleOnChangeSelectedItems]
  void clear() {
    void applyClear() {
      _handleOnChangeSelectedItems([]);
      _handleOnCleared();
    }

    if (widget.onBeforeClear != null) {
      Future.value(
        widget.onBeforeClear!(getSelectedItem),
      ).then((allowed) => allowed ? applyClear() : null);
    } else if (widget.onBeforeClearMultiSelection != null) {
      Future.value(
        widget.onBeforeClearMultiSelection!(getSelectedItems),
      ).then((allowed) => allowed ? applyClear() : null);
    } else {
      applyClear();
    }
  }

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
  DropdownSearchPopupState<T>? get getPopupState => _popupStateKey.currentState;

  ///close dropdownSearch popup if it's open
  void closeDropDownSearch() {
    if (widget.popupProps.mode == PopupMode.autocomplete) {
      _customOverlyEntry?.close();
      _customOverlyEntry = null;
    } else {
      if (_popupStateKey.currentState?.mounted == true && context.mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  void toggleDropDownSearch() {
    isFocused ? closeDropDownSearch() : openDropDownSearch();
  }

  ///returns true if all popup's items are selected; other wise False
  bool get popupIsAllItemSelected =>
      _popupStateKey.currentState?.isAllItemSelected ?? false;

  ///returns popup selected items
  List<T> get popupGetSelectedItems =>
      _popupStateKey.currentState?.getSelectedItem ?? [];

  ///returns popup showed/loaded items
  List<T> get popupGetItems =>
      _popupStateKey.currentState?.getLoadedItems ?? [];

  void updatePopupState() => _popupStateKey.currentState?.setState(() {});
}
