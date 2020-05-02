import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdownSearch.dart';

import 'user_model.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final popupButtonKey = GlobalKey<
      State>(); // We use `State` because Flutter libs do not export `PopupMenuButton` state specifically.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("DropdownSearch Example")),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(16),
            ),

            Row(
              children: <Widget>[
                Expanded(
                  child:

                      ///Menu Mode with no searchBox
                      DropdownSearch<String>(
                          showSelectedItem: true,
                          mode: Mode.MENU,
                          items: [
                            "Brazil",
                            "Itália",
                            "Itália",
                            "Itália",
                            "Itália",
                            "Itália",
                            "Itália",
                            "Estados Unidos",
                            "Estados Unidos",
                            "Estados Unidos",
                            "Estados Unidos",
                            "Estados Unidos",
                            "Estados Unidos",
                            "Estados Unidos",
                            "Estados Unidos",
                            'salim'
                          ],
                          label: "country",
                          onChanged: print,
                          selectedItem: "Brazil",
                          showSearchBox: false),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                ),
                Expanded(
                  child:

                      ///Menu Mode with no searchBox
                      DropdownSearch<String>(
                          showSelectedItem: true,
                          mode: Mode.MENU,
                          dialogMaxWidth: 50,
                          items: ["Brasil", "Itália", "Estados Unidos"],
                          label: "country",
                          onChanged: print,
                          selectedItem: "Brasil",
                          showSearchBox: false),
                ),
              ],
              mainAxisSize: MainAxisSize.max,
            ),
            Divider(),

            ///Menu Mode with searchBox
            DropdownSearch(
                showSelectedItem: true,
                mode: Mode.MENU,
                items: [
                  "Brazil",
                  "Itália",
                  "Estados Unidos",
                  "Estados Unidos",
                  "Estados Unidos",
                  "Estados Unidos",
                  "Estados Unidos",
                  "Estados Unidos",
                  "last item"
                ],
                label: "country with custom colors",
                onChanged: print,
                selectedItem: "Brazil",
                showSearchBox: true),
            Divider(),

            ///BottomSheet Mode with no searchBox
            DropdownSearch<String>(
                popupTitle: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColorDark,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)),
                  ),
                  child: Center(
                    child: Text('Country',
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                  ),
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24))),
                mode: Mode.MENU,
                maxHeight: 300,
                items: ["Brazil", "Italia", "Tunisia",'Canada','France', "Tunisia",'Canada','France', "Tunisia",'Canada','France', "Tunisia",'Canada','end'],
                label: "BottomShet mode",
                onChanged: print,
                selectedItem: "Brazil",
                showSearchBox: true),
            Divider(),

            ///BottomSheet Mode with searchBox
            DropdownSearch<String>(
                mode: Mode.BOTTOM_SHEET,
                maxHeight: 300,
                items: ["Brazil", "Italia", "Tunisia"],
                label: "BottomShet mode",
                onChanged: print,
                selectedItem: "Brazil",
                showSearchBox: true),
            Divider(),

            ///dialog mode with clear option and validate
            DropdownSearch<String>(
              showClearButton: true,
              items: ["Brasil", "Itália", "Estados Unidos", "Canadá"],
              label: "País",
              onChanged: print,
              selectedItem: "Brasil",
              showSearchBox: false,
              validate: (String item) {
                if (item == null)
                  return "Required field";
                else if (item == "Brasil")
                  return "Invalid item";
                else
                  return null;
              },
            ),
            Divider(),

            ///using "itemAsString" to define the fields to be shown
            DropdownSearch<UserModel>(
              label: "filtre name with custom function ItemAsString",
              onFind: (String filter) => getData(filter),
              itemAsString: (UserModel u) => u.userAsString(),
              searchBoxDecoration: InputDecoration(
                hintText: "Search",
                border: OutlineInputBorder(),
              ),
              onChanged: (UserModel data) => print(data),
            ),
            Divider(),

            ///merge online and offline data in the same list and set custom max Height
            DropdownSearch<UserModel>(
              items: [
                UserModel(name: "name", id: "999"),
                UserModel(name: "name2", id: "0101")
              ],
              maxHeight: 300,
              onFind: (String filter) => getData(filter),
              label: "Online and offline together",
              onChanged: print,
              showSearchBox: true,
              validate: (UserModel item) {
                if (item == null)
                  return "Required field";
                else if (item.name.contains("Leo"))
                  return "Invalid item";
                else
                  return null;
              },
            ),
            Divider(),

            ///add title to the dialog
            DropdownSearch<UserModel>(
              label: "Label",
              onFind: (String filter) => getData(filter),
              searchBoxDecoration: InputDecoration(
                hintText: "Search",
                border: OutlineInputBorder(),
              ),
              onChanged: (UserModel data) => print(data),
            ),
            Divider(),

            ///custom itemBuilder and dropDownBuilder
            DropdownSearch<UserModel>(
              dialogMaxWidth: 200,
              showSelectedItem: true,
              compareFn: (UserModel i, UserModel s) => i.isEqual(s),
              label: "Person",
              onFind: (String filter) => getData(filter),
              onChanged: (UserModel data) {
                print(data);
              },
              dropdownBuilder: (BuildContext context, UserModel item,
                  String itemDesignation) {
                return Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).dividerColor),
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.white,
                  ),
                  child: (item?.avatar == null)
                      ? ListTile(
                          leading: CircleAvatar(),
                          title: Text("No item selected"),
                        )
                      : ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(item.avatar),
                          ),
                          title: Text(item.name),
                          subtitle: Text(item.createdAt.toString()),
                        ),
                );
              },
              dropdownItemBuilder:
                  (BuildContext context, UserModel item, bool isSelected) {
                return Container(
                  decoration: !isSelected
                      ? null
                      : BoxDecoration(
                          border:
                              Border.all(color: Theme.of(context).primaryColor),
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
              },
            ),
            Divider(),

            ///custom itemBuilder and dropDownBuilder with clear option
            DropdownSearch<UserModel>(
              isFilteredOnline: true,
              label: "Person with clear option with filter online",
              showClearButton: true,
              onFind: (String filter) => getData(filter),
              onChanged: (UserModel data) {
                print(data);
              },
              dropdownBuilder: (BuildContext context, UserModel item,
                  String itemDesignation) {
                return Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).dividerColor),
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.white,
                  ),
                  child: (item?.avatar == null)
                      ? ListTile(
                          leading: CircleAvatar(),
                          title: Text("No item selected"),
                        )
                      : ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(item.avatar),
                          ),
                          title: Text(item.name),
                          subtitle: Text(item.createdAt.toString()),
                        ),
                );
              },
              dropdownItemBuilder:
                  (BuildContext context, UserModel item, bool isSelected) {
                return Container(
                  decoration: !isSelected
                      ? null
                      : BoxDecoration(
                          border:
                              Border.all(color: Theme.of(context).primaryColor),
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
              },
            ),
            Divider(),

            ///custom itemBuilder and dropDownBuilder with clear option and FilterFN
            DropdownSearch<UserModel>(
              showSearchBox: true,
              autoFocusSearchBox: true,
              filterFn: (user, filter) => user.userFilterByCreationDate(filter),
              isFilteredOnline: true,
              label: "Person with clear option and Custom FilterFN",
              showClearButton: true,
              onFind: (String filter) => getData(filter),
              onChanged: (UserModel data) {
                print(data);
              },
              dropdownBuilder: (BuildContext context, UserModel item,
                  String itemDesignation) {
                return Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).dividerColor),
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.white,
                  ),
                  child: (item?.avatar == null)
                      ? ListTile(
                          leading: CircleAvatar(),
                          title: Text("No item selected"),
                        )
                      : ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(item.avatar),
                          ),
                          title: Text(item.name),
                          subtitle: Text(item.createdAt.toString()),
                        ),
                );
              },
              dropdownItemBuilder:
                  (BuildContext context, UserModel item, bool isSelected) {
                return Container(
                  decoration: !isSelected
                      ? null
                      : BoxDecoration(
                          border:
                              Border.all(color: Theme.of(context).primaryColor),
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
              },
            ),
            Divider(),

            ///disabled
            DropdownSearch<UserModel>(
              isFilteredOnline: true,
              enabled: false,
              label: "DISABLED Person with clear option with filter online",
              showClearButton: true,
              onFind: (String filter) => getData(filter),
              onChanged: (UserModel data) {
                print(data);
              },
              dropdownBuilder: (BuildContext context, UserModel item,
                  String itemDesignation) {
                return Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).dividerColor),
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.white,
                  ),
                  child: (item?.avatar == null)
                      ? ListTile(
                          leading: CircleAvatar(),
                          title: Text("No item selected"),
                        )
                      : ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(item.avatar),
                          ),
                          title: Text(item.name),
                          subtitle: Text(item.createdAt.toString()),
                        ),
                );
              },
              dropdownItemBuilder:
                  (BuildContext context, UserModel item, bool isSelected) {
                return Container(
                  decoration: !isSelected
                      ? null
                      : BoxDecoration(
                          border:
                              Border.all(color: Theme.of(context).primaryColor),
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
              },
            ),
          ],
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
