import 'package:flutter/material.dart';
import 'package:taaf/src/controllers/AuthController.dart';

import '../../models/user_model.dart';
import '../../repository/user_repository.dart';

class SignUpController {
  List<DropdownMenuItem<String>> genderItems = [];
  TextEditingController nameEditingController = TextEditingController();
  TextEditingController phoneEditingController = TextEditingController();
  TextEditingController birthDateEditingController = TextEditingController();
  TextEditingController otpEditingController = TextEditingController();
  String gender = "انثى";
  String phoneCode = "+966";
  bool isLoading = false;
  bool isSendOtpLoading = false;
  bool isOTPVerficationLoading = false;
  int verficationDialogStep = 0;
  late UserRepository userRepo;
  late AuthController authController;

  late UserModel userModel;

  SignUpController() {
    userRepo = UserRepository();
    authController = AuthController();
    userModel = UserModel();
    authController = AuthController();
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
  }

  Future<bool> addUser(BuildContext context) async {
    try {
      await userRepo.addUserToFireStore(userModel);

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<String> validateSignUpForm(BuildContext context) async {
    String validationMessage = "";
    if (userModel.name!.isEmpty) {
      validationMessage += "الاسم , ";
    }
    if (userModel.phoneCode!.isEmpty || userModel.phone!.isEmpty) {
      validationMessage += "رقم الهاتف , ";
    }
    if (userModel.birthDate!.isEmpty) {
      validationMessage += "تاريخ الميلاد , ";
    }
    if (userModel.gender!.isEmpty) {
      validationMessage += " الجنس , ";
    }

    if (userModel.name!.isEmpty ||
        userModel.phoneCode!.isEmpty ||
        userModel.phone!.isEmpty ||
        userModel.gender!.isEmpty ||
        userModel.birthDate!.isEmpty) {
      validationMessage = "يرجى ملء هذه الحقول  " + validationMessage;
      return validationMessage;
    }
    if (userModel.phone!.length != 9) {
      return "رقم الهاتف يجب ان يتكون من 9 ارقام ";
    }
    if (userModel.name!.length < 2 || userModel.name!.length > 20) {
      return "اسم المستخدم يجب أن لا يقل عن حرفين وأن لا يتجاوز عن 20 حرف ";
    }
    if (await userRepo.checkIfUserExisset(
        userModel.phone!, userModel.phoneCode!)) {
      return "رقم الهاتف المدخل  مستخدم مسبقًا ";
    }
    authController.countryPhoneCode = userModel.phoneCode!;
    if (!await authController.phoneAuthentication(userModel.phone!, context,
        userModel: userModel)) {
      return " ";
    }
    return "";
  }

  Future<bool> verfiyOTP(
      String otp, BuildContext context, UserModel userModel) async {
    return await authController.verfiyOTP(otp, context, userModel: userModel);
  }
}





