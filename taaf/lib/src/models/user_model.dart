class UserModel {
  String? id;
  String? phone;
  String? name;
  String? birthDate;
  String? gender;
  String? created_at = "";
  String? phoneCode;

  // const UserModel(
  //   String s,
  //   String trim, {
  //   this.id,
  //   required this.phone,
  // });
  UserModel(
      {this.id,
      this.phone,
      this.name,
      this.birthDate,
      this.gender,
      this.created_at,
      this.phoneCode});

  UserModel.fromJson(Map<dynamic, dynamic> map) {
    if (map == null) {
      return;
    }

    id = map['id'];
    phone = map['phone'];
    name = map['name'];
    birthDate = map['birthDate'];
    gender = map['gender'];
    created_at = map['created_at'] ?? "";
    phoneCode = map['phoneCode'];
  }

  toJson() {
    return {
      "id": id,
      "Phone": phone,
      "name": name,
      "birthDate": birthDate,
      "gender": gender,
      "created_at": created_at,
      "phoneCode": phoneCode
    };
  }
}
