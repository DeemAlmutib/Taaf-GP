import 'package:flutter/material.dart';
import 'package:taaf/src/controllers/UserController.dart';
import 'package:taaf/src/helper/userSharedPreferences.dart';
import 'package:taaf/src/models/user_model.dart';

class EditProfileController {
  List<DropdownMenuItem<String>> genderItems = [];
  TextEditingController nameEditingController = TextEditingController();
  TextEditingController phoneEditingController = TextEditingController();
  TextEditingController birthDateEditingController = TextEditingController();
  TextEditingController otpEditingController = TextEditingController();
  String gender = "";
  String phoneCode = "+966";

  late UserController userController;
  bool isProfileLoading = false;
  bool isEditProfileLoading = false;
  bool isSendOtpLoading = false;
  bool isOTPVerficationLoading = false;
  int verficationDialogStep = 0;

  late UserModel userModel = UserModel();

  EditProfileController() {
    isProfileLoading = true;

    genderItems.add(DropdownMenuItem(
      child: Text(
        'انثى',
        style: TextStyle(fontSize: 20),
      ),
      value: 'انثى',
    ));
    genderItems.add(DropdownMenuItem(
      child: Text(
        'ذكر',
        style: TextStyle(fontSize: 20),
      ),
      value: 'ذكر',
    ));
    userController = UserController();
  }

  Future<UserModel> getProfileData() async {
    UserModel user =
        await userController.getUser(UserSharedPreferences.getUserID()!);
    userModel = user;
    return user;
  }

  Future<bool> updateUserData() async {
    userController.userModel.id = userModel.id;
    userController.userModel.name = nameEditingController.text.trim();
    userController.userModel.phone = phoneEditingController.text.trim();
    userController.userModel.birthDate = birthDateEditingController.text.trim();
    userController.userModel.phoneCode = phoneCode;
    userController.userModel.gender = gender;
    return await userController.updateUser();
  }

  bool checkChanges() {
    
    if (userModel.name != nameEditingController.text ||
        userModel.phone != phoneEditingController.text ||
        userModel.birthDate != birthDateEditingController.text ||
        userModel.phoneCode != phoneCode ||
        userModel.gender != gender) {
      return true;
    } else {
      return false;
    }
  }
}
