import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user_model.dart';

class UserRepository {
  //set a connection to the firestore with Users collection (table)
  final CollectionReference _userCollectionRef =
      FirebaseFirestore.instance.collection("Users");

//to add user to the firestore
// accept user model
  Future<void> addUserToFireStore(UserModel userModel) async {
    Map<dynamic, dynamic> map = userModel.toJson();
    map['created_at'] = DateTime.now().toString();

    return await _userCollectionRef.doc(userModel.id).set(map);
  }

/*
  to update user to the firestore 
  accept : 
    id ,
    name,
    phone,
    birthDate,
    gender,

*/
  Future<void> updateUserInfoFireStore({required String id, required String name, required String phone, required String phoneCode
     ,required  String birthDate, required String gender}) async {
    return await _userCollectionRef.doc(id).update({
      "name": name,
      "phone": phone,
      "phoneCode":phoneCode,
      "birthDate": birthDate,
      "gender": gender
    });
  }

/*
to get single  user 
accept : 
UserID
 */
  Future<List<QueryDocumentSnapshot>> getUser(String? UserID) async {
    var response =
        await _userCollectionRef.where('id', isEqualTo: UserID).get();
    return response.docs;
  }

  /*
to get single  user 
accept : 
UserID
 */
  Future<List<QueryDocumentSnapshot>> getUserByPhoneNumber(String? phoneNumber , String phoneCode) async {
    var response =
        await _userCollectionRef.where('phone', isEqualTo: phoneNumber).where('phoneCode',isEqualTo: phoneCode).get();
    return response.docs;
  }

/*
  to  get all users 
  with ordring them descending based on created_at date 
 */
  Future<List<QueryDocumentSnapshot>> getUsers() async {
    var response =
        await _userCollectionRef.orderBy("created_at", descending: true).get();
    return response.docs;
  }

/*
to update sengle property in users collection (table)

  usage will be like 
  updateUserFireStore("sd45s1d2s54s1","name","roba");
  here we will update the property name only .
 */
  Future<void> updateUserFireStore(
      {String? userID, String? property, dynamic value}) async {
    return await _userCollectionRef
        .doc(userID)
        .update({property.toString(): value});
  }
}
