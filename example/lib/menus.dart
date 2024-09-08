import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

import 'user_model.dart';

class MenuExamplesPage extends StatefulWidget {
  @override
  _MenuExamplesPageState createState() => _MenuExamplesPageState();
}

class _MenuExamplesPageState extends State<MenuExamplesPage> {
  final _formKey = GlobalKey<FormState>();
  final _openDropDownProgKey = GlobalKey<DropdownSearchState<int>>();
  final _multiKey = GlobalKey<DropdownSearchState<String>>();
  final _popupCustomValidationKey = GlobalKey<DropdownSearchState<int>>();
  final myKey = GlobalKey<DropdownSearchState<MultiLevelString>>();
  final a = RotationTransition(
    turns: AlwaysStoppedAnimation(15 / 360),
    child: Image.asset(
      'networks.png',
      height: 154,
      width: 154,
    ),
  );
  final List<MultiLevelString> myItems = [
    MultiLevelString(level1: "1"),
    MultiLevelString(level1: "2"),
    MultiLevelString(
      level1: "3",
      subLevel: [
        MultiLevelString(level1: "sub3-1"),
        MultiLevelString(level1: "sub3-2"),
      ],
    ),
    MultiLevelString(level1: "4")
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("DropdownSearch Demo")),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: ListView(
            padding: EdgeInsets.all(4),
            children: <Widget>[
              ///************************[simple examples for single and multi selection]************///
              Text("[simple examples for custom mode]"),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DropdownSearch<String>.multiSelection(
                    mode: Mode.CUSTOM,
                    items: (f, cs) => ["Monday", 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'],
                    dropdownBuilder: (ctx, selectedItem) => Icon(Icons.calendar_month_outlined, size: 54),
                  ),
                  DropdownSearch<(String, Color)>(
                    clickProps: ClickProps(borderRadius: BorderRadius.circular(20)),
                    mode: Mode.CUSTOM,
                    items: (f, cs) => [
                      ("Red", Colors.red),
                      ("Black", Colors.black),
                      ("Yellow", Colors.yellow),
                      ('Blue', Colors.blue),
                    ],
                    compareFn: (item1, item2) => item1.$1 == item2.$2,
                    popupProps: PopupProps.menu(
                      menuProps: MenuProps(align: MenuAlign.bottomCenter),
                      fit: FlexFit.loose,
                      itemBuilder: (context, item, isSelected) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(item.$1, style: TextStyle(color: item.$2, fontSize: 16)),
                      ),
                    ),
                    dropdownBuilder: (ctx, selectedItem) => Icon(Icons.face, color: selectedItem?.$2, size: 54),
                  ),
                  DropdownSearch<String>(
                    mode: Mode.CUSTOM,
                    items: (f, cs) => ['Facebook', 'Twitter', 'Instagram', 'SnapChat', 'Other'],
                    dropdownBuilder: (context, selectedItem) {
                      int r = 0;
                      switch (selectedItem) {
                        case 'Facebook':
                          r = 5;
                          break;
                        case 'Twitter':
                          r = -55;
                          break;
                        case 'Instagram':
                          r = 185;
                          break;
                        case 'SnapChat':
                          r = 245;
                          break;
                      }
                      return RotationTransition(
                        turns: AlwaysStoppedAnimation(r / 360),
                        child: Image.asset('assets/images/networks.png', height: 164, width: 164),
                      );
                    },
                    clickProps: ClickProps(borderRadius: BorderRadius.all(Radius.circular(50))),
                    popupProps: PopupProps.menu(
                      fit: FlexFit.loose,
                      menuProps: MenuProps(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                            topLeft: Radius.zero,
                            topRight: Radius.zero,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              Padding(padding: EdgeInsets.all(8)),
              Text("[simple examples for single and multi Selection]"),
              Divider(),
              Row(
                children: [
                  Expanded(
                    child: DropdownSearch<int>(
                      items: (f, cs) => [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15],
                    ),
                  ),
                  Padding(padding: EdgeInsets.all(4)),
                  Expanded(
                    child: DropdownSearch<int>.multiSelection(
                      items: (f, cs) => [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15],
                      popupProps: PopupPropsMultiSelection.menu(showSelectedItems: true),
                    ),
                  ),
                ],
              ),

              Padding(padding: EdgeInsets.all(8)),
              Text("[example for async items]"),
              Row(
                children: [
                  Expanded(
                    child: DropdownSearch<UserModel>(
                      items: (f, cs) => getData(f),
                      clearButtonProps: ClearButtonProps(isVisible: true),
                      compareFn: (item, selectedItem) => item.id == selectedItem.id,
                      dropdownBuilder: (context, selectedItem) {
                        if (selectedItem == null) {
                          return SizedBox.shrink();
                        }

                        return ListTile(
                          contentPadding: EdgeInsets.only(left: 0),
                          leading: CircleAvatar(backgroundColor: Colors.blue, child: Text(selectedItem.name[0])),
                          title: Text(selectedItem.name),
                        );
                      },
                      popupProps: PopupProps.menu(
                        disableFilter: true, //data will be filtered by the backend
                        showSearchBox: true,
                        showSelectedItems: true,
                        itemBuilder: (ctx, item, isSelected) {
                          return ListTile(
                            leading: CircleAvatar(backgroundColor: Colors.blue, child: Text(item.name[0])),
                            selected: isSelected,
                            title: Text(item.name),
                          );
                        },
                      ),
                    ),
                  ),
                  Padding(padding: EdgeInsets.all(4)),
                ],
              ),
              Padding(padding: EdgeInsets.all(8)),

              Container(
                height: 500,
                padding: EdgeInsets.symmetric(vertical: 18, horizontal: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    begin: Alignment.center,
                    colors: [Color(0xffd1c6e5), Color(0xff8785ce)],
                  ),
                ),
                child: Column(
                  children: [
                    Text("Example for customized menu"),
                    Padding(padding: EdgeInsets.all(8)),
                    DropdownSearch<(IconData, String)>(
                      selectedItem: (Icons.person, 'Your Profile'),
                      compareFn: (item1, item2) => item1.$1 == item2.$2,
                      items: (f, cs) => [
                        (Icons.person, 'Your Profile'),
                        (Icons.settings, 'Setting'),
                        (Icons.lock_open_rounded, 'Change Password'),
                        (Icons.power_settings_new_rounded, 'Logout'),
                      ],
                      dropdownDecoratorProps: DropDownDecoratorProps(
                        dropdownSearchDecoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 6),
                          filled: true,
                          fillColor: Color(0xFF1eb98f),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      dropdownBuilder: (context, selectedItem) {
                        return ListTile(
                          leading: Icon(selectedItem!.$1, color: Colors.white),
                          title: Text(
                            selectedItem.$2,
                            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        );
                      },
                      popupProps: PopupProps.menu(
                        itemBuilder: (context, item, isSelected) {
                          return ListTile(
                            contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                            leading: Icon(item.$1, color: Colors.white),
                            title: Text(
                              item.$2,
                              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          );
                        },
                        fit: FlexFit.loose,
                        menuProps: MenuProps(
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                          margin: EdgeInsets.only(top: 16),
                        ),
                        containerBuilder: (ctx, popupWidget) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 12),
                                child: Image.asset(
                                  'assets/images/arrow-up.png',
                                  color: Color(0xFF1eb98f),
                                  height: 14,
                                ),
                              ),
                              Flexible(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Color(0xFF1eb98f),
                                    shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: popupWidget,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(top: 32)),
                    DropdownSearch<String>(
                      items: (filter, infiniteScrollProps) => ['Item 1', 'Item 2', 'Item 3'],
                      dropdownButtonProps: DropdownButtonProps(
                        iconClosed: Icon(Icons.keyboard_arrow_down),
                        iconOpened: Icon(Icons.keyboard_arrow_up),
                      ),
                      dropdownDecoratorProps: DropDownDecoratorProps(
                        textAlign: TextAlign.center,
                        dropdownSearchDecoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 20),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          hintText: 'Please select...',
                          hintStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.grey),
                        ),
                      ),
                      popupProps: PopupProps.menu(
                        itemBuilder: (context, item, isSelected) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            child: Text(
                              item,
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                              textAlign: TextAlign.center,
                            ),
                          );
                        },
                        fit: FlexFit.loose,
                        menuProps: MenuProps(
                          margin: EdgeInsets.only(top: 12),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                        ),
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(top: 32)),
                    DropdownSearch<String>(
                      items: (filter, loadProps) => ["Item 1", "Item 2", "Item 3", "Item 4"],
                      dropdownDecoratorProps: DropDownDecoratorProps(
                        dropdownSearchDecoration:
                            InputDecoration(labelText: 'Bottom Left Menu', border: OutlineInputBorder()),
                      ),
                      popupProps: PopupProps.menu(
                        constraints: BoxConstraints.tight(Size(250, 250)),
                        menuProps: MenuProps(align: MenuAlign.bottomStart),
                      ),
                    ),
                    Padding(padding: EdgeInsets.symmetric(vertical: 8)),
                    DropdownSearch<String>(
                      dropdownDecoratorProps: DropDownDecoratorProps(
                        dropdownSearchDecoration:
                            InputDecoration(labelText: 'Bottom Center Menu', border: OutlineInputBorder()),
                      ),
                      items: (filter, loadProps) => ["Item 1", "Item 2", "Item 3", "Item 4"],
                      popupProps: PopupProps.menu(
                        constraints: BoxConstraints.tight(Size(250, 250)),
                        menuProps: MenuProps(align: MenuAlign.bottomCenter),
                      ),
                    ),
                    Padding(padding: EdgeInsets.symmetric(vertical: 8)),
                    DropdownSearch<String>(
                      dropdownDecoratorProps: DropDownDecoratorProps(
                        dropdownSearchDecoration: InputDecoration(labelText: 'Top Right Menu', border: OutlineInputBorder()),
                      ),
                      items: (filter, loadProps) => ["Item 1", "Item 2", "Item 3", "Item 4"],
                      popupProps: PopupProps.menu(
                        constraints: BoxConstraints.tight(Size(250, 250)),
                        menuProps: MenuProps(align: MenuAlign.topEnd),
                      ),
                    ),
                  ],
                ),
              ),

              ///************************[validation examples]********************************///
              Padding(padding: EdgeInsets.all(8)),
              Text("[validation examples]"),
              Divider(),
              Row(
                children: [
                  Expanded(
                    child: DropdownSearch<int>(
                      items: (f, cs) => [1, 2, 3, 4, 5, 6, 7],
                      autoValidateMode: AutovalidateMode.onUserInteraction,
                      validator: (int? i) {
                        if (i == null)
                          return 'required filed';
                        else if (i >= 5) return 'value should be < 5';
                        return null;
                      },
                      clearButtonProps: ClearButtonProps(isVisible: true),
                    ),
                  ),
                  Padding(padding: EdgeInsets.all(4)),
                  Expanded(
                    child: DropdownSearch<int>.multiSelection(
                      items: (f, cs) => [1, 2, 3, 4, 5, 6, 7],
                      validator: (List<int>? items) {
                        if (items == null || items.isEmpty)
                          return 'required filed';
                        else if (items.length > 3) return 'only 1 to 3 items are allowed';
                        return null;
                      },
                    ),
                  )
                ],
              ),

              ///************************[custom popup background examples]********************************///
              Padding(padding: EdgeInsets.all(8)),
              Text("[custom popup background examples]"),
              Divider(),
              DropdownSearch<String>(
                items: (f, cs) => List.generate(5, (index) => "$index"),
                popupProps: PopupProps.menu(
                  fit: FlexFit.loose,
                  menuProps: MenuProps(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                  ),
                  containerBuilder: (ctx, popupWidget) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: Image.asset(
                            'assets/images/arrow-up.png',
                            color: Color(0xFF2F772A),
                            height: 12,
                          ),
                        ),
                        Flexible(
                          child: Container(
                            child: popupWidget,
                            color: Color(0xFF2F772A),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              Padding(padding: EdgeInsets.all(8)),
              Row(
                children: [
                  Expanded(
                    child: _dropdownWithGlobalCheckBox(),
                  ),
                  Padding(padding: EdgeInsets.all(4)),
                  Expanded(
                    child: DropdownSearch<String>.multiSelection(
                      key: _multiKey,
                      items: (f, cs) => List.generate(30, (index) => "$index"),
                      popupProps: PopupPropsMultiSelection.dialog(
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
                                        _multiKey.currentState?.closeDropDownSearch();
                                      },
                                      child: const Text('Cancel'),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8),
                                    child: OutlinedButton(
                                      onPressed: () {
                                        // How should I select all items in the list?
                                        _multiKey.currentState?.popupSelectAllItems();
                                      },
                                      child: const Text('All'),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8),
                                    child: OutlinedButton(
                                      onPressed: () {
                                        // How should I unselect all items in the list?
                                        _multiKey.currentState?.popupDeselectAllItems();
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
                ],
              ),

              ///************************[dropdownBuilder examples]********************************///
              Padding(padding: EdgeInsets.all(8)),
              Text("[DropDownSearch builder examples]"),
              Divider(),

              ///************************[Dynamic height depending on items number]********************************///
              Padding(padding: EdgeInsets.all(8)),
              Text("[popup dynamic height examples]"),
              Divider(),
              Row(
                children: [
                  Expanded(
                    child: DropdownSearch<int>(
                      items: (f, cs) => List.generate(50, (i) => i),
                      popupProps: PopupProps.menu(
                        showSearchBox: true,
                        title: Text('default fit'),
                      ),
                    ),
                  ),
                  Padding(padding: EdgeInsets.all(4)),
                  Expanded(
                    child: DropdownSearch<int>(
                      items: (f, cs) => List.generate(50, (i) => i),
                      popupProps: PopupProps.menu(
                        title: Text('With fit to loose and no constraints'),
                        showSearchBox: true,
                        fit: FlexFit.loose,
                        //comment this if you want that the items do not takes all available height
                        constraints: BoxConstraints.tightFor(),
                      ),
                    ),
                  )
                ],
              ),
              Padding(padding: EdgeInsets.all(4)),
              Row(
                children: [
                  Expanded(
                    child: DropdownSearch<int>(
                      items: (f, cs) => List.generate(50, (i) => i),
                      popupProps: PopupProps.menu(
                        showSearchBox: true,
                        title: Text('fit to a specific max height'),
                        constraints: BoxConstraints.tight(Size(200, 200)),
                      ),
                    ),
                  ),
                  Padding(padding: EdgeInsets.all(4)),
                  Expanded(
                    child: DropdownSearch<int>(
                      items: (f, cs) => List.generate(50, (i) => i),
                      popupProps: PopupProps.menu(
                        title: Text('fit to a specific width and height'),
                        showSearchBox: true,
                        constraints: BoxConstraints.tightFor(
                          width: 300,
                          height: 300,
                        ),
                      ),
                    ),
                  )
                ],
              ),

              ///************************[Handle dropdown programmatically]********************************///
              Padding(padding: EdgeInsets.all(8)),
              Text("[handle dropdown programmatically]"),
              Divider(),
              DropdownSearch<int>(
                key: _openDropDownProgKey,
                items: (f, cs) => [1, 2, 3],
              ),
              Padding(padding: EdgeInsets.all(4)),
              ElevatedButton(
                onPressed: () {
                  _openDropDownProgKey.currentState?.changeSelectedItem(100);
                },
                child: Text('set to 100'),
              ),
              Padding(padding: EdgeInsets.all(4)),
              ElevatedButton(
                onPressed: () {
                  _openDropDownProgKey.currentState?.openDropDownSearch();
                },
                child: Text('open popup'),
              ),

              ///************************[multiLevel items example]********************************///
              Padding(padding: EdgeInsets.all(8)),
              Text("[multiLevel items example]"),
              Divider(),
              DropdownSearch<MultiLevelString>(
                key: myKey,
                items: (f, cs) => myItems,
                compareFn: (i1, i2) => i1.level1 == i2.level1,
                popupProps: PopupProps.menu(
                  showSelectedItems: true,
                  interceptCallBacks: true, //important line
                  itemBuilder: (ctx, item, isSelected) {
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
                                    myKey.currentState?.updatePopupState();
                                  },
                                )
                              : IconButton(
                                  icon: Icon(Icons.arrow_right),
                                  onPressed: () {
                                    item.isExpanded = !item.isExpanded;
                                    myKey.currentState?.updatePopupState();
                                  },
                                )),
                      subtitle: item.subLevel.isNotEmpty && item.isExpanded
                          ? Container(
                              height: item.subLevel.length * 50,
                              child: ListView(
                                children: item.subLevel
                                    .map(
                                      (e) => ListTile(
                                        selected: myKey.currentState?.getSelectedItem?.level1 == e.level1,
                                        title: Text(e.level1),
                                        onTap: () {
                                          myKey.currentState?.popupValidate([e]);
                                        },
                                      ),
                                    )
                                    .toList(),
                              ),
                            )
                          : null,
                      onTap: () => myKey.currentState?.popupValidate([item]),
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

  Widget _customDropDownExampleMultiSelection(BuildContext context, List<UserModel> selectedItems) {
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
              leading: CircleAvatar(
                backgroundImage: NetworkImage(e.avatar),
              ),
              title: Text(e.name),
              subtitle: Text(
                e.createdAt.toString(),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _customPopupItemBuilderExample2(BuildContext context, UserModel item, bool isSelected) {
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
        leading: CircleAvatar(
          backgroundImage: NetworkImage(item.avatar),
        ),
      ),
    );
  }

  Future<List<UserModel>> getData(filter) async {
    var response = await Dio().get(
      "https://63c1210999c0a15d28e1ec1d.mockapi.io/users",
      queryParameters: {"filter": filter},
    );

    final data = response.data;
    if (data != null) {
      return UserModel.fromJsonList(data);
    }

    return [];
  }
}

class _dropdownWithGlobalCheckBox extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _dropdownWithGlobalCheckBoxState();
}

class _dropdownWithGlobalCheckBoxState extends State<_dropdownWithGlobalCheckBox> {
  final _popupBuilderKey = GlobalKey<DropdownSearchState<int>>();
  final ValueNotifier<bool?> longListCheckBoxValueNotifier = ValueNotifier(false);
  final longList = List.generate(110, (i) => i + 1);

  bool? _getCheckBoxState() {
    var selectedItem = _popupBuilderKey.currentState?.popupGetSelectedItems ?? [];
    var isAllSelected = _popupBuilderKey.currentState?.popupIsAllItemSelected ?? false;
    return selectedItem.isEmpty ? false : (isAllSelected ? true : null);
  }

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<int>.multiSelection(
      key: _popupBuilderKey,
      items: (f, ic) {
        return Future.delayed(Duration(seconds: 1), () {
          var list = f.isEmpty ? longList : longList.where((l) => l.toString().contains(f));

          return list.skip(ic!.skip).take(ic.take).toList();
        });
      },
      popupProps: PopupPropsMultiSelection.dialog(
        onItemAdded: (l, s) => longListCheckBoxValueNotifier.value = _getCheckBoxState(),
        onItemRemoved: (l, s) => longListCheckBoxValueNotifier.value = _getCheckBoxState(),
        onItemsLoaded: (value) => longListCheckBoxValueNotifier.value = _getCheckBoxState(),
        infiniteScrollProps: InfiniteScrollProps(loadProps: LoadProps(skip: 0, take: 10)),
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
                              if (v == null) v = false;
                              if (v == true)
                                _popupBuilderKey.currentState?.popupSelectAllItems();
                              else if (v == false) _popupBuilderKey.currentState?.popupDeselectAllItems();
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
    );
  }
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

  MultiLevelString copy({
    String? level1,
    List<MultiLevelString>? subLevel,
    bool? isExpanded,
  }) =>
      MultiLevelString(
        level1: level1 ?? this.level1,
        subLevel: subLevel ?? this.subLevel,
        isExpanded: isExpanded ?? this.isExpanded,
      );

  @override
  String toString() => level1;
}
