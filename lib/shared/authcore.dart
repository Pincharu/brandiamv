import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/user_model.dart';
import 'header.dart';
import 'loading.dart';
import 'snackbar.dart';
import '../pages/client/home/home_page.dart';

class AuthCore extends GetxController {
  TextEditingController nameTxt = TextEditingController();
  TextEditingController bussinessNameTxt = TextEditingController();
  TextEditingController emailTxt = TextEditingController();
  TextEditingController passwordTxt = TextEditingController();
  TextEditingController addressTxt = TextEditingController();
  TextEditingController referralTxt = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  Rxn<User> firebaseUser = Rxn<User>();
  Rxn<UserModel> firestoreUser = Rxn<UserModel>();
  //final RxBool admin = false.obs;
  //final RxBool subscribed = false.obs;

  @override
  void onReady() async {
    //run every time auth state changes
    firebaseUser.bindStream(user);
    if (_auth.currentUser != null) {
      firestoreUser.bindStream(userStream(_auth.currentUser!.uid));
    }

    super.onReady();
  }

  Stream<UserModel> userStream(String uid) {
    return _db
        .doc('users/$uid')
        .snapshots()
        .map((snapshot) => UserModel.fromMap(snapshot.data()!, snapshot.id));
  }

  // @override
  // void onClose() {
  //   nameTxt.dispose();
  //   emailTxt.dispose();
  //   passwordTxt.dispose();
  //   super.onClose();
  // }

  void resetPassword(String email) {
    try {
      _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      Get.log(e.toString());
    }
    sucessSnackbar('Email Reset Send', 'Check your email to reset Password');
  }

  // Firebase user one-time fetch
  String get getUser => _auth.currentUser!.uid;

  // Firebase user a realtime stream
  Stream<User?> get user => _auth.authStateChanges();

  //Method to handle user sign in using email and password
  signInWithEmailAndPassword() async {
    showLoadingIndicator();
    try {
      await _auth.signInWithEmailAndPassword(
          email: emailTxt.text.trim(), password: passwordTxt.text.trim());
      emailTxt.clear();
      passwordTxt.clear();
      hideLoadingIndicator();

      Get.back();
      final FirebaseAuth auth = FirebaseAuth.instance;
      await Future.delayed(const Duration(milliseconds: 300), () async {
        if (auth.currentUser != null) {
          onReady();
        }
      });

      await Future.delayed(const Duration(seconds: 2), () async {
        if (auth.currentUser != null) {
          onReady();
        }
      });
      // Get.offAll(const HomePage());
    } catch (error) {
      hideLoadingIndicator();
      errorSnackbar('Sign in Error', 'Error Sigining in');
    }

    emailTxt.text = '';
    passwordTxt.text = '';
  }

  Future<bool> verifedRefferal() async {
    bool found = false;
    await FirebaseFirestore.instance
        .collection('users')
        .where('referral', isEqualTo: referralTxt.text)
        .get()
        .then((event) {
      if (event.docs.isNotEmpty) {
        found = true;
      } else {
        found = false;
      }
    }).catchError((e) {
      Get.log(e);
      found = false;
    });

    return found;
  }

  resendEmailVerify() async {
    await firebaseUser.value!.sendEmailVerification();
    sucessSnackbar("Email Resent", "Check all email folders including spam");
  }

  // User registration using email and password
  registerWithEmailAndPassword() async {
    if (emailTxt.text != '' &&
        passwordTxt.text != '' &&
        nameTxt.text != '' &&
        phoneTxt.text != '') {
      showLoadingIndicator();
      try {
        await _auth
            .createUserWithEmailAndPassword(email: emailTxt.text, password: passwordTxt.text)
            .then((result) async {
          await result.user!.sendEmailVerification();

          final path = 'users/${result.user!.uid}';
          final ref = FirebaseFirestore.instance.doc(path);
          await ref.set({
            'id': result.user!.uid,
            'email': result.user!.email,
            'name': nameTxt.text,
            'password': passwordTxt.text,
            'phone': phoneTxt.text,
            'registerDate': DateTime.now(),
            'address': addressTxt.text,
            'device': 'web',
            'cart': 0,
          });

          emailTxt.clear();
          passwordTxt.clear();
          nameTxt.clear();
          phoneTxt.clear();

          hideLoadingIndicator();
        });
      } on FirebaseAuthException catch (error) {
        hideLoadingIndicator();
        errorSnackbar("Signup Error", error.message!);
      }

      Get.offAll(() => const HomePage());
    } else {
      errorSnackbar("Empty Feilds", "Please fill all the feilds");
    }
  }

  TextEditingController smsTxt = TextEditingController();
  TextEditingController phoneTxt = TextEditingController();
  final RxBool codeSend = false.obs;

  String? cVerificationId;

  Future<void> phoneSignIn({required String phoneNumber}) async {
    showLoadingIndicator();
    await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: _onVerificationCompleted,
        verificationFailed: _onVerificationFailed,
        codeSent: _onCodeSent,
        codeAutoRetrievalTimeout: _onCodeTimeout);
  }

  _onVerificationCompleted(PhoneAuthCredential authCredential) async {
    // print("verification completed ${authCredential.smsCode}");
    User? user = FirebaseAuth.instance.currentUser;
    smsTxt.text = authCredential.smsCode!;

    if (authCredential.smsCode != null) {
      try {
        await user!.linkWithCredential(authCredential);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'provider-already-linked') {
          await _auth.signInWithCredential(authCredential);
        }
      }
      Get.offAll(() => const HomePage());
    }
  }

  _onVerificationFailed(FirebaseAuthException exception) {
    if (exception.code == 'invalid-phone-number') {
      hideLoadingIndicator();
      errorSnackbar('Invalid Phone number', 'The provided phone number is not valid');
    } else {
      hideLoadingIndicator();
      errorSnackbar("Error sigining in", exception.code);
    }
  }

  _onCodeSent(String verificationId, int? forceResendingToken) {
    cVerificationId = verificationId;
    codeSend.value = true;
    hideLoadingIndicator();
  }

  _onCodeTimeout(String timeout) {
    return null;
  }

  verifyCode() async {
    showLoadingIndicator();
    if (smsTxt.text != '' && cVerificationId != null) {
      PhoneAuthCredential credential =
          PhoneAuthProvider.credential(verificationId: cVerificationId!, smsCode: smsTxt.text);

      await _auth.signInWithCredential(credential);

      final path = 'users/${_auth.currentUser!.uid}';
      DocumentReference userRef = FirebaseFirestore.instance.doc(path);

      FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(userRef);

        if (!snapshot.exists) {
          transaction.set(userRef, {
            'name': nameTxt.text,
            'bussinessName': bussinessNameTxt.text,
            'phone': '+960${phoneTxt.text}',
            'registerDate': DateTime.now(),
          });
        }
      }).then((value) {
        hideLoadingIndicator();
        Get.back();
      });
    }
  }

  Future checkifRegistered(context, authCore) async {
    showLoadingIndicator();

    FirebaseFirestore.instance
        .collection('users')
        .where('phone', isEqualTo: "+960${phoneTxt.text}")
        .get()
        .then((QuerySnapshot query) async {
      if (query.docs.isNotEmpty) {
        if (phoneTxt.text != '') {
          if (codeSend.value == false) {
            await phoneSignIn(phoneNumber: '+960${phoneTxt.text}');
          } else {
            verifyCode();
          }
        } else {
          errorSnackbar('Empty Number', "Please enter a number");
        }
      } else {
        Get.back();
        registerAlert(context, authCore);
      }
    });

    hideLoadingIndicator();
    return false;
  }

  // Sign out
  Future<void> signOut() {
    return _auth.signOut();
  }
}
