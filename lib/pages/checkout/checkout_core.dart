import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../../model/cart_model.dart';
import '../../shared/loading.dart';
import '../../shared/snackbar.dart';
import '../login/authcore.dart';

class CheckoutCore extends GetxController {
  RxInt location = 0.obs;
  RxInt place = 0.obs;
  RxBool address = true.obs;
  RxString addressString = ''.obs;
  TextEditingController addressTxt = TextEditingController();

  String calculateTotal(List<CartModel> cartList) {
    double total = cartList.fold(0, (sum, cartItem) => sum + cartItem.price * cartItem.quantity);
    return total.toStringAsFixed(2);
  }

  bool checkoutActive() {
    if (addressString.value == '' || place.value == 0) {
      return false;
    } else if (image.value == null) {
      return false;
    } else {
      return true;
    }
  }

  var fileSelected = false.obs;
  Uint8List? fileBytes;
  var fileName = ''.obs;
  Rxn<XFile> image = Rxn<XFile>();
  var imagePickerCrop = ImagePicker();

  Future getImage() async {
    image.value = await imagePickerCrop.pickImage(source: ImageSource.gallery);
    fileBytes = await image.value!.readAsBytes();
    fileName.value = image.value!.name;
    fileSelected.value = true;
  }

  var auth = Get.find<AuthCore>();

  Future checkout(List<CartModel> cartList, String total) async {
    String dateTime = DateTime.now().microsecondsSinceEpoch.toString();
    String? url;
    String firebasePath = 'orders/$dateTime';
    List<Map> productsList = [];

    for (int i = 0; i < cartList.length; i++) {
      productsList.add({
        "id": cartList[i].id,
        "name": cartList[i].name,
        "price": cartList[i].price,
        "quantity": cartList[i].quantity,
      });
    }

    showLoadingIndicator();

    if (image.value != null) {
      try {
        await FirebaseStorage.instance
            .ref(firebasePath)
            .putData(fileBytes!)
            .then((taskSnapshot) async {
          if (taskSnapshot.state == TaskState.success) {
            url = await FirebaseStorage.instance.ref(firebasePath).getDownloadURL();
          }
        });
      } catch (error) {
        errorSnackbar('Database Connection Error', '$error');
      }

      url = await firebase_storage.FirebaseStorage.instance.ref(firebasePath).getDownloadURL();
    }

    final path = 'orders/$dateTime';
    final ref = FirebaseFirestore.instance.doc(path);
    await ref.set({
      'receipt': url,
      'address': place.value == 1
          ? "$addressString, Male"
          : place.value == 2
              ? "$addressString, Hulhumale"
              : null,
      'products': productsList,
      'total': total,
      'user': auth.getUser,
      'orderTime': DateTime.now(),
    });

    final userpath = 'users/${auth.getUser}';
    final userref = FirebaseFirestore.instance.doc(userpath);
    await userref.update({'cart': 0});

    for (int i = 0; i < productsList.length; i++) {
      final productpath = 'product/${productsList[i]['id']}';
      final productref = FirebaseFirestore.instance.doc(productpath);
      await productref.update({'stock': FieldValue.increment(-productsList[i]['quantity'])});

      final cartpath = 'users/${auth.getUser}/cart/${productsList[i]['id']}';
      final cartref = FirebaseFirestore.instance.doc(cartpath);
      await cartref.delete();
    }

    hideLoadingIndicator();

    Get.back();
    sucessSnackbar("Ordered Successfully", "Order Received");
  }
}
