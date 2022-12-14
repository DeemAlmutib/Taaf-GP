import 'package:firebase_auth/firebase_auth.dart';

import '../base/showToast.dart';

class AuthController {
  final _auth = FirebaseAuth.instance;

  String verificationId = "";
  String countryPhoneCode = "";
  String phoneNumber = "";

  String getPhoneWithCountryCode(String phone) {
    this.phoneNumber = phone;
    return this.countryPhoneCode + this.phoneNumber;
  }

  Future<bool> phoneAuthentication(String phone) async {
    bool allGood = true;
    String phoneNumber = getPhoneWithCountryCode(phone);
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
                AppShowToast(
                    text:
                        "رقم الهاتف الذي ادخلته غير صحيح يرجى التاكد من رقم الهاتف والمحاولة مره اخرى ");
              } else {
                AppShowToast(text: "حصل شيء خاطئ . يرجى المحاولة مره اخرى");
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

  Future<bool> verfiyOTP(String otp) async {
    try {
      UserCredential credential = await _auth.signInWithCredential(
          PhoneAuthProvider.credential(
              verificationId: this.verificationId, smsCode: otp));
      return credential.user != null ? true : false;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-verification-id') {
        AppShowToast(text: "please check your phone number and back again");
      } else if (e.code == 'invalid-verification-code') {
        AppShowToast(
            text:
                "the verification code is invalid pleas be re-enter valid code ");
      } else if (e.code == 'session-expired') {
        AppShowToast(text: "please ask for new code your session expired");
      }
    } catch (e) {
      print(e);
    }
    return false;
  }
}
