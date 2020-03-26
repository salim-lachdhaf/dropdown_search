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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("DropdownSearch Example")),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: ListView(
          children: <Widget>[
            DropdownSearch(
              items: ["Brasil", "Itália", "Estados Unidos", "Canadá"],
              label: "country with custom colors",
              onChanged: print,
              selectedItem: "Brasil",
              showSearchBox: false,
              labelStyle: TextStyle(color: Colors.redAccent),
              backgroundColor: Colors.redAccent,
              dialogTitleStyle: TextStyle(color: Colors.greenAccent),
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
            DropdownSearch(
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
            DropdownSearch<UserModel>(
              label: "filtre name with custom function ItemAsString",
              onFind: (String filter) => getData(filter),
              itemAsString: UserModel.userAsString,
              searchBoxDecoration: InputDecoration(
                hintText: "Search",
                border: OutlineInputBorder(),
              ),
              onChanged: (UserModel data) => print(data),
            ),
            Divider(),
            DropdownSearch<UserModel>(
              items: [
                UserModel(name: "name", id: "999"),
                UserModel(name: "name2", id: "0101")
              ],
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
            DropdownSearch<UserModel>(
              label: "Label",
              dialogTitle: "Title dialog",
              dropdownBuilderHeight: 70,
              onFind: (String filter) => getData(filter),
              searchBoxDecoration: InputDecoration(
                hintText: "Search",
                border: OutlineInputBorder(),
              ),
              onChanged: (UserModel data) => print(data),
            ),
            Divider(),
            DropdownSearch<UserModel>(
              label: "Personagem",
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
