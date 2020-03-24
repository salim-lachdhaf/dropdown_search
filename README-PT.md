[![Buy Me A Coffee](https://img.shields.io/badge/Donate-Buy%20Me%20A%20Coffee-yellow.svg)](https://www.buymeacoffee.com/deivao)

# FindDropdown package - [[view english](https://github.com/davidsdearaujo/find_dropdown/blob/master/README.md)]

Simples e robusto FindDropdown com recurso de busca entre os itens, possibilitando utilizar uma lista de itens offline ou uma URL para filtragem, com fácil customização.

![](https://github.com/davidsdearaujo/find_dropdown/blob/master/screenshots/Screenshot_4.png?raw=true)

<img src="https://github.com/davidsdearaujo/find_dropdown/blob/master/screenshots/GIF_Simple.gif?raw=true" width="49.5%" /> <img src="https://github.com/davidsdearaujo/find_dropdown/blob/master/screenshots/GIF_Custom_Layout.gif?raw=true" width="49.5%" />

## ATENÇÃO
Se você utiliza o rxdart em seu projeto em uma versão inferior a 0.23.x, utilize a versão `0.1.7+1` desse package.
Caso contrário, pode utilizar a versão mais atual!

## packages.yaml
```yaml
find_dropdown: <lastest version>
```

## Import
```dart
import 'package:find_dropdown/find_dropdown.dart';
```

## Implementação simples
```dart
FindDropdown(
  items: ["Brasil", "Itália", "Estados Unidos", "Canadá"],
  label: "País",
  onChanged: (String item) => print(item),
  selectedItem: "Brasil",
);
```

## Validação
```dart
FindDropdown(
  items: ["Brasil", "Itália", "Estados Unidos", "Canadá"],
  label: "País",
  onChanged: (String item) => print(item),
  selectedItem: "Brasil",
  validate: (String item) {
    if (item == null)
      return "Campo obrigatório";
    else if (item == "Brasil")
      return "Item inválido";
    else
      return null; //retorno null para "sem erro"
  },
);
```

## Implementação com endpoint (utilizando o [package Dio](https://pub.dev/packages/dio))
```dart
FindDropdown<UserModel>(
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
## Customização de layout
É possível customizar o layout do FindDropdown e de seus itens. [EXEMPLO](https://github.com/davidsdearaujo/find_dropdown/tree/master/example#custom-layout-endpoint-example)

Para **customizar o FindDropdown**, temos a propriedade `dropdownBuilder`, que recebe uma função com os parâmetros:
- `BuildContext context`: Contexto do item atual;
- `T item`: Item atual, onde **T** é o tipo passado no construtor do FindDropdown.

Para **customizar os itens**, temos a propriedade `dropdownItemBuilder`, que recebe uma função com os parâmetros:
- `BuildContext context`: Contexto do item atual;
- `T item`: Item atual, onde **T** é o tipo passado no construtor do FindDropdown.
- `bool isSelected`: Boolean que informa se o item atual está selecionado.

# Atenção
Para usar um modelo como item no dropdown, é necessário implementar os métodos **toString**, **equals** e **hashcode**, conforme mostrado abaixo:

```dart
class UserModel {
  final String id;
  final DateTime createdAt;
  final String name;
  final String avatar;

  UserModel({this.id, this.createdAt, this.name, this.avatar});

  @override
  String toString() => name;

  @override
  operator ==(o) => o is UserModel && o.id == id;

  @override
  int get hashCode => id.hashCode^name.hashCode^createdAt.hashCode;

}
```


# [Ver mais Exemplos](https://github.com/davidsdearaujo/find_dropdown/tree/master/example)
