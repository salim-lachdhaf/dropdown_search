import 'dart:math';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:example/main.dart';
import 'package:example/user_model.dart';
import 'package:flutter/material.dart';

class AdaptiveDialogExamplesPage extends StatefulWidget {
  @override
  State<AdaptiveDialogExamplesPage> createState() =>
      _AdaptiveDialogExamplesPageState();
}

class _AdaptiveDialogExamplesPageState
    extends State<AdaptiveDialogExamplesPage> {
  final _formKey = GlobalKey<FormState>();
  final _dropDownCustomBGKey = GlobalKey<DropdownSearchState<String>>();
  final _userEditTextController = TextEditingController(text: 'Mrs');
  final _dropdownMultiLevelKey =
      GlobalKey<DropdownSearchState<MultiLevelString>>();
  final List<MultiLevelString> myMultiLevelItems = [
    MultiLevelString(level1: "1"),
    MultiLevelString(level1: "2"),
    MultiLevelString(
      level1: "3",
      subLevel: [
        MultiLevelString(level1: "sub3-1"),
        MultiLevelString(level1: "sub3-2"),
        MultiLevelString(level1: "sub3-3"),
        MultiLevelString(level1: "sub3-4"),
      ],
    ),
    MultiLevelString(level1: "4"),
    MultiLevelString(level1: "5"),
    MultiLevelString(level1: "6"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("AdaptiveDropdownSearch Dialog Demo")),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: ListView(
            padding: EdgeInsets.all(4),
            children: <Widget>[
              Text("[simple examples]"),
              Divider(),
              Padding(padding: EdgeInsets.all(4)),
              Row(
                children: [
                  Expanded(
                    child: AdaptiveDropdownSearch<int>(
                      context: context,
                      items: (f, cs) => List.generate(30, (i) => i + 1),
                      decoratorProps: DropDownDecoratorProps(
                        decoration: InputDecoration(
                            labelText: "Dialog with title",
                            hintText: "Select an Int"),
                      ),
                      popupProps: AdaptivePopupProps(
                          materialProps: PopupProps.dialog(
                        title: Container(
                          decoration: BoxDecoration(color: Colors.deepPurple),
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Text(
                            'Numbers 1..30',
                            style: TextStyle(
                                fontSize: 21,
                                fontWeight: FontWeight.bold,
                                color: Colors.white70),
                          ),
                        ),
                        dialogProps: DialogProps(
                          clipBehavior: Clip.antiAlias,
                          shape: OutlineInputBorder(
                            borderSide: BorderSide(width: 0),
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                      )),
                    ),
                  ),
                  Padding(padding: EdgeInsets.all(4)),
                  Expanded(
                    child: AdaptiveDropdownSearch<int>(
                      context: context,
                      items: (f, cs) => [1, 2, 3, 4, 5, 6, 7],
                      decoratorProps: DropDownDecoratorProps(
                        decoration: InputDecoration(
                          labelText: "Modal mode",
                          hintText: "Select an Int",
                          filled: true,
                        ),
                      ),
                      popupProps: AdaptivePopupProps(
                        materialProps: PopupProps.dialog(
                          disabledItemFn: (int i) => i <= 3,
                        ),
                      ),
                    ),
                  )
                ],
              ),

              ///********************************************[suggested items examples]**********************************///
              Padding(padding: EdgeInsets.all(16)),
              Text("[Suggested examples]"),
              Divider(),
              Row(
                children: [
                  Expanded(
                    child: AdaptiveDropdownSearch<UserModel>(
                      context: context,
                      items: (filter, t) => getData(filter),
                      compareFn: (i, s) => i.isEqual(s),
                      popupProps: AdaptivePopupProps(
                          materialProps: PopupProps.dialog(
                        disabledItemFn: (item) => item.name.contains('Am'),
                        showSelectedItems: true,
                        showSearchBox: true,
                        itemBuilder: userModelPopupItem,
                        suggestionsProps: SuggestionsProps(
                          showSuggestions: true,
                          items: (us) {
                            return us
                                .where((e) => e.name.contains("e"))
                                .toList();
                          },
                        ),
                      )),
                    ),
                  ),
                  Padding(padding: EdgeInsets.all(4)),
                  Expanded(
                    child: Theme(
                      data: ThemeData(primaryColorLight: Colors.red),
                      child: AdaptiveDropdownSearch<UserModel>.multiSelection(
                        context: context,
                        items: (filter, s) => getData(filter),
                        compareFn: (i, s) => i.isEqual(s),
                        popupProps: AdaptiveMultiSelectionPopupProps(
                          materialProps: MultiSelectionPopupProps.dialog(
                            showSearchBox: true,
                            itemBuilder: userModelPopupItem,
                            suggestionsProps: SuggestionsProps(
                              showSuggestions: true,
                              items: (us) {
                                return us
                                    .where((e) => e.name.contains("Mrs"))
                                    .toList();
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              ///**************************************[custom popup background examples]********************************///
              Padding(padding: EdgeInsets.all(16)),
              Text("[custom popup background examples]"),
              Divider(),
              Padding(padding: EdgeInsets.all(8)),
              Row(
                children: [
                  Expanded(
                    child: DropdownWithGlobalCheckBox(),
                  ),
                  Padding(padding: EdgeInsets.all(4)),
                  Expanded(
                    child: AdaptiveDropdownSearch<String>.multiSelection(
                      context: context,
                      key: _dropDownCustomBGKey,
                      items: (f, cs) => List.generate(30, (index) => "$index"),
                      popupProps: AdaptiveMultiSelectionPopupProps(
                        materialProps: MultiSelectionPopupProps.dialog(
                          showSearchBox: true,
                          containerBuilder: (ctx, popupWidget) {
                            return Column(
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(8),
                                      child: OutlinedButton(
                                        onPressed: () {
                                          // How should I unselect all items in the list?
                                          _dropDownCustomBGKey.currentState
                                              ?.closeDropDownSearch();
                                        },
                                        child: const Text('Cancel'),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(8),
                                      child: OutlinedButton(
                                        onPressed: () {
                                          // How should I select all items in the list?
                                          _dropDownCustomBGKey.currentState
                                              ?.popupSelectAllItems();
                                        },
                                        child: const Text('All'),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(8),
                                      child: OutlinedButton(
                                        onPressed: () {
                                          // How should I unselect all items in the list?
                                          _dropDownCustomBGKey.currentState
                                              ?.popupDeselectAllItems();
                                        },
                                        child: const Text('None'),
                                      ),
                                    ),
                                  ],
                                ),
                                Expanded(child: popupWidget),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              ///**********************************************[dropdownBuilder examples]********************************///
              Padding(padding: EdgeInsets.all(16)),
              Text("[DropDownSearch builder examples]"),
              Divider(),
              Row(
                children: [
                  Expanded(
                    child: AdaptiveDropdownSearch<UserModel>.multiSelection(
                      context: context,
                      items: (filter, t) => getData(filter),
                      suffixProps: DropdownSuffixProps(
                          clearButtonProps: ClearButtonProps(isVisible: true)),
                      popupProps: AdaptiveMultiSelectionPopupProps(
                        materialProps: MultiSelectionPopupProps.dialog(
                          showSelectedItems: true,
                          itemBuilder: userModelPopupItem,
                          showSearchBox: true,
                          searchFieldProps: TextFieldProps(
                            controller: _userEditTextController,
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                icon: Icon(Icons.clear),
                                onPressed: () =>
                                    _userEditTextController.clear(),
                              ),
                            ),
                          ),
                        ),
                      ),
                      compareFn: (item, selectedItem) =>
                          item.id == selectedItem.id,
                      decoratorProps: DropDownDecoratorProps(
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelText: 'Users *',
                          filled: true,
                          fillColor:
                              Theme.of(context).inputDecorationTheme.fillColor,
                        ),
                      ),
                      dropdownBuilder: customDropDownExampleMultiSelection,
                    ),
                  ),
                  Padding(padding: EdgeInsets.all(4)),
                  Expanded(
                    child: AdaptiveDropdownSearch<UserModel>(
                      context: context,
                      items: (filter, t) => getData(filter),
                      popupProps: AdaptivePopupProps(
                        materialProps: PopupProps.dialog(
                          showSelectedItems: true,
                          itemBuilder: userModelPopupItem,
                          showSearchBox: true,
                        ),
                      ),
                      compareFn: (item, sItem) => item.id == sItem.id,
                      decoratorProps: DropDownDecoratorProps(
                        decoration: InputDecoration(
                          labelText: 'User *',
                          filled: true,
                          fillColor:
                              Theme.of(context).inputDecorationTheme.fillColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              ///**********************************************[multiLevel items example]********************************///
              Padding(padding: EdgeInsets.all(16)),
              Text("[multiLevel items example]"),
              Divider(),
              AdaptiveDropdownSearch<MultiLevelString>(
                context: context,
                key: _dropdownMultiLevelKey,
                items: (f, cs) => myMultiLevelItems,
                compareFn: (i1, i2) => i1.level1 == i2.level1,
                popupProps: AdaptivePopupProps(
                  materialProps: PopupProps.dialog(
                    showSelectedItems: true,
                    interceptCallBacks: true, //important line
                    itemBuilder: (ctx, item, isDisabled, isSelected, _) {
                      return ListTile(
                        selected: isSelected,
                        title: Text(item.level1),
                        trailing: item.subLevel.isEmpty
                            ? null
                            : (item.isExpanded
                                ? IconButton(
                                    icon: Icon(Icons.arrow_drop_down),
                                    onPressed: () {
                                      item.isExpanded = !item.isExpanded;
                                      _dropdownMultiLevelKey.currentState
                                          ?.updatePopupState();
                                    },
                                  )
                                : IconButton(
                                    icon: Icon(Icons.arrow_right),
                                    onPressed: () {
                                      item.isExpanded = !item.isExpanded;
                                      _dropdownMultiLevelKey.currentState
                                          ?.updatePopupState();
                                    },
                                  )),
                        subtitle: item.subLevel.isNotEmpty && item.isExpanded
                            ? Container(
                                height: item.subLevel.length * 50,
                                child: ListView(
                                  children: item.subLevel
                                      .map(
                                        (e) => ListTile(
                                          selected: _dropdownMultiLevelKey
                                                  .currentState
                                                  ?.getSelectedItem
                                                  ?.level1 ==
                                              e.level1,
                                          title: Text(e.level1),
                                          onTap: () {
                                            _dropdownMultiLevelKey.currentState
                                                ?.popupValidate([e]);
                                          },
                                        ),
                                      )
                                      .toList(),
                                ),
                              )
                            : null,
                        onTap: () => _dropdownMultiLevelKey.currentState
                            ?.popupValidate([item]),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DropdownWithGlobalCheckBox extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DropdownWithGlobalCheckBoxState();
}

class _DropdownWithGlobalCheckBoxState
    extends State<DropdownWithGlobalCheckBox> {
  final _infiniteScrollDropDownKey = GlobalKey<DropdownSearchState<int>>();
  final ValueNotifier<bool?> longListCheckBoxValueNotifier =
      ValueNotifier(false);
  final longList = List.generate(500, (i) => i + 1);

  bool? _getCheckBoxState() {
    var selectedItem =
        _infiniteScrollDropDownKey.currentState?.popupGetSelectedItems ?? [];
    var isAllSelected =
        _infiniteScrollDropDownKey.currentState?.popupIsAllItemSelected ??
            false;
    return selectedItem.isEmpty ? false : (isAllSelected ? true : null);
  }

  ///simulate an API call
  Future<List<int>> _getData(String filter, LoadProps loadProps) async {
    await Future.delayed(Duration(seconds: 5));
    //simulate random error
    final errorIndex = Random().nextInt(100);
    if (errorIndex <= loadProps.skip) {
      throw Exception('Sorry, An error occurred !');
    }

    var list = filter.isEmpty
        ? longList
        : longList.where((l) => l.toString().contains(filter));

    return list.skip(loadProps.skip).take(loadProps.take).toList();
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveDropdownSearch<int>.multiSelection(
      context: context,
      key: _infiniteScrollDropDownKey,
      items: (f, ic) => _getData(f, ic!),
      decoratorProps: DropDownDecoratorProps(
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Infinite Scroll',
          contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
        ),
      ),
      popupProps: AdaptiveMultiSelectionPopupProps(
        materialProps: MultiSelectionPopupProps.dialog(
          onItemAdded: (l, s) =>
              longListCheckBoxValueNotifier.value = _getCheckBoxState(),
          onItemRemoved: (l, s) =>
              longListCheckBoxValueNotifier.value = _getCheckBoxState(),
          onItemsLoaded: (value) =>
              longListCheckBoxValueNotifier.value = _getCheckBoxState(),
          infiniteScrollProps: InfiniteScrollProps(
            loadProps: LoadProps(skip: 0, take: 10),
            errorBuilder: (context, searchEntry, exception, loadProps) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('$exception'),
                  TextButton.icon(
                    onPressed: () {
                      _infiniteScrollDropDownKey.currentState?.getPopupState
                          ?.loadMoreItems(searchEntry, loadProps.skip);
                    },
                    icon: Icon(Icons.sync),
                    label: Text('reload'),
                  )
                ],
              );
            },
          ),
          showSearchBox: true,
          containerBuilder: (ctx, popupWidget) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(24)),
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [Color(0xF44336), Colors.blue],
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text('Select: '),
                        ValueListenableBuilder(
                          valueListenable: longListCheckBoxValueNotifier,
                          builder: (context, value, child) {
                            return Checkbox(
                              value: longListCheckBoxValueNotifier.value,
                              tristate: true,
                              onChanged: (bool? v) {
                                v ??= false;
                                if (v == true) {
                                  _infiniteScrollDropDownKey.currentState
                                      ?.popupSelectAllItems();
                                } else if (v == false) {
                                  _infiniteScrollDropDownKey.currentState
                                      ?.popupDeselectAllItems();
                                }
                                longListCheckBoxValueNotifier.value = v;
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  Expanded(child: popupWidget),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

Widget customDropDownExampleMultiSelection(
    BuildContext context, List<UserModel> selectedItems) {
  if (selectedItems.isEmpty) {
    return ListTile(
      contentPadding: EdgeInsets.all(0),
      leading: CircleAvatar(),
      title: Text("No item selected"),
    );
  }

  return Wrap(
    children: selectedItems.map((e) {
      return Padding(
        padding: const EdgeInsets.all(4.0),
        child: Container(
          child: ListTile(
            contentPadding: EdgeInsets.all(0),
            leading: CircleAvatar(child: Text(e.name[0])),
            title: Text(e.name),
            subtitle: Text(e.createdAt.toString()),
          ),
        ),
      );
    }).toList(),
  );
}

Widget userModelPopupItem(
  BuildContext context,
  UserModel item,
  bool isDisabled,
  bool isSelected,
  _,
) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 8),
    decoration: !isSelected
        ? null
        : BoxDecoration(
            border: Border.all(color: Theme.of(context).primaryColor),
            borderRadius: BorderRadius.circular(5),
            color: Colors.white,
          ),
    child: ListTile(
      selected: isSelected,
      title: Text(item.name),
      subtitle: Text(item.createdAt.toString()),
      leading: CircleAvatar(child: Text(item.name[0])),
    ),
  );
}

class MultiLevelString {
  final String level1;
  final List<MultiLevelString> subLevel;
  bool isExpanded;

  MultiLevelString({
    this.level1 = "",
    this.subLevel = const [],
    this.isExpanded = false,
  });

  @override
  String toString() => level1;
}
