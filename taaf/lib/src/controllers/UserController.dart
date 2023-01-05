import 'package:flutter/cupertino.dart';
import 'package:taaf/src/controllers/AuthController.dart';
import 'package:taaf/src/models/user_model.dart';
import 'package:taaf/src/repository/user_repository.dart';

class UserController {
  late UserRepository userRepo;

  List<UserModel> _usersList = [];
  List<UserModel> get usersList => _usersList;

  late UserModel userModel;

  UserController() {
    userRepo = UserRepository();
    userModel = UserModel();
  }

  Future<bool> addUser(BuildContext context) async {
    try {
      await userRepo.addUserToFireStore(userModel);

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateUser() async {
    try {
      print(userModel.toJson());
      await userRepo.updateUserInfoFireStore(
          id: userModel.id!,
          phone: userModel.phone!,
          phoneCode: userModel.phoneCode!,
          name: userModel.name!,
          birthDate: userModel.birthDate!,
          gender: userModel.gender!);

      return true;
    } catch (e) {
      print('********************************');
      print(e.toString());
      return false;
    }
  }

  Future<UserModel> getUser(String id) async {
    // initialize new user object
    UserModel newUserModel = UserModel();
    // get user data from firestore throw the repo
    await userRepo.getUser(id).then((value) async {
      // loop throw the result to get the user data
      for (int i = 0; i < value.length; i++) {
        //extract data from the result  as json
        var user = value[i].data() as Map<String, dynamic>;
        // convert json data to user object
        newUserModel = UserModel.fromJson(user);
        break;
      } 
    });
    // return the user data
    //TODO: after get the data from this function i have to check if there is an id or not if the id = null or empty thats mean that we didn't get the data of the user
    return newUserModel;
  }

  Future<void> getUsers() async {
    await userRepo.getUsers().then((value) {
      _usersList = [];
      for (int i = 0; i < value.length; i++) {
        var userInfo = value[i].data() as Map<String, dynamic>;
        _usersList.add(UserModel.fromJson(userInfo));
      }
    });
  }

  Future<bool> updateUserProperty(
      {required BuildContext context,
      required String UserID,
      required String property,
      required dynamic value}) async {
    try {
      await userRepo.updateUserFireStore(
        userID: UserID,
        property: property,
        value: value,
      );

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> userLogout() async {
    return await AuthController().logout();
  }
}
