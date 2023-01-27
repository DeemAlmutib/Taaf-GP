import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:taaf/src/helper/userSharedPreferences.dart';
import 'package:taaf/src/models/user_model.dart';
import 'package:taaf/src/repository/user_repository.dart';

import '../base/showToast.dart';

class AuthController {
  final _auth = FirebaseAuth.instance;
  late UserRepository userRepo;

  String verificationId = "";
  String countryPhoneCode = "";
  String phoneNumber = "";

  AuthController() {
    userRepo = UserRepository();
    verificationId = "";
  }

  String getPhoneWithCountryCode(String phone) {
    this.phoneNumber = phone;
    return this.countryPhoneCode + this.phoneNumber;
  }

  Future<bool> phoneAuthentication(String phone, BuildContext context,
      {UserModel? userModel}) async {
    bool allGood = true;
    String phoneNumber = getPhoneWithCountryCode(phone);

    if (!await userRepo.checkIfUserExisset(phone, this.countryPhoneCode) &&
        userModel == null) {
      return appShowSnackBar(
              context,
              " رقم الهاتف الذي قمت بادخاله غير مسجل , يرجى التاكد من صحة الرقم او القيام بتسجيل حساب ",
              true)
          .then((value) {
        return false;
      });
    }
    // return true;
    return await _auth
        .verifyPhoneNumber(
            phoneNumber: phoneNumber,
            timeout: const Duration(minutes: 1),
            verificationCompleted: (credentials) async {
              if (userModel == null) {
                await _auth.signInWithCredential(credentials);
              }
              allGood = true;
            },
            verificationFailed: (e) {
              if (e.code == "invalid=phone=number") {
                appShowSnackBar(
                        context,
                        "رقم الهاتف المدخل غير صحيح يرجى التاكد من رقم الهاتف والمحاولة مره اخرى ",
                        true)
                    .then((value) {
                  allGood = false;
                });
              } else {
                appShowSnackBar(
                        context, "حصل شيء خاطئ . يرجى المحاولة مره اخرى", true)
                    .then((value) {
                  allGood = false;
                });
              }
              print(e.code);
            },
            codeSent: (String verificationId, int? resendToken) {
              this.verificationId = verificationId;
              allGood = true;
            },
            codeAutoRetrievalTimeout: (verificationId) {
              this.verificationId = verificationId;
              allGood = true;
            })
        .then((value) {
      return allGood;
    });

    // return allGood;
  }

  Future<bool> verfiyOTP(String otp, BuildContext context,
      {UserModel? userModel}) async {
    bool allGood = false;
    print(otp);
    print(this.verificationId);

    try {
      UserCredential credential = await _auth.signInWithCredential(
          PhoneAuthProvider.credential(
              verificationId: this.verificationId, smsCode: otp));
      if (credential != null) {
        await saveUserData(credential, userModel: userModel);
        allGood = true;
      } else {
        allGood = false;
      }
      // return credential.user != null ? true : false;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-verification-id') {
        appShowSnackBar(
                context, 'يرجى التحقق من رقم الهاتف dوالمحالة مره اخرى', true)
            .then((value) {
          allGood = false;
        });
      } else if (e.code == 'invalid-verification-code') {
        appShowSnackBar(context,
                'رمز التحقق المدخل غير صحيح يرجى إعادة المحاولة ', true)
            .then((value) {
          allGood = false;
        });
      } else if (e.code == 'session-expired') {
        appShowSnackBar(context,
                "انتهت الجلسة الخاصة بك : يرجى طلب رمز تحقق جديد", true)
            .then((value) {
          allGood = false;
        });
      }
    } catch (e) {
      print(e);
    }
    return allGood;
  }

/*
  function to Save the user data into firebase 
  accept user Credential
 */
  Future<void> saveUserData(UserCredential credential,
      {UserModel? userModel}) async {
    //get the user based on his/her ID
    await userRepo.getUser(credential.user!.uid).then((value) async {
      //check if the returned data from firebase is = 0 that means this user is not inserted in our table

      if (value.length == 0) {
        if (userModel == null) {
          print("model null ");
          //insert the new user into our table (Users)
          await userRepo.addUserToFireStore(UserModel(
              id: credential.user!.uid,
              phone: phoneNumber,
              phoneCode: countryPhoneCode,
              name: "",
              gender: "",
              birthDate: ""));
        } else {
          //insert the new user into our table (Users)
          await userRepo.addUserToFireStore(UserModel(
              id: credential.user!.uid,
              phone: userModel.phone,
              phoneCode: userModel.phoneCode,
              name: userModel.name,
              gender: userModel.gender,
              birthDate: userModel.birthDate));
        }
      } else {
        // if i want to update somthing in user table put it here .
      }
      // save user id in sharedpreferences to use it in login screen or any screen related to user
      await UserSharedPreferences.setUserID(credential.user!.uid);
    });
  }

  Future<bool> logout() async {
    if (_auth.currentUser != null) {
      await _auth.signOut();
      await UserSharedPreferences.deleteData();
      return true;
    } else {
      await UserSharedPreferences.deleteData();
      return true;
    }
  }

  Future<bool> updateUserAuthontication(
      String phone, BuildContext context) async {
    bool allGood = true;
    String phoneNumber = getPhoneWithCountryCode(phone);

    return await _auth
        .verifyPhoneNumber(
            phoneNumber: phoneNumber,
            timeout: const Duration(minutes: 1),
            verificationCompleted: (credentials) async {
              User user = _auth.currentUser!;
              await user.updatePhoneNumber(credentials);
              // await _auth.signInWithCredential(credentials);
              allGood = true;
            },
            verificationFailed: (e) {
              if (e.code == "invalid=phone=number") {
                appShowSnackBar(
                        context,
                        "رقم الهاتف المدخل غير صحيح يرجى التاكد من رقم الهاتف والمحاولة مره اخرى ",
                        true)
                    .then((value) {
                  allGood = false;
                });
              } else {
                appShowSnackBar(
                        context, "حصل شيء خاطئ . يرجى المحاولة مره اخرى", true)
                    .then((value) {
                  allGood = false;
                });
              }
              // print(e.code);
            },
            codeSent: (String verificationId, int? resendToken) {
              this.verificationId = verificationId;
              allGood = true;
            },
            codeAutoRetrievalTimeout: (verificationId) {
              this.verificationId = verificationId;
              allGood = true;
            })
        .then((value) {
      return allGood;
    });
  }

  Future<bool> verfiyOtpForUpdate(String otp, BuildContext context) async {
    bool allGood = false;

    try {
      User user = _auth.currentUser!;
      PhoneAuthCredential phoneCredential = await PhoneAuthProvider.credential(
          verificationId: this.verificationId, smsCode: otp);
      await user.updatePhoneNumber(phoneCredential).then((value) async {
        await userRepo.updateUserFireStore(
            userID: _auth.currentUser!.uid,
            property: "phone",
            value: phoneNumber);
        await userRepo.updateUserFireStore(
            userID: _auth.currentUser!.uid,
            property: "phoneCode",
            value: countryPhoneCode);
        allGood = true;
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-verification-id') {
        appShowSnackBar(context, 'تم إرسال الرمز الى رقم الجوال المدخل ', true)
            .then((value) {
          allGood = false;
        });
      } else if (e.code == 'invalid-verification-code') {
        appShowSnackBar(context,
                'رمز التحقق المدخل غير صحيح يرجى إعادة المحاولة ', true)
            .then((value) {
          allGood = false;
        });
      } else if (e.code == 'session-expired') {
        appShowSnackBar(context,
                "انتهت الجلسة الخاصة بك : يرجى طلب رمز تحقق جديد", true)
            .then((value) {
          allGood = false;
        });
      }
    } catch (e) {
      print(e);
      allGood = false;
    }

    return allGood;
  }

  Future<bool> checkPhoneNumberAvailability(
      {required String phoneNumber, required String phoneCode}) async {
    // initialize new user object
    UserModel newUserModel = UserModel();
    // get user data from firestore throw the repo
    return await userRepo
        .getUserByPhoneNumber(phoneNumber, phoneCode)
        .then((value) async {
      //check if there is any user with this phone number
      if (value.length > 0) {
        // loop throw the result to get the user data
        for (int i = 0; i < value.length; i++) {
          //extract data from the result  as json
          var user = value[i].data() as Map<String, dynamic>;
          // convert json data to user object
          newUserModel = UserModel.fromJson(user);
          //check if the user with the phone number is the same user who want to change thats mean it's okay return true
          // if the user is not the same user who want to change the number thats mean the number is not available
          if (newUserModel.id == _auth.currentUser?.uid) {
            return true;
          } else {
            return false;
          }
        }
      }
      // here we will return true thats mean it's available , becuase we don't have any user with this phoneNumber
      return true;
    });

    // return the user data
    //TODO: after get the data from this function i have to check if there is an id or not if the id = null or empty thats mean that we didn't get the data of the user
    // return newUserModel;
  }
}
