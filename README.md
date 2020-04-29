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

* Online and offline items
* Searchable dropdown
* Three dropdown mode: Menu/ BottomSheet/ Dialog
* Material dropdown
* Easy customizable UI
* Easy implementation into statelessWidget

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
  label: "País",
  onChanged: print,
  selectedItem: "Brazil",
);
```

## customize showed field (itemAsString)
```dart
DropdownSearch<UserModel>(
  label: "Name",
  onFind: (String filter) => getData(filter),
  itemAsString: UserModel.userAsStringByName,
  searchBoxDecoration: InputDecoration(
    hintText: "Search",
    border: OutlineInputBorder(),
  ),
  onChanged: (UserModel data) => print(data),
),

DropdownSearch<UserModel>(
  label: "Name",
  onFind: (String filter) => getData(filter),
  itemAsString: UserModel.userAsStringById,
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
  filterFn: UserModel.userFilterByCreationDate,
  onFind: (String filter) => getData(filter),
  itemAsString: UserModel.userAsStringByName,
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
  itemAsString: UserModel.userAsStringByName,
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
|`showSelectedItem`| manage selected item visibility (if true, the selected item will be highlighted)|
|`compareFn`| Function(T item, T selectedItem), custom comparing function|
|`dropdownSearchDecoration`| input decoration|
|`emptyBuilder`| custom layout for empty results|
|`loadingBuilder`| custom layout for loading items|
|`errorBuilder`| custom layout for error|

# Attention
To use a template as an item type, and you don't want to use a custom fonction **itemAsString** and **compareFn** you **need** to implement **toString**, **equals** and **hashcode**, as shown below:

```dart
class UserModel {
  final String id;
  final DateTime createdAt;
  final String name;
  final String avatar;

  UserModel({this.id, this.createdAt, this.name, this.avatar});

  ///this method will prevent the override of toString and make the same model useful for different cases
    static String userAsStringByName(UserModel userModel){
      return '#${userModel.id} ${userModel.name}';
    }

    //this method will prevent the override of toString
    static String userAsStringById(UserModel userModel){
      return '#${userModel.id} ${userModel.id}';
    }

    ///this method will prevent the override of toString
    static bool userFilterByCreationDate(UserModel userModel, String filter){
      return userModel?.createdAt?.toString()?.contains(filter);
    }

    ///custom comparing function to check if two users are equal
    static bool isEqual(UserModel model1, UserModel model2) {
      return model1?.id == model2?.id;
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
