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


## packages.yaml
```yaml
dropdown_search: <lastest version>
```

## Import
```dart
import 'package:dropdown_search/dropdown_search.dart';
```


## Simple implementation
<details><summary>See here</summary>

```dart
DropdownSearch<String>(
  items: (f, cs) => ["Item 1", 'Item 2', 'Item 3', 'Item 4'],
  popupProps: PopupProps.menu(
    disabledItemFn: (item) => item == 'Item 3',
    fit: FlexFit.loose
  ),
),
```
<img src="https://github.com/salim-lachdhaf/searchable_dropdown/blob/master/screenshots/exa1.png?raw=true" alt="Dropdown search" width="400" />



```dart
DropdownSearch<String>.multiSelection(
  mode: Mode.CUSTOM,
  items: (f, cs) => ["Monday", 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'],
  dropdownBuilder: (ctx, selectedItem) => Icon(Icons.calendar_month_outlined, size: 54),
),
```
<img src="https://github.com/salim-lachdhaf/searchable_dropdown/blob/master/screenshots/exa2.png?raw=true" alt="Dropdown search" width="400" />


```dart
DropdownSearch<(String, Color)>(
  clickProps: ClickProps(borderRadius: BorderRadius.circular(20)),
  mode: Mode.CUSTOM,
  items: (f, cs) => [
    ("Red", Colors.red),
    ("Black", Colors.black),
    ("Yellow", Colors.yellow),
    ('Blue', Colors.blue),
  ],
  compareFn: (item1, item2) => item1.$1 == item2.$2,
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
```
<img src="https://github.com/salim-lachdhaf/searchable_dropdown/blob/master/screenshots/exa4.gif?raw=true" alt="Dropdown search" width="400" />

```dart
DropdownSearch<(IconData, String)>(
  selectedItem: (Icons.person, 'Your Profile'),
  compareFn: (item1, item2) => item1.$1 == item2.$2,
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
```
<img src="https://github.com/salim-lachdhaf/searchable_dropdown/blob/master/screenshots/exa3.png?raw=true" alt="Dropdown search" width="400" />


```dart
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
    constraints: BoxConstraints(maxHeight: 160),
    menuProps: MenuProps(
      margin: EdgeInsets.only(top: 12),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
    ),
  ),
),
```
<img src="https://github.com/salim-lachdhaf/searchable_dropdown/blob/master/screenshots/exa5.png?raw=true" alt="Dropdown search" width="400" />


````dart
DropdownSearch<UserModel>.multiSelection(
  items: (filter, s) => getData(filter),
  compareFn: (i, s) => i.isEqual(s),
  popupProps: PopupPropsMultiSelection.bottomSheet(
    bottomSheetProps: BottomSheetProps(backgroundColor: Colors.blueGrey[50]),
    showSearchBox: true,
    itemBuilder: userModelPopupItem,
    suggestedItemProps: SuggestedItemProps(
      showSuggestedItems: true,
      suggestedItems: (us) {
        return us.where((e) => e.name.contains("Mrs")).toList();
      },
    ),
  ),
),
````
<img src="https://github.com/salim-lachdhaf/searchable_dropdown/blob/master/screenshots/exa6.gif?raw=true" alt="Dropdown search" width="400" />


````dart
DropdownSearch<int>(
  items: (f, cs) => List.generate(30, (i) => i + 1),
  decoratorProps: DropDownDecoratorProps(
    decoration: InputDecoration(labelText: "Dialog with title", hintText: "Select an Int"),
  ),
  popupProps: PopupProps.dialog(
    title: Container(
      decoration: BoxDecoration(color: Colors.deepPurple),
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Text(
        'Numbers 1..30',
        style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold, color: Colors.white70),
      ),
    ),
    dialogProps: DialogProps(
      clipBehavior: Clip.antiAlias,
      shape: OutlineInputBorder(
        borderSide: BorderSide(width: 0),
        borderRadius: BorderRadius.circular(25),
      ),
    ),
  ),
),
````
<img src="https://github.com/salim-lachdhaf/searchable_dropdown/blob/master/screenshots/exa7.gif?raw=true" alt="Dropdown search" width="400" />

</details>

## Layout customization
You can customize the layout of the DropdownSearch and its items. [EXAMPLE](https://github.com/salim-lachdhaf/searchable_dropdown/tree/master/example#custom-layout-endpoint-example)

Full documentation [here](https://pub.dev/documentation/dropdown_search/latest/dropdown_search/DropdownSearch-class.html)

<details><summary>DropdownSearch Anatomy</summary>
    <img src="https://github.com/salim-lachdhaf/searchable_dropdown/blob/master/screenshots/anatomy.png?raw=true" alt="Dropdown search" width="800" />
</details>


# [View more Examples](https://github.com/salim-lachdhaf/searchable_dropdown/tree/master/example)

## Support

If this plugin was useful to you, helped you to deliver your app, saved you a lot of time, or you just want to support the project, I would be very grateful if you buy me a cup of coffee.

<a href="https://www.buymeacoffee.com/SalimDev" target="_blank"><img src="https://www.buymeacoffee.com/assets/img/custom_images/purple_img.png" alt="Buy Me A Coffee" style="height: 41px !important;width: 174px !important;box-shadow: 0px 3px 2px 0px rgba(190, 190, 190, 0.5) !important;-webkit-box-shadow: 0px 3px 2px 0px rgba(190, 190, 190, 0.5) !important;" ></a>

## License

MIT
