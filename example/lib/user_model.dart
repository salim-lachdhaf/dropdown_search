//Created on http://app.quicktype.io/

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
      createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
      name: json["name"],
      avatar: json["avatar"],
    );
  }

  static List<UserModel> fromJsonList(List list) {
    if (list == null) return null;
    return list.map((item) => UserModel.fromJson(item)).toList();
  }



  //this method will prevent the override of toString
  static String userAsString(UserModel userModel){
    return '#${userModel.id} ${userModel.name}';
  }

  //this method will prevent the override of toString
  static bool userFilterByCreationDate(UserModel userModel, String filter){
    return userModel?.createdAt?.toString()?.contains(filter);
  }


  @override
  String toString() => name;

  @override
  operator ==(o) => o is UserModel && o.id == id;

  @override
  int get hashCode => id.hashCode^name.hashCode^createdAt.hashCode;

}
