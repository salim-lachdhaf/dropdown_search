<h1 align="center">
  Flutter DropdownSearch
  <br>
</h1>

<h4 align="center">
  <a href="https://flutter.io" target="_blank">Flutter</a> simple and robust DropdownSearch with item search feature, making it possible to use an offline item list or filtering URL for easy customization.
</h4>

<p align="center">
  <a href="https://pub.dev/packages/dropdown_search">
    <img src="https://img.shields.io/badge/build-passing-brightgreen"
         alt="Build">
  </a>
  <a href="https://pub.dev/packages/dropdown_search"><img src="https://img.shields.io/pub/v/dropdown_search"></a>
  <a href="https://www.buymeacoffee.com/SalimDev">
    <img src="https://img.shields.io/badge/$-donate-ff69b4.svg?maxAge=2592000&amp;style=flat">
  </a>
</p>

<p align="center">
  <a href="#key-features">Key Features</a> •
  <a href="https://github.com/salim-lachdhaf/searchable_dropdown/blob/master/example">Examples</a> •
  <a href="#license">License</a>
</p>

<p align="center">
  <img src="https://github.com/salim-lachdhaf/searchable_dropdown/blob/master/screenshots/example.gif?raw=true" alt="Dropdown search" />
</p>

## Key Features

* Sync and/or Async items (online, offline, DB, ...)
* Searchable dropdown
* Three dropdown mode: Menu/ BottomSheet/ Dialog
* Single & multi selection
* Material dropdown
* Easy customizable UI
* Handle Light and Dark theme
* Easy implementation into statelessWidget

![](https://github.com/salim-lachdhaf/searchable_dropdown/blob/master/screenshots/Screenshot_4.png?raw=true)

## packages.yaml
```yaml
dropdown_search: <lastest version>
```

## Import
```dart
import 'package:dropdown_search/dropdown_search.dart';
```


## Simple implementation

```dart
DropdownSearch<String>(
    popupProps: PopupProps.menu(
        showSelectedItems: true,
        disabledItemFn: (String s) => s.startsWith('I'),
    ),
    items: ["Brazil", "Italia (Disabled)", "Tunisia", 'Canada'],
    dropdownSearchDecoration: InputDecoration(
        labelText: "Menu mode",
        hintText: "country in menu mode",
    ),
    onChanged: print,
    selectedItem: "Brazil",
)

DropdownSearch<String>.multiSelection(
    items: ["Brazil", "Italia (Disabled)", "Tunisia", 'Canada'],
    popupProps: PopupPropsMultiSelection.menu(
        showSelectedItems: true,
        disabledItemFn: (String s) => s.startsWith('I'),
    ),
    onChanged: print,
    selectedItems: ["Brazil"],
)
```

## customize showed field (itemAsString)

```dart
DropdownSearch<UserModel>(
    asyncItems: (String filter) => getData(filter),
    itemAsString: (UserModel u) => u.userAsStringByName(),
    onChanged: (UserModel? data) => print(data),
    dropdownSearchDecoration: InputDecoration(labelText: "User by name"),
)

DropdownSearch<UserModel>(
    asyncItems: (String filter) => getData(filter),
    itemAsString: (UserModel u) => u.userAsStringById(),
    onChanged: (UserModel? data) => print(data),
    dropdownSearchDecoration: InputDecoration(labelText: "User by id"),
)
```

## customize Filter Function
```dart
DropdownSearch<UserModel>(
    dropdownSearchDecoration: InputDecoration(labelText: "Name"),
    filterFn: (user, filter) =>
    user.userFilterByCreationDate(filter),
    asyncItems: (String filter) => getData(filter),
    itemAsString: (UserModel u) => u.userAsStringByName(),
    onChanged: (UserModel? data) => print(data),
)
```

## customize Search Mode
```dart
DropdownSearch<UserModel>(
    popupProps: PopupProps.bottomSheet(),
    dropdownSearchDecoration: InputDecoration(labelText: "Name"),
    asyncItems: (String filter) => getData(filter),
    itemAsString: (UserModel u) => u.userAsString(),
    onChanged: (UserModel? data) => print(data),
)
```

## Validation
```dart
DropdownSearch(
    items: ["Brazil", "France", "Tunisia", "Canada"],
    dropdownSearchDecoration: InputDecoration(labelText: "Name"),
    onChanged: print,
    selectedItem: "Tunisia",
    validator: (String? item) {
    if (item == null)
    return "Required field";
    else if (item == "Brazil")
    return "Invalid item";
    else
    return null;
    },
)
```


## Endpoint implementation (using [Dio package](https://pub.dev/packages/dio))
```dart
DropdownSearch<UserModel>(
    dropdownSearchDecoration: InputDecoration(labelText: "Name"),
    asyncItems: (String filter) async {
        var response = await Dio().get(
            "http://5d85ccfb1e61af001471bf60.mockapi.io/user",
            queryParameters: {"filter": filter},
        );
        var models = UserModel.fromJsonList(response.data);
        return models;
    },
    onChanged: (UserModel? data) {
      print(data);
    },
)
```
## Layout customization
You can customize the layout of the DropdownSearch and its items. [EXAMPLE](https://github.com/salim-lachdhaf/searchable_dropdown/tree/master/example#custom-layout-endpoint-example)

Full documentation [here](https://pub.dev/documentation/dropdown_search/latest/dropdown_search/DropdownSearch-class.html)

# Attention
To use a template as an item type, and you don't want to use a custom function **itemAsString** and **compareFn** you **need** to implement **toString**, **equals** and **hashcode**, as shown below:


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
    return this.createdAt.toString().contains(filter);
  }

  ///custom comparing function to check if two users are equal
  bool isEqual(UserModel model) {
    return this.id == model.id;
  }

  @override
  String toString() => name;
}
```

# [View more Examples](https://github.com/salim-lachdhaf/searchable_dropdown/tree/master/example)

## Support

If this plugin was useful to you, helped you to deliver your app, saved you a lot of time, or you just want to support the project, I would be very grateful if you buy me a cup of coffee.

<a href="https://www.buymeacoffee.com/SalimDev" target="_blank"><img src="https://www.buymeacoffee.com/assets/img/custom_images/purple_img.png" alt="Buy Me A Coffee" style="height: 41px !important;width: 174px !important;box-shadow: 0px 3px 2px 0px rgba(190, 190, 190, 0.5) !important;-webkit-box-shadow: 0px 3px 2px 0px rgba(190, 190, 190, 0.5) !important;" ></a>

## License

MIT
