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

* Reactive widget
* Infinite list (lazy loading)
* Sync and/or Async items (online, offline, DB, ...)
* Searchable dropdown
* Support multi level items
* Four dropdown mode: Menu/ BottomSheet/ ModalBottomSheet / Dialog
* Single & multi selection
* Material dropdown
* Easy customizable UI - No Boilerplate
* Handle Light and Dark theme
* Easy implementation into statelessWidget

<table>
    <tr>
        <td>
            <img src="https://github.com/salim-lachdhaf/searchable_dropdown/blob/master/screenshots/ex4.png?raw=true" alt="Dropdown search" width="400" />
        </td>
        <td>
            <img src="https://github.com/salim-lachdhaf/searchable_dropdown/blob/master/screenshots/ex1.png?raw=true" alt="Dropdown search" width="400" />
        </td>
    </tr>
    <tr>
        <td>
            <img src="https://github.com/salim-lachdhaf/searchable_dropdown/blob/master/screenshots/ex2.png?raw=true" alt="Dropdown search" width="400" />
        </td>
        <td>
            <img src="https://github.com/salim-lachdhaf/searchable_dropdown/blob/master/screenshots/ex3.png?raw=true" alt="Dropdown search" width="400" />
        </td>
    </tr>
</table>

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
  items: (f, cs) => ["Monday", 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'],
  popupProps: PopupProps.menu(
    disabledItemFn: (item) => item == 'Tuesday',
  ),
), 

DropdownSearch<String>.multiSelection(
  mode: Mode.CUSTOM,
  items: (f, cs) => ["Monday", 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'],
  popupProps: PopupPropsMultiSelection.menu(
    disabledItemFn: (item) => item == 'Tuesday',
  ),
  dropdownBuilder: (ctx, selectedItem) => Icon(Icons.calendar_month_outlined, size: 54),
),
```

## customize showed field (itemAsString)

```dart
DropdownSearch<UserModel>(
    asyncItems: (String filter) => getData(filter),
    itemAsString: (UserModel u) => u.userAsStringByName(),
    onChanged: (UserModel? data) => print(data),
    dropdownDecoratorProps: DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(labelText: "User by name"),
    ),
)

DropdownSearch<UserModel>(
    asyncItems: (String filter) => getData(filter),
    itemAsString: (UserModel u) => u.userAsStringById(),
    onChanged: (UserModel? data) => print(data),
    dropdownDecoratorProps: DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(labelText: "User by id"),
    ),
)
```

## customize Filter Function
```dart
DropdownSearch<UserModel>(
    filterFn: (user, filter) =>
    user.userFilterByCreationDate(filter),
    asyncItems: (String filter) => getData(filter),
    itemAsString: (UserModel u) => u.userAsStringByName(),
    onChanged: (UserModel? data) => print(data),
    dropdownDecoratorProps: DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(labelText: "Name"),
    ),
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
DropdownSearch<String>(
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

## Layout customization
You can customize the layout of the DropdownSearch and its items. [EXAMPLE](https://github.com/salim-lachdhaf/searchable_dropdown/tree/master/example#custom-layout-endpoint-example)

Full documentation [here](https://pub.dev/documentation/dropdown_search/latest/dropdown_search/DropdownSearch-class.html)

<img src="https://github.com/salim-lachdhaf/searchable_dropdown/blob/master/screenshots/anatomy.png?raw=true" alt="Dropdown search" width="400" />


# [View more Examples](https://github.com/salim-lachdhaf/searchable_dropdown/tree/master/example)

## Support

If this plugin was useful to you, helped you to deliver your app, saved you a lot of time, or you just want to support the project, I would be very grateful if you buy me a cup of coffee.

<a href="https://www.buymeacoffee.com/SalimDev" target="_blank"><img src="https://www.buymeacoffee.com/assets/img/custom_images/purple_img.png" alt="Buy Me A Coffee" style="height: 41px !important;width: 174px !important;box-shadow: 0px 3px 2px 0px rgba(190, 190, 190, 0.5) !important;-webkit-box-shadow: 0px 3px 2px 0px rgba(190, 190, 190, 0.5) !important;" ></a>

## License

MIT
