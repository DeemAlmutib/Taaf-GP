class UserModel {
   final String id;
    final String phone;
    






const UserModel({
  required this.id,
  required this.phone,
});



toJson(){
  return{
    "Id":id,
    "Phone":phone,
  };
}
}


