[![Buy Me A Coffee](https://img.shields.io/badge/Donate-Buy%20Me%20A%20Coffee-yellow.svg)](https://www.buymeacoffee.com/deivao)

# DropdownSearch package

Simple and robust DropdownSearch with item search feature, making it possible to use an offline item list or filtering URL for easy customization.

![](https://github.com/salim-lachdhaf/searchable_dropdown/tree/master/screenshots/Screenshot_4.png?raw=true)

<img src="https://github.com/salim-lachdhaf/searchable_dropdown/tree/master/screenshots/GIF_Simple.gif?raw=true" width="49.5%" /> <img src="https://github.com/davidsdearaujo/find_dropdown/blob/master/screenshots/GIF_Custom_Layout.gif?raw=true" width="49.5%" />

## ATTENTION
If you use rxdart in your project in a version lower than 0.23.x, use version `0.1.7+1` of this package. Otherwise, you can use the most current version!

## packages.yaml
```yaml
searchable_dropdown: <lastest version>
```

## Import
```dart
import 'package:searchable_dropdown/searchableDropdown.dart';
```

## Simple implementation

```dart
DropdownSearch(
  items: ["Brasil", "Itália", "Estados Undos", "Canadá"],
  label: "País",
  onChanged: print,
  selectedItem: "Brasil",
);
```

## customize showed field (itemAsString)
```dart
DropdownSearch<UserModel>(
  label: "Nome",
  onFind: (String filter) => getData(filter),
  itemAsString: UserModel.userAsStringByName,
  searchBoxDecoration: InputDecoration(
    hintText: "Search",
    border: OutlineInputBorder(),
  ),
  onChanged: (UserModel data) => print(data),
),

DropdownSearch<UserModel>(
  label: "Nome",
  onFind: (String filter) => getData(filter),
  itemAsString: UserModel.userAsStringById,
  searchBoxDecoration: InputDecoration(
    hintText: "Search",
    border: OutlineInputBorder(),
  ),
  onChanged: (UserModel data) => print(data),
),
```

## Validation
```dart
DropdownSearch(
  items: ["Brazil", "France", "Tunisia", "Canada"],
  label: "Country",
  onChanged: print,
  selectedItem: "Tunisia",
  validate: (String item) {
    if (item == null)
      return "Required field";
    else if (item == "Brazil")
      return "Invalid item";
    else
      return null;
  },
);
```


## Endpoint implementation (using [Dio package](https://pub.dev/packages/dio))
```dart
DropdownSearch<UserModel>(
  label: "Nome",
  onFind: (String filter) async {
    var response = await Dio().get(
        "http://5d85ccfb1e61af001471bf60.mockapi.io/user",
        queryParameters: {"filter": filter},
    );
    var models = UserModel.fromJsonList(response.data);
    return models;
  },
  onChanged: (UserModel data) {
    print(data);
  },
);
```
## Layout customization
You can customize the layout of the DropdownSearch and its items. [EXAMPLE](https://github.com/salim-lachdhaf/searchable_dropdown/tree/master/example#custom-layout-endpoint-example)

To **customize the DropdownSearch**, we have the `dropdownBuilder` property, which takes a function with the parameters:
- `BuildContext context`: current context;
- `T item`: Current item, where **T** is the type passed in the DropdownSearch constructor.

To **customize the items**, we have the `dropdownItemBuilder` property, which takes a function with the parameters:
- `BuildContext context`: current context;
- `T item`: Current item, where **T** is the type passed in the DropdownSearch constructor.
- `bool isSelected`: Boolean that tells you if the current item is selected.

# Attention
To use a template as an item type, you need to implement **toString**, **equals** and **hashcode**, as shown below:

```dart
class UserModel {
  final String id;
  final DateTime createdAt;
  final String name;
  final String avatar;

  UserModel({this.id, this.createdAt, this.name, this.avatar});

  //this method will prevent the override of toString and make the same model useful for different cases
    static String userAsStringByName(UserModel userModel){
      return '#${userModel.id} ${userModel.name}';
    }

    //this method will prevent the override of toString
    static String userAsStringById(UserModel userModel){
      return '#${userModel.id} ${userModel.id}';
    }


  @override
  String toString() => name;

  @override
  operator ==(o) => o is UserModel && o.id == id;

  @override
  int get hashCode => id.hashCode^name.hashCode^createdAt.hashCode;

}
```

# [View more Examples](https://github.com/salim-lachdhaf/searchable_dropdown/tree/master/example)
