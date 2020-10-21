import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

import 'user_model.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      //enable this line if you want test Dark Mode
      //theme: ThemeData.dark(),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();

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
              ///Menu Mode with no searchBox
              DropdownSearch<String>(
                validator: (v) => v == null ? "required field" : null,
                hint: "Select a country",
                mode: Mode.MENU,
                showSelectedItem: true,
                items: ["Brazil", "Italia (Disabled)", "Tunisia", 'Canada'],
                label: "Menu mode *",
                showClearButton: true,
                onChanged: print,
                popupItemDisabled: (String s) => s.startsWith('I'),
                selectedItem: "Brazil",
              ),
              Divider(),
              DropdownSearch<UserModel>(
                searchBoxController: TextEditingController(text: 'Mrs'),
                mode: Mode.BOTTOM_SHEET,
                isFilteredOnline: true,
                showClearButton: true,
                showSearchBox: true,
                label: 'User *',
                dropdownSearchDecoration: InputDecoration(
                  filled: true,
                  fillColor: Theme.of(context).inputDecorationTheme.fillColor,
                ),
                autoValidateMode: AutovalidateMode.onUserInteraction,
                validator: (UserModel u) =>
                    u == null ? "user field is required " : null,
                onFind: (String filter) => getData(filter),
                onChanged: (UserModel data) {
                  print(data);
                },
                dropdownBuilder: _customDropDownExample,
                popupItemBuilder: _customPopupItemBuilderExample,
              ),
              Divider(),

              ///custom itemBuilder and dropDownBuilder
              DropdownSearch<UserModel>(
                showSelectedItem: true,
                compareFn: (UserModel i, UserModel s) => i.isEqual(s),
                label: "Person",
                onFind: (String filter) => getData(filter),
                onChanged: (UserModel data) {
                  print(data);
                },
                dropdownBuilder: _customDropDownExample,
                popupItemBuilder: _customPopupItemBuilderExample2,
              ),
              Divider(),

              ///BottomSheet Mode with no searchBox
              DropdownSearch<String>(
                mode: Mode.BOTTOM_SHEET,
                maxHeight: 300,
                items: ["Brazil", "Italia", "Tunisia", 'Canada'],
                label: "Custom BottomShet mode",
                onChanged: print,
                selectedItem: "Brazil",
                showSearchBox: true,
                searchBoxDecoration: InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.fromLTRB(12, 12, 8, 0),
                  labelText: "Search a country",
                ),
                popupTitle: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColorDark,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'Country',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                popupShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
              ),
              Divider(),

              ///merge online and offline data in the same list and set custom max Height
              DropdownSearch<UserModel>(
                items: [
                  UserModel(name: "Offline name1", id: "999"),
                  UserModel(name: "Offline name2", id: "0101")
                ],
                maxHeight: 300,
                onFind: (String filter) => getData(filter),
                label: "choose a user",
                onChanged: print,
                showSearchBox: true,
              ),
              Divider(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _customDropDownExample(
      BuildContext context, UserModel item, String itemDesignation) {
    return Container(
      child: (item?.avatar == null)
          ? ListTile(
              contentPadding: EdgeInsets.all(0),
              leading: CircleAvatar(),
              title: Text("No item selected"),
            )
          : ListTile(
              contentPadding: EdgeInsets.all(0),
              leading: CircleAvatar(
                backgroundImage: NetworkImage(item.avatar),
              ),
              title: Text(item.name),
              subtitle: Text(
                item.createdAt.toString(),
              ),
            ),
    );
  }

  Widget _customPopupItemBuilderExample(
      BuildContext context, UserModel item, bool isSelected) {
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

  Widget _customPopupItemBuilderExample2(
      BuildContext context, UserModel item, bool isSelected) {
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
      "http://5d85ccfb1e61af001471bf60.mockapi.io/user",
      queryParameters: {"filter": filter},
    );

    var models = UserModel.fromJsonList(response.data);
    return models;
  }
}
