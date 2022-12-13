import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../model/user_model.dart';
import '../../shared/loading.dart';
import '../../shared/snackbar.dart';
import '../home/home_page.dart';

class AuthCore extends GetxController {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController referralController = TextEditingController();

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
  //   nameController.dispose();
  //   emailController.dispose();
  //   passwordController.dispose();
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
          email: emailController.text.trim(), password: passwordController.text.trim());
      emailController.clear();
      passwordController.clear();
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
  }

  Future<bool> verifedRefferal() async {
    bool found = false;
    await FirebaseFirestore.instance
        .collection('users')
        .where('referral', isEqualTo: referralController.text)
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
    if (emailController.text != '' &&
        passwordController.text != '' &&
        nameController.text != '' &&
        phoneController.text != '') {
      showLoadingIndicator();
      try {
        await _auth
            .createUserWithEmailAndPassword(
                email: emailController.text, password: passwordController.text)
            .then((result) async {
          await result.user!.sendEmailVerification();

          final path = 'users/${result.user!.uid}';
          final ref = FirebaseFirestore.instance.doc(path);
          await ref.set({
            'id': result.user!.uid,
            'email': result.user!.email,
            'name': nameController.text,
            'password': passwordController.text,
            'phone': phoneController.text,
            'registerDate': DateTime.now(),
            'address': addressController.text,
            'device': 'web',
            'cart': 0,
          });

          emailController.clear();
          passwordController.clear();
          nameController.clear();
          phoneController.clear();

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

  //check if user is an admin user
  // isAdmin() async {
  //   await getUser.then((user) async {
  //     DocumentSnapshot adminRef =
  //         await _db.collection('admin').doc(user.uid).get();
  //     if (adminRef.exists) {
  //       admin.value = true;
  //     } else {
  //       admin.value = false;
  //     }
  //     update();
  //   });
  // }

  // Sign out
  Future<void> signOut() {
    return _auth.signOut();
  }
}
