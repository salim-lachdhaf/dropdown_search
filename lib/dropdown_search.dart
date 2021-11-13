library dropdown_search;

import 'dart:async';

import 'package:dropdown_search/src/properties/selection_list_view_props.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'src/modal_dialog.dart';
import 'src/popupMenu.dart';
import 'src/properties/popup_safearea_props.dart';
import 'src/properties/scrollbar_props.dart';
import 'src/properties/text_field_props.dart';
import 'src/selection_widget.dart';

export 'src/properties/popup_safearea_props.dart';
export 'src/properties/scrollbar_props.dart';
export 'src/properties/selection_list_view_props.dart';
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
typedef Widget IconButtonBuilder(BuildContext context);
typedef Future<bool?> BeforeChange<T>(T? prevItem, T? nextItem);
typedef Future<bool?> BeforeChangeMultiSelection<T>(
    List<T> prevItems, List<T> nextItems);
typedef Widget FavoriteItemsBuilder<T>(
    BuildContext context, T item, bool isSelected);
typedef Widget ValidationMultiSelectionBuilder<T>(
    BuildContext context, List<T> item);

typedef RelativeRect PositionCallback(
    RenderBox popupButtonObject, RenderBox overlay);

typedef void OnItemAdded<T>(List<T> selectedItem, T addedItem);
typedef void OnItemRemoved<T>(List<T> selectedItem, T removedItem);

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

  ///selected items
  final List<T> selectedItems;

  ///function that returns item from API
  final DropdownSearchOnFind<T>? onFind;

  ///called when a new item is selected
  final ValueChanged<T?>? onChanged;

  ///called when a new items are selected
  final ValueChanged<List<T>>? onChangedMultiSelection;

  ///to customize list of items UI
  final DropdownSearchBuilder<T>? dropdownBuilder;

  ///to customize list of items UI in MultiSelection mode
  final DropdownSearchBuilderMultiSelection<T>? dropdownBuilderMultiSelection;

  ///to customize selected item
  final DropdownSearchPopupItemBuilder<T>? popupItemBuilder;

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
  final bool showSelectedItems;

  ///function that compares two object with the same type to detected if it's the selected item or not
  final DropdownSearchCompareFn<T>? compareFn;

  ///dropdownSearch input decoration
  final InputDecoration? dropdownSearchDecoration;

  /// style on which to base the label
  final TextStyle? dropdownSearchBaseStyle;

  /// How the text in the decoration should be aligned horizontally.
  final TextAlign? dropdownSearchTextAlign;

  /// How the text should be aligned vertically.
  final TextAlignVertical? dropdownSearchTextAlignVertical;

  ///custom layout for empty results
  final EmptyBuilder? emptyBuilder;

  ///custom layout for loading items
  final LoadingBuilder? loadingBuilder;

  ///custom layout for error
  final ErrorBuilder? errorBuilder;

  ///custom shape for the popup
  final ShapeBorder? popupShape;

  final AutovalidateMode? autoValidateMode;

  /// An optional method to call with the final value when the form is saved via
  final FormFieldSetter<T>? onSaved;

  /// An optional method to call with the final value when the form is saved via
  final FormFieldSetter<List<T>>? onSavedMultiSelection;

  /// An optional method that validates an input. Returns an error string to
  /// display if the input is invalid, or null otherwise.
  final FormFieldValidator<T>? validator;
  final FormFieldValidator<List<T>>? validatorMultiSelection;

  ///custom dropdown clear button icon widget
  final Widget? clearButton;

  ///custom clear button widget builder
  final IconButtonBuilder? clearButtonBuilder;

  ///custom splash radius for the clear button
  ///If null, default splash radius of [icon_button] is used.
  final double? clearButtonSplashRadius;

  ///custom dropdown icon button widget
  final Widget? dropDownButton;

  ///custom dropdown button widget builder
  final IconButtonBuilder? dropdownButtonBuilder;

  ///custom splash radius for the dropdown button
  ///If null, default splash radius of [icon_button] is used.
  final double? dropdownButtonSplashRadius;

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

  ///called when popup is dismissed
  final VoidCallback? onPopupDismissed;

  /// callback executed before applying value change
  ///delay before searching, change it to Duration(milliseconds: 0)
  ///if you do not use online search
  final Duration? searchDelay;

  /// callback executed before applying value change
  final BeforeChange<T>? onBeforeChange;

  /// callback executed before applying values changes
  final BeforeChangeMultiSelection<T>? onBeforeChangeMultiSelection;

  ///show or hide favorites items
  final bool showFavoriteItems;

  ///to customize favorites chips
  final FavoriteItemsBuilder<T>? favoriteItemBuilder;

  ///favorites items list
  final FavoriteItems<T>? favoriteItems;

  ///favorite items alignment
  final MainAxisAlignment? favoriteItemsAlignment;

  ///set properties of popup safe area
  final PopupSafeAreaProps popupSafeArea;

  /// object that passes all props to search field
  final TextFieldProps? searchFieldProps;

  /// scrollbar properties
  final ScrollbarProps? scrollbarProps;

  /// whether modal can be dismissed by tapping the modal barrier
  final bool popupBarrierDismissible;

  ///define whatever we are in multi selection mode or single selection mode
  final bool isMultiSelectionMode;

  ///called when a new item added on Multi selection mode
  final OnItemAdded<T>? popupOnItemAdded;

  ///called when a new item added on Multi selection mode
  final OnItemRemoved<T>? popupOnItemRemoved;

  ///widget used to show checked items in multiSelection mode
  final DropdownSearchPopupItemBuilder<T>? popupSelectionWidget;

  ///widget used to validate items in multiSelection mode
  final ValidationMultiSelectionBuilder<T?>?
      popupValidationMultiSelectionWidget;

  /// elevation for popup items
  final double popupElevation;

  /// props for selection list view
  final SelectionListViewProps selectionListViewProps;

  /// props for selection focus node
  final FocusNode? focusNode;

  /// function to override position calculation
  final PositionCallback? positionCallback;

  DropdownSearch({
    Key? key,
    this.onSaved,
    this.validator,
    this.autoValidateMode = AutovalidateMode.disabled,
    this.onChanged,
    this.mode = Mode.DIALOG,
    @Deprecated('Use labelText prop from dropdownSearchDecoration') this.label,
    @Deprecated('Use hintText prop from dropdownSearchDecoration') this.hint,
    this.isFilteredOnline = false,
    this.popupTitle,
    this.items,
    this.selectedItem,
    this.onFind,
    this.dropdownBuilder,
    this.popupItemBuilder,
    this.showSearchBox = false,
    this.showClearButton = false,
    this.popupBackgroundColor,
    this.enabled = true,
    this.maxHeight,
    this.filterFn,
    this.itemAsString,
    this.showSelectedItems = false,
    this.compareFn,
    this.dropdownSearchDecoration,
    this.emptyBuilder,
    this.loadingBuilder,
    this.errorBuilder,
    this.dialogMaxWidth,
    this.clearButton,
    this.clearButtonBuilder,
    this.clearButtonSplashRadius,
    this.dropDownButton,
    this.dropdownButtonBuilder,
    this.dropdownButtonSplashRadius,
    this.showAsSuffixIcons = false,
    this.dropdownBuilderSupportsNullItem = false,
    this.popupShape,
    this.popupItemDisabled,
    this.popupBarrierColor,
    this.onPopupDismissed,
    this.searchDelay,
    this.onBeforeChange,
    this.favoriteItemBuilder,
    this.favoriteItems,
    this.showFavoriteItems = false,
    this.favoriteItemsAlignment = MainAxisAlignment.start,
    this.popupSafeArea = const PopupSafeAreaProps(),
    TextFieldProps? searchFieldProps,
    this.scrollbarProps,
    this.popupBarrierDismissible = true,
    this.dropdownSearchBaseStyle,
    this.dropdownSearchTextAlign,
    this.dropdownSearchTextAlignVertical,
    this.popupElevation = 8,
    this.selectionListViewProps = const SelectionListViewProps(),
    this.focusNode,
    this.positionCallback,
  })  : assert(!showSelectedItems || T == String || compareFn != null),
        this.searchFieldProps = searchFieldProps ?? TextFieldProps(),
        this.isMultiSelectionMode = false,
        this.dropdownBuilderMultiSelection = null,
        this.validatorMultiSelection = null,
        this.onBeforeChangeMultiSelection = null,
        this.selectedItems = const [],
        this.onSavedMultiSelection = null,
        this.onChangedMultiSelection = null,
        this.popupOnItemAdded = null,
        this.popupOnItemRemoved = null,
        this.popupSelectionWidget = null,
        this.popupValidationMultiSelectionWidget = null,
        super(key: key);

  DropdownSearch.multiSelection({
    Key? key,
    this.autoValidateMode = AutovalidateMode.disabled,
    this.mode = Mode.DIALOG,
    @Deprecated('Use labelText prop from dropdownSearchDecoration') this.label,
    @Deprecated('Use hintText prop from dropdownSearchDecoration') this.hint,
    this.isFilteredOnline = false,
    this.popupTitle,
    this.items,
    this.onFind,
    this.popupItemBuilder,
    this.showSearchBox = false,
    this.showClearButton = false,
    this.popupBackgroundColor,
    this.enabled = true,
    this.maxHeight,
    this.filterFn,
    this.itemAsString,
    this.showSelectedItems = false,
    this.compareFn,
    this.dropdownSearchDecoration,
    this.emptyBuilder,
    this.loadingBuilder,
    this.errorBuilder,
    this.dialogMaxWidth,
    this.clearButton,
    this.clearButtonBuilder,
    this.clearButtonSplashRadius,
    this.dropDownButton,
    this.dropdownButtonBuilder,
    this.dropdownButtonSplashRadius,
    this.showAsSuffixIcons = false,
    this.dropdownBuilderSupportsNullItem = false,
    this.popupShape,
    this.popupItemDisabled,
    this.popupBarrierColor,
    this.onPopupDismissed,
    this.searchDelay,
    this.favoriteItemBuilder,
    this.favoriteItems,
    this.showFavoriteItems = false,
    this.favoriteItemsAlignment = MainAxisAlignment.start,
    this.popupSafeArea = const PopupSafeAreaProps(),
    TextFieldProps? searchFieldProps,
    this.scrollbarProps,
    this.popupBarrierDismissible = true,
    this.dropdownSearchBaseStyle,
    this.dropdownSearchTextAlign,
    this.dropdownSearchTextAlignVertical,
    this.selectedItems = const [],
    FormFieldSetter<List<T>>? onSaved,
    ValueChanged<List<T>>? onChanged,
    BeforeChangeMultiSelection<T>? onBeforeChange,
    FormFieldValidator<List<T>>? validator,
    DropdownSearchBuilderMultiSelection<T>? dropdownBuilder,
    this.popupOnItemAdded,
    this.popupOnItemRemoved,
    this.popupSelectionWidget,
    this.popupValidationMultiSelectionWidget,
    this.popupElevation = 8,
    this.selectionListViewProps = const SelectionListViewProps(),
    this.focusNode,
    this.positionCallback,
  })  : assert(!showSelectedItems || T == String || compareFn != null),
        this.searchFieldProps = searchFieldProps ?? TextFieldProps(),
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
        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
        margin: EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Theme.of(context).primaryColorLight),
        child: Text(
          _selectedItemAsString(item),
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.subtitle2,
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

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(child: selectedItemWidget()),
        if (!widget.showAsSuffixIcons) _manageTrailingIcons(),
      ],
    );
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
          WidgetsBinding.instance!.addPostFrameCallback((_) {
            state.didChange(getSelectedItem);
          });
        }
        return ValueListenableBuilder<bool>(
            valueListenable: _isFocused,
            builder: (context, isFocused, w) {
              return InputDecorator(
                baseStyle: widget.dropdownSearchBaseStyle,
                textAlign: widget.dropdownSearchTextAlign,
                textAlignVertical: widget.dropdownSearchTextAlignVertical,
                isEmpty: getSelectedItem == null &&
                    (widget.dropdownBuilder == null ||
                        widget.dropdownBuilderSupportsNullItem),
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
          WidgetsBinding.instance!.addPostFrameCallback((_) {
            state.didChange(getSelectedItems);
          });
        }
        return ValueListenableBuilder<bool>(
            valueListenable: _isFocused,
            builder: (context, isFocused, w) {
              return InputDecorator(
                baseStyle: widget.dropdownSearchBaseStyle,
                textAlign: widget.dropdownSearchTextAlign,
                textAlignVertical: widget.dropdownSearchTextAlignVertical,
                isEmpty: getSelectedItems.isEmpty &&
                    (widget.dropdownBuilderMultiSelection == null ||
                        widget.dropdownBuilderSupportsNullItem),
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
            InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                border: OutlineInputBorder()))
        .applyDefaults(Theme.of(state.context).inputDecorationTheme)
        .copyWith(
            enabled: widget.enabled,
            labelText:
                widget.label ?? widget.dropdownSearchDecoration?.labelText,
            hintText: widget.hint ?? widget.dropdownSearchDecoration?.hintText,
            suffixIcon:
                widget.showAsSuffixIcons ? _manageTrailingIcons() : null,
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
  Widget _manageTrailingIcons() {
    final clearButtonPressed = () => clear();
    final dropdownButtonPressed = () => _selectSearchMode();

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        if (getSelectedItems.isNotEmpty && widget.showClearButton == true)
          widget.clearButtonBuilder != null
              ? InkWell(
                  onTap: clearButtonPressed,
                  child: widget.clearButtonBuilder!(context),
                )
              : IconButton(
                  icon: widget.clearButton ?? const Icon(Icons.clear, size: 24),
                  onPressed: clearButtonPressed,
                  splashRadius: widget.clearButtonSplashRadius ?? null,
                ),
        widget.dropdownButtonBuilder != null
            ? InkWell(
                onTap: dropdownButtonPressed,
                child: widget.dropdownButtonBuilder!(context),
              )
            : IconButton(
                icon: widget.dropDownButton ??
                    const Icon(Icons.arrow_drop_down, size: 24),
                onPressed: dropdownButtonPressed,
                splashRadius: widget.dropdownButtonSplashRadius ?? null,
              ),
      ],
    );
  }

  ///open dialog
  Future _openSelectDialog() {
    return showGeneralDialog(
      barrierDismissible: widget.popupBarrierDismissible,
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
            elevation: widget.popupElevation,
            contentPadding: EdgeInsets.all(0),
            shape: widget.popupShape,
            backgroundColor: widget.popupBackgroundColor,
            content: _selectDialogInstance(),
          ),
        );
      },
    );
  }

  ///open BottomSheet (Dialog mode)
  Future _openBottomSheet() {
    return showModalBottomSheetCustom<T>(
        barrierColor: widget.popupBarrierColor,
        backgroundColor: Colors.transparent,
        isDismissible: widget.popupBarrierDismissible,
        isScrollControlled: true,
        context: context,
        builder: (ctx) {
          final MediaQueryData mediaQueryData = MediaQuery.of(ctx);
          EdgeInsets padding = mediaQueryData.padding;
          if (mediaQueryData.padding.bottom == 0.0 &&
              mediaQueryData.viewInsets.bottom != 0.0)
            padding =
                padding.copyWith(bottom: mediaQueryData.viewPadding.bottom);

          return AnimatedPadding(
            duration: Duration(milliseconds: 300),
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(ctx).viewInsets.bottom,
            ),
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(
                    top: widget.popupSafeArea.top ? padding.top : 0,
                  ),
                  child: Material(
                    color: widget.popupBackgroundColor ??
                        Theme.of(ctx).canvasColor,
                    shape: widget.popupShape,
                    clipBehavior: Clip.antiAlias,
                    elevation: widget.popupElevation,
                    child: SafeArea(
                      top: false,
                      bottom: widget.popupSafeArea.bottom,
                      left: widget.popupSafeArea.left,
                      right: widget.popupSafeArea.right,
                      child: _selectDialogInstance(defaultHeight: (((widget.items??[]).length<4)?160:224)),
                    ),
                  ),
                ),
                // this part makes top padding tappable to be able to
                // close the popup
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  behavior: HitTestBehavior.translucent,
                  child: SizedBox(
                    height: widget.popupSafeArea.top ? padding.top : 0,
                    width: double.infinity,
                  ),
                )
              ],
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
    final overlay =
        Overlay.of(context)!.context.findRenderObject() as RenderBox;

    return customShowMenu<T>(
        popupSafeArea: widget.popupSafeArea,
        barrierColor: widget.popupBarrierColor,
        shape: widget.popupShape,
        color: widget.popupBackgroundColor,
        context: context,
        position:
            (widget.positionCallback ?? _position)(popupButtonObject, overlay),
        elevation: widget.popupElevation,
        barrierDismissible: widget.popupBarrierDismissible,
        items: [
          CustomPopupMenuItem(
            child: Container(
              width: popupButtonObject.size.width,
              child: _selectDialogInstance(defaultHeight: 224),
            ),
          ),
        ]);
  }

  Widget _selectDialogInstance({double? defaultHeight}) {
    return SelectionWidget<T>(
      popupTitle: widget.popupTitle,
      maxHeight: widget.maxHeight ?? defaultHeight,
      isFilteredOnline: widget.isFilteredOnline,
      itemAsString: widget.itemAsString,
      filterFn: widget.filterFn,
      items: widget.items,
      onFind: widget.onFind,
      showSearchBox: widget.showSearchBox,
      itemBuilder: widget.popupItemBuilder,
      selectedValues: getSelectedItems,
      onChanged: _handleOnChangeSelectedItems,
      showSelectedItems: widget.showSelectedItems,
      compareFn: widget.compareFn,
      emptyBuilder: widget.emptyBuilder,
      loadingBuilder: widget.loadingBuilder,
      errorBuilder: widget.errorBuilder,
      dialogMaxWidth: widget.dialogMaxWidth,
      itemDisabled: widget.popupItemDisabled,
      searchDelay: widget.searchDelay,
      showFavoriteItems: widget.showFavoriteItems,
      favoriteItems: widget.favoriteItems,
      favoriteItemBuilder: widget.favoriteItemBuilder,
      favoriteItemsAlignment: widget.favoriteItemsAlignment,
      searchFieldProps: widget.searchFieldProps,
      scrollbarProps: widget.scrollbarProps,
      onBeforeChangeMultiSelection: widget.onBeforeChangeMultiSelection,
      popupOnItemAdded: widget.popupOnItemAdded,
      popupOnItemRemoved: widget.popupOnItemRemoved,
      popupSelectionWidget: widget.popupSelectionWidget,
      popupValidationMultiSelectionWidget:
          widget.popupValidationMultiSelectionWidget,
      isMultiSelectionMode: isMultiSelectionMode,
      selectionListViewProps: widget.selectionListViewProps,
      focusNode: widget.focusNode ?? FocusNode(),
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
    if (widget.mode == Mode.MENU) {
      await _openMenu();
    } else if (widget.mode == Mode.BOTTOM_SHEET) {
      await _openBottomSheet();
    } else {
      await _openSelectDialog();
    }
    _handleFocus(false);
    widget.onPopupDismissed?.call();
  }

  ///Public Function that return then UI based on searchMode
  ///[data] selected item to be passed to the UI
  ///If we close the popup , or maybe we just selected
  ///another widget we should clear the focus
  ///THIS USED FOR OPEN DROPDOWN_SEARCH PROGRAMMATICALLY,
  ///otherwise you can you [_selectSearchMode]
  void openDropDownSearch() => _selectSearchMode();

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
}
