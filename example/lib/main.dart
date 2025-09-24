import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:example/adaptive/menus.dart';
import 'package:example/material/autocomplete.dart';
import 'package:example/material/bottom_sheets.dart';
import 'package:example/material/modals.dart';
import 'package:example/user_model.dart';
import 'package:flutter/material.dart';

import 'adaptive/autocomplete.dart';
import 'adaptive/bottom_sheets.dart';
import 'adaptive/dialogs.dart';
import 'adaptive/modals.dart';
import 'cupertino/autocomplete.dart';
import 'cupertino/bottom_sheets.dart';
import 'cupertino/dialogs.dart';
import 'cupertino/menus.dart';
import 'cupertino/modals.dart';
import 'material/dialogs.dart';
import 'material/menus.dart';

void main() => runApp(MyApp());

Future<List<UserModel>> getData(filter) async {
  var response = await Dio().get(
    "https://63c1210999c0a15d28e1ec1d.mockapi.io/users",
    queryParameters: {"filter": filter},
  );

  final data = response.data;
  if (data != null) {
    return UserModel.fromJsonList(data);
  }

  return [];
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'dropdownSearch Demo',
      //enable this line if you want test Dark Mode
      theme: ThemeData.dark(),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final dropDownKey = GlobalKey<DropdownSearchState<PopupMode>>();
  final dropDownUiModeKey = GlobalKey<DropdownSearchState<UiMode>>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('examples mode')),
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        children: [
          Row(
            children: [
              Expanded(
                child: DropdownSearch<PopupMode>(
                  key: dropDownKey,
                  selectedItem: PopupMode.menu,
                  itemAsString: (item) => item.name,
                  compareFn: (i1, i2) => i1 == i2,
                  items: (filter, infiniteScrollProps) => PopupMode.values,
                  decoratorProps: DropDownDecoratorProps(
                    decoration: InputDecoration(
                      labelText: 'Examples for: ',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  popupProps: PopupProps.menu(fit: FlexFit.loose, constraints: BoxConstraints()),
                ),
              ),
              Padding(padding: EdgeInsets.only(right: 16)),
              Expanded(
                child: DropdownSearch<UiMode>(
                  key: dropDownUiModeKey,
                  selectedItem: UiMode.material,
                  itemAsString: (item) => item.name,
                  compareFn: (i1, i2) => i1 == i2,
                  items: (filter, infiniteScrollProps) => UiMode.values,
                  decoratorProps: DropDownDecoratorProps(
                    decoration: InputDecoration(
                      labelText: 'ui mode: ',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  popupProps: PopupProps.menu(fit: FlexFit.loose, constraints: BoxConstraints()),
                ),
              ),
              Padding(padding: EdgeInsets.only(right: 16)),
              FilledButton(
                onPressed: () {
                  final uiMode = dropDownUiModeKey.currentState?.getSelectedItem;
                  switch (dropDownKey.currentState?.getSelectedItem) {
                    case PopupMode.menu:
                      if (uiMode == UiMode.adaptive) {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => AdaptiveMenuExamplesPage()));
                      } else if (uiMode == UiMode.cupertino) {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => CupertinoMenuExamplesPage()));
                      } else {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => MaterialMenuExamplesPage()));
                      }
                      break;
                    case PopupMode.modalBottomSheet:
                      if (uiMode == UiMode.adaptive) {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => AdaptiveModalsExamplesPage()));
                      } else if (uiMode == UiMode.cupertino) {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => CupertinoModalsExamplesPage()));
                      } else {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => MaterialModalsExamplesPage()));
                      }
                      break;
                    case PopupMode.bottomSheet:
                      if (uiMode == UiMode.adaptive) {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => AdaptiveBottomSheetExamplesPage()));
                      } else if (uiMode == UiMode.cupertino) {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => CupertinoBottomSheetExamplesPage()));
                      } else {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => MaterialBottomSheetExamplesPage()));
                      }
                      break;
                    case PopupMode.dialog:
                      if (uiMode == UiMode.adaptive) {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => AdaptiveDialogExamplesPage()));
                      } else if (uiMode == UiMode.cupertino) {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => CupertinoDialogExamplesPage()));
                      } else {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => MaterialDialogExamplesPage()));
                      }
                      break;
                    case PopupMode.autocomplete:
                      if (uiMode == UiMode.adaptive) {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => AdaptiveAutocompleteExamplesPage()));
                      } else if (uiMode == UiMode.cupertino) {
                        Navigator.push(
                            context, MaterialPageRoute(builder: (context) => CupertinoAutocompleteExamplesPage()));
                      } else {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => MaterialAutocompleteExamplesPage()));
                      }
                      break;
                    case null:
                      throw UnimplementedError();
                  }
                },
                child: Text("Go"),
              )
            ],
          ),
          Padding(padding: EdgeInsets.all(8)),
          RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 14.0, color: Colors.black),
              children: [
                TextSpan(text: 'we used '),
                TextSpan(text: 'fit: FlexFit.loose', style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: ' and '),
                TextSpan(text: 'constraints: BoxConstraints() ', style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: 'to fit the height of menu automatically to the length of items'),
              ],
            ),
          ),
          Padding(padding: EdgeInsets.only(top: 20)),
          Text(
            'DropdownSearch Anatomy',
            style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
            textAlign: TextAlign.center,
          ),
          Image.asset('assets/images/anatomy.png', alignment: Alignment.topCenter, height: 1024)
        ],
      ),
    );
  }
}
