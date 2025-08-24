import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import '../main.dart';
import '../user_model.dart';
import 'dialogs.dart';

class CupertinoModalsExamplesPage extends StatefulWidget {
  @override
  State<CupertinoModalsExamplesPage> createState() =>
      _CupertinoModalsExamplesPageState();
}

class _CupertinoModalsExamplesPageState
    extends State<CupertinoModalsExamplesPage> {
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
      resizeToAvoidBottomInset: false,
      appBar:
          AppBar(title: Text("CupertinoDropdownSearch Modal BottomSheet Demo")),
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
                    child: CupertinoDropdownSearch<int>(
                      items: (f, cs) => List.generate(30, (i) => i + 1),
                      decoratorProps: DropDownDecoratorProps(
                        decoration: InputDecoration(
                            labelText: "Dialog with title",
                            hintText: "Select an Int"),
                      ),
                      popupProps: CupertinoPopupProps.modalBottomSheet(
                        title: Container(
                          decoration: BoxDecoration(
                            color: Colors.deepPurple,
                          ),
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
                        modalBottomSheetProps: CupertinoModalBottomSheetProps(),
                      ),
                    ),
                  ),
                  Padding(padding: EdgeInsets.all(4)),
                  Expanded(
                    child: CupertinoDropdownSearch<int>(
                      items: (f, cs) => [1, 2, 3, 4, 5, 6, 7],
                      decoratorProps: DropDownDecoratorProps(
                        decoration: InputDecoration(
                          labelText: "Modal mode",
                          hintText: "Select an Int",
                          filled: true,
                        ),
                      ),
                      popupProps: CupertinoPopupProps.modalBottomSheet(
                        disabledItemFn: (int i) => i <= 3,
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
                    child: CupertinoDropdownSearch<UserModel>(
                      items: (filter, t) => getData(filter),
                      compareFn: (i, s) => i.isEqual(s),
                      popupProps: CupertinoPopupProps.modalBottomSheet(
                        showSelectedItems: true,
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
                  Padding(padding: EdgeInsets.all(4)),
                  Expanded(
                    child: CupertinoDropdownSearch<UserModel>.multiSelection(
                      items: (filter, s) => getData(filter),
                      compareFn: (i, s) => i.isEqual(s),
                      popupProps:
                          CupertinoMultiSelectionPopupProps.modalBottomSheet(
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
                ],
              ),

              ///**************************************[custom popup background examples]********************************///
              Padding(padding: EdgeInsets.all(16)),
              Text("[custom popup background examples]"),
              Divider(),
              CupertinoDropdownSearch<String>.multiSelection(
                key: _dropDownCustomBGKey,
                items: (f, cs) => List.generate(30, (index) => "$index"),
                popupProps: CupertinoMultiSelectionPopupProps.modalBottomSheet(
                  modalBottomSheetProps: CupertinoModalBottomSheetProps(),
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
                              child: FilledButton(
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

              ///**********************************************[dropdownBuilder examples]********************************///
              Padding(padding: EdgeInsets.all(16)),
              Text("[DropDownSearch builder examples]"),
              Divider(),
              Row(
                children: [
                  Expanded(
                    child: CupertinoDropdownSearch<UserModel>.multiSelection(
                      items: (filter, t) => getData(filter),
                      suffixProps: DropdownSuffixProps(
                          clearButtonProps: ClearButtonProps(isVisible: true)),
                      popupProps:
                          CupertinoMultiSelectionPopupProps.modalBottomSheet(
                        showSelectedItems: true,
                        itemBuilder: userModelPopupItem,
                        showSearchBox: true,
                        searchFieldProps: CupertinoTextFieldProps(
                          controller: _userEditTextController,
                          suffix: IconButton(
                            icon: Icon(Icons.clear),
                            onPressed: () => _userEditTextController.clear(),
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
                    child: CupertinoDropdownSearch<UserModel>(
                      items: (filter, t) => getData(filter),
                      popupProps: CupertinoPopupProps.modalBottomSheet(
                        showSelectedItems: true,
                        itemBuilder: userModelPopupItem,
                        showSearchBox: true,
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
              CupertinoDropdownSearch<MultiLevelString>(
                key: _dropdownMultiLevelKey,
                items: (f, cs) => myMultiLevelItems,
                compareFn: (i1, i2) => i1.level1 == i2.level1,
                popupProps: CupertinoPopupProps.modalBottomSheet(
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
            ],
          ),
        ),
      ),
    );
  }
}
