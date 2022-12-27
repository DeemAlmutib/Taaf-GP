import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
  }

  String getPhoneWithCountryCode(String phone) {
    this.phoneNumber = phone;
    return this.countryPhoneCode + this.phoneNumber;
  }

  Future<bool> phoneAuthentication(String phone, BuildContext context) async {
    bool allGood = true;
    String phoneNumber = getPhoneWithCountryCode(phone);
    // ScaffoldMessenger.of(context).showSnackBar(
    //   const SnackBar(
    //     content: Text('A SnackBar has been shown.'),
    //   ),
    // );
    return await _auth
        .verifyPhoneNumber(
            phoneNumber: phoneNumber,
            timeout: const Duration(minutes: 1),
            verificationCompleted: (credentials) async {
              await _auth.signInWithCredential(credentials);
              allGood = true;
            },
            verificationFailed: (e) {
              if (e.code == "invalid=phone=number") {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                        "رقم الهاتف المدخل غير صحيح يرجى التاكد من رقم الهاتف والمحاولة مره اخرى ",
                        style: TextStyle(fontSize: 18),
                        textAlign: TextAlign.right),
                  ),
                );
              } else {
                print(e);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("حصل شيء خاطئ . يرجى المحاولة مره اخرى",
                        style: TextStyle(fontSize: 18),
                        textAlign: TextAlign.right),
                  ),
                );
              }
              allGood = false;
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

    // return allGood;
  }

  Future<bool> verfiyOTP(String otp, BuildContext context) async {
    try {
      UserCredential credential = await _auth.signInWithCredential(
          PhoneAuthProvider.credential(
              verificationId: this.verificationId, smsCode: otp));
      if (credential != null) {
        await saveUserData(credential);
        return true;
      } else {
        return false;
      }
      // return credential.user != null ? true : false;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-verification-id') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم إرسال الرمز الى رقم الجوال المدخل ',
                style: TextStyle(fontSize: 18), textAlign: TextAlign.right),
          ),
        );
      } else if (e.code == 'invalid-verification-code') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('رمز التحقق المدخل غير صحيح يرجى إعادة المحاولة ',
                style: TextStyle(fontSize: 18), textAlign: TextAlign.right),
          ),
        );
      } else if (e.code == 'session-expired') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('please ask for new code your session expired'),
          ),
        );
      }
    } catch (e) {
      print(e);
    }
    return false;
  }

/*
  function to Save the user data into firebase 
  accept user Credential
 */
  Future<void> saveUserData(UserCredential credential) async {
    //get the user based on his/her ID
    await userRepo.getUser(credential.user!.uid).then((value) async {
      //check if the returned data from firebase is = 0 that means this user is not inserted in our table
      if (value.length == 0) {
        //insert the new user into our table (Users)
        await userRepo.addUserToFireStore(UserModel(
            id: credential.user!.uid, phone: credential.user!.phoneNumber));
      } else {
        // if i want to update somthing in user table put it here .
      }
    });
  }
}
