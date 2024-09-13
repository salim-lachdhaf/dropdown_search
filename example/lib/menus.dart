import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

import 'main.dart';
import 'user_model.dart';

class MenuExamplesPage extends StatefulWidget {
  @override
  State<MenuExamplesPage> createState() => _MenuExamplesPageState();
}

class _MenuExamplesPageState extends State<MenuExamplesPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("DropdownSearch Menu Demo")),
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
                    mode: Mode.custom,
                    items: (f, cs) => ["Monday", 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'],
                    popupProps: PopupPropsMultiSelection.menu(
                      disabledItemFn: (item) => item == 'Tuesday',
                    ),
                    dropdownBuilder: (ctx, selectedItem) => Icon(Icons.calendar_month_outlined, size: 54),
                  ),
                  DropdownSearch<(String, Color)>(
                    clickProps: ClickProps(borderRadius: BorderRadius.circular(20)),
                    mode: Mode.custom,
                    items: (f, cs) => [
                      ("Red", Colors.red),
                      ("Black", Colors.black),
                      ("Yellow", Colors.yellow),
                      ('Blue', Colors.blue),
                    ],
                    compareFn: (item1, item2) => item1.$1 == item2.$1,
                    popupProps: PopupProps.menu(
                      menuProps: MenuProps(align: MenuAlign.bottomCenter),
                      fit: FlexFit.loose,
                      itemBuilder: (context, item, isDisabled, isSelected) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(item.$1, style: TextStyle(color: item.$2, fontSize: 16)),
                      ),
                    ),
                    dropdownBuilder: (ctx, selectedItem) => Icon(Icons.face, color: selectedItem?.$2, size: 54),
                  ),
                  DropdownSearch<String>(
                    mode: Mode.custom,
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
                    child: SizedBox(
                      height: 50,
                      child: DropdownSearch<int>.multiSelection(
                        items: (f, cs) => List.generate(50, (i) => i),
                        selectedItemsScrollProps: ScrollProps(scrollDirection: Axis.horizontal),
                      ),
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
                      suffixProps: DropdownSuffixProps(clearButtonProps: ClearButtonProps(isVisible: true)),
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
                        itemBuilder: (ctx, item, isDisabled, isSelected) {
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
              Padding(padding: EdgeInsets.all(32)),

              Container(
                height: 500,
                padding: EdgeInsets.symmetric(vertical: 18, horizontal: 12),
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
                      compareFn: (item1, item2) => item1.$1 == item2.$1,
                      items: (f, cs) => [
                        (Icons.person, 'Your Profile'),
                        (Icons.settings, 'Setting'),
                        (Icons.lock_open_rounded, 'Change Password'),
                        (Icons.power_settings_new_rounded, 'Logout'),
                      ],
                      decoratorProps: DropDownDecoratorProps(
                        decoration: InputDecoration(
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
                        itemBuilder: (context, item, isDisabled, isSelected) {
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
                      suffixProps: DropdownSuffixProps(
                        dropdownButtonProps: DropdownButtonProps(
                          iconClosed: Icon(Icons.keyboard_arrow_down),
                          iconOpened: Icon(Icons.keyboard_arrow_up),
                        ),
                      ),
                      decoratorProps: DropDownDecoratorProps(
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
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
                        itemBuilder: (context, item, isDisabled, isSelected) {
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
                          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                        ),
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(top: 32)),
                    DropdownSearch<String>(
                      items: (filter, loadProps) => ["Item 1", "Item 2", "Item 3", "Item 4"],
                      decoratorProps: DropDownDecoratorProps(
                        decoration: InputDecoration(labelText: 'Bottom Left Menu', border: OutlineInputBorder()),
                      ),
                      popupProps: PopupProps.menu(
                        constraints: BoxConstraints.tight(Size(250, 250)),
                        menuProps: MenuProps(align: MenuAlign.bottomStart),
                      ),
                    ),
                    Padding(padding: EdgeInsets.symmetric(vertical: 8)),
                    DropdownSearch<String>(
                      decoratorProps: DropDownDecoratorProps(
                        decoration: InputDecoration(labelText: 'Bottom Center Menu', border: OutlineInputBorder()),
                      ),
                      items: (filter, loadProps) => ["Item 1", "Item 2", "Item 3", "Item 4"],
                      popupProps: PopupProps.menu(
                        constraints: BoxConstraints.tight(Size(250, 250)),
                        menuProps: MenuProps(align: MenuAlign.bottomCenter),
                      ),
                    ),
                    Padding(padding: EdgeInsets.symmetric(vertical: 8)),
                    DropdownSearch<String>(
                      decoratorProps: DropDownDecoratorProps(
                        decoration: InputDecoration(labelText: 'Top Right Menu', border: OutlineInputBorder()),
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
              Padding(padding: EdgeInsets.all(32)),
              Text("[validation examples]"),
              Divider(),
              Row(
                children: [
                  Expanded(
                    child: DropdownSearch<int>(
                      items: (f, cs) => [1, 2, 3, 4, 5, 6, 7],
                      autoValidateMode: AutovalidateMode.onUserInteraction,
                      validator: (int? i) {
                        if (i == null) {
                          return 'required filed';
                        } else if (i >= 5) {
                          return 'value should be < 5';
                        }
                        return null;
                      },
                      suffixProps: DropdownSuffixProps(clearButtonProps: ClearButtonProps(isVisible: true)),
                    ),
                  ),
                  Padding(padding: EdgeInsets.all(4)),
                  Expanded(
                    child: DropdownSearch<int>.multiSelection(
                      items: (f, cs) => [1, 2, 3, 4, 5, 6, 7],
                      validator: (List<int>? items) {
                        if (items == null || items.isEmpty) {
                          return 'required filed';
                        } else if (items.length > 3) {
                          return 'only 1 to 3 items are allowed';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              Padding(padding: EdgeInsets.only(top: 32)),
            ],
          ),
        ),
      ),
    );
  }
}
