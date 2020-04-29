[![Buy Me A Coffee](https://img.shields.io/badge/Donate-Buy%20Me%20A%20Coffee-yellow.svg)](https://www.buymeacoffee.com/SalimDev)

# DropdownSearch package

Simple and robust DropdownSearch with item search feature, making it possible to use an offline item list or filtering URL for easy customization.

![](https://github.com/salim-lachdhaf/searchable_dropdown/blob/master/screenshots/Screenshot_4.png?raw=true)

<img src="https://github.com/salim-lachdhaf/searchable_dropdown/blob/master/screenshots/GIF_Simple.gif?raw=true" width="49.5%" /> <img src="https://github.com/salim-lachdhaf/searchable_dropdown/blob/master/screenshots/GIF_Custom_Layout.gif?raw=true" width="49.5%" />


## packages.yaml
```yaml
dropdown_search: <lastest version>
```

## Import
```dart
import 'package:dropdown_search/dropdownSearch.dart';
```

## Simple implementation

```dart
DropdownSearch(
  items: ["Brazil", "Italia", "Tunisia", "Canada"],
  label: Country,
  onChanged: print,
  selectedItem: "Brazil",
);
```

## customize showed field (itemAsString)

```dart
DropdownSearch<UserModel>(
  label: "Name",
  onFind: (String filter) => getData(filter),
  itemAsString: (UserModel u) => u.userAsStringByName(),
  searchBoxDecoration: InputDecoration(
    hintText: "Search",
    border: OutlineInputBorder(),
  ),
  onChanged: (UserModel data) => print(data),
),

DropdownSearch<UserModel>(
  label: "Name",
  onFind: (String filter) => getData(filter),
  itemAsString: (UserModel u) => u.userAsStringById(),
  searchBoxDecoration: InputDecoration(
    hintText: "Search",
    border: OutlineInputBorder(),
  ),
  onChanged: (UserModel data) => print(data),
),
```

## customize Filter Function
```dart
DropdownSearch<UserModel>(
  label: "Name",
  filterFn: (user, filter) => user.userFilterByCreationDate(filter),
  onFind: (String filter) => getData(filter),
  itemAsString: (UserModel u) => u.userAsStringByName(),
  searchBoxDecoration: InputDecoration(
    hintText: "Search",
    border: OutlineInputBorder(),
  ),
  onChanged: (UserModel data) => print(data),
),
```

## customize Search Mode
```dart
DropdownSearch<UserModel>(
  mode: Mode.BOTTOM_SHEET,
  label: "Name",
  maxHeight: 350,
  onFind: (String filter) => getData(filter),
  itemAsString: (UserModel u) => u.userAsString(),
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

|  Properties |   Description|
| ------------ | ------------ |
|`label`|DropDownSearch label|
|`showSearchBox`|show/hide the search box|
|`isFilteredOnline`|true if the filter on items is applied onlie (via API)|
|`showClearButton`| show/hide clear selected item|
|`labelStyle`| text style for the DropdownSearch label|
|`items`| offline items list|
|`selectedItem`| selected item|
|`onFind`|function that returns item from API|
|`onChanged`|called when a new item is selected|
|`dropdownBuilder`|to customize list of items UI|
|`dropdownItemBuilder`|to customize selected item|
|`validate`|function to apply the validation formula|
|`searchBoxDecoration`|decoration for the search box|
|`backgroundColor`|background color for the dialog/menu/bottomSheet|
|`dialogTitle`|the title for dialog/menu/bottomSheet|
|`dialogTitleStyle`|text style for the dialog title|
|`dropdownItemBuilderHeight`|the height of the selected item UI|
|`itemAsString`|customize the fields the be shown|
|`filterFn`|custom filter function|
|`enabled`|enable/disable dropdownSearch|
|`mode`| MENU / DIALOG/ BOTTOM_SHEET|
|`maxHeight`| the max height for dialog/bottomSheet/Menu|


# Attention
To use a template as an item type, and you don't want to use a custom fonction ***itemAsString*** you **need** to implement **toString**, **equals** and **hashcode**, as shown below:

```dart
class UserModel {
  final String id;
  final DateTime createdAt;
  final String name;
  final String avatar;

  UserModel({this.id, this.createdAt, this.name, this.avatar});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    return UserModel(
      id: json["id"],
      createdAt:
          json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
      name: json["name"],
      avatar: json["avatar"],
    );
  }

  static List<UserModel> fromJsonList(List list) {
    if (list == null) return null;
    return list.map((item) => UserModel.fromJson(item)).toList();
  }

  ///this method will prevent the override of toString
  String userAsString() {
    return '#${this.id} ${this.name}';
  }

  ///this method will prevent the override of toString
  bool userFilterByCreationDate(String filter) {
    return this?.createdAt?.toString()?.contains(filter);
  }

  ///custom comparing function to check if two users are equal
  bool isEqual(UserModel model) {
    return this?.id == model?.id;
  }

  @override
  String toString() => name;
}
```

# [View more Examples](https://github.com/salim-lachdhaf/searchable_dropdown/tree/master/example)
