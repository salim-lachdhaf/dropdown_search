import 'package:dropdown_search/dropdown_search.dart';
import 'package:example/bottom_sheets.dart';
import 'package:example/dialogs.dart';
import 'package:example/menus.dart';
import 'package:example/modals.dart';
import 'package:flutter/material.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'dropdownSearch Demo',
      //enable this line if you want test Dark Mode
      //theme: ThemeData.dark(),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final dropDownKey = GlobalKey<DropdownSearchState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('examples mode')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: DropdownSearch(
                    key: dropDownKey,
                    selectedItem: "Menu",
                    items: (filter, infiniteScrollProps) => ["Menu", "Dialog", "Modal", "BottomSheet"],
                    dropdownDecoratorProps: DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                        labelText: 'Examples for: ',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    popupProps: PopupProps.menu(fit: FlexFit.loose, constraints: BoxConstraints()),
                  ),
                ),
                Padding(padding: EdgeInsets.only(right: 16)),
                FilledButton(
                  onPressed: () {
                    switch (dropDownKey.currentState?.getSelectedItem) {
                      case 'Menu':
                        Navigator.push(context, MaterialPageRoute(builder: (context) => MenuExamplesPage()));
                        break;
                      case 'Modal':
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ModalsExamplesPage()));
                        break;
                      case 'BottomSheet':
                        Navigator.push(context, MaterialPageRoute(builder: (context) => BottomSheetExamplesPage()));
                        break;
                      case 'Dialog':
                        Navigator.push(context, MaterialPageRoute(builder: (context) => DialogExamplesPage()));
                        break;
                    }
                  },
                  child: Text("Go"),
                )
              ],
            ),
            Padding(padding: EdgeInsets.all(8)),
            RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 14.0,
                  color: Colors.black,
                ),
                children: [
                  TextSpan(text: 'we used '),
                  TextSpan(text: 'fit: FlexFit.loose and '),
                  TextSpan(text: 'constraints: BoxConstraints() '),
                  TextSpan(text: 'to fit the height of mebu automatically to the length of items'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
