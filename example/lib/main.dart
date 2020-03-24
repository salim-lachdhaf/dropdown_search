import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:find_dropdown/find_dropdown.dart';

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
      appBar: AppBar(title: Text("FindDropdown Example")),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: <Widget>[
            FindDropdown(
              items: ["Brasil", "Itália", "Estados Unidos", "Canadá"],
              label: "País",
              onChanged: print,
              selectedItem: "Brasil",
              showSearchBox: false,
              labelStyle: TextStyle(color: Colors.redAccent),
              backgroundColor: Colors.redAccent,
              dialogTitleStyle:TextStyle(color: Colors.greenAccent),
              validate: (String item) {
                if (item == null)
                  return "Required field";
                else if (item == "Brasil")
                  return "Invalid item";
                else
                  return null;
              },
            ),
            FindDropdown<UserModel>(
              label: "Nome",
              onFind: (String filter) => getData(filter),
              itemAsString: UserModel.userAsString,
              searchBoxDecoration: InputDecoration(
                hintText: "Search",
                border: OutlineInputBorder(),
              ),
              onChanged: (UserModel data) => print(data),
            ),

            FindDropdown<UserModel>(
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


            FindDropdown<UserModel>(
              label: "Personagem",
              onFind: (String filter) => getData(filter),
              onChanged: (UserModel data) {
                print(data);
              },
              dropdownBuilder: (BuildContext context, UserModel item, String itemDesignation) {
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

            FindDropdown<UserModel>(
              label: "Person with clear option",
              showClearButton: true,
              onFind: (String filter) => getData(filter),
              onChanged: (UserModel data) {
                print(data);
              },
              dropdownBuilder: (BuildContext context, UserModel item, String itemDesignation) {
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
