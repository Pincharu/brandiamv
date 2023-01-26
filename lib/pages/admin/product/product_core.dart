import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../model/product_model.dart';
import '../../../shared/loading.dart';
import '../../../shared/snackbar.dart';

class AdminCore extends GetxController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  var productList = RxList<ProductModel>([]);

  @override
  void onInit() {
    productList.bindStream(productStream());
    // ever(productList, calculateProduct);
    // ever(categoryList, calculateCategory);

    super.onInit();
  }

  Stream<List<ProductModel>> productStream() {
    return _db
        .collection('product')
        .orderBy('name')
        .snapshots()
        .map((list) => list.docs.map((doc) => ProductModel.fromMap(doc.data(), doc.id)).toList());
  }

  TextEditingController nameTxt = TextEditingController();
  TextEditingController descTxt = TextEditingController();
  TextEditingController categoryTxt = TextEditingController();
  TextEditingController priceTxt = TextEditingController();
  TextEditingController stockTxt = TextEditingController();

  resetTxt() {
    nameTxt.text = '';
    descTxt.text = '';
    categoryTxt.text = '';
    priceTxt.text = '';
    stockTxt.text = '';
  }

  setProductTxt(ProductModel product) {
    nameTxt.text = product.name;
    descTxt.text = product.nameDesc;
    categoryTxt.text = product.category ?? '';
    priceTxt.text = product.price.toString();
    stockTxt.text = product.stock.toString();
  }

  Future createProduct() async {
    if (nameTxt.text != '' &&
        descTxt.text != '' &&
        categoryTxt.text != '' &&
        priceTxt.text != '' &&
        stockTxt.text != '') {
      showLoadingIndicator();
      var dateTime = DateTime.now();
      final path = 'product/${dateTime.millisecondsSinceEpoch}';
      final ref = FirebaseFirestore.instance.doc(path);
      await ref.set({
        'name': nameTxt.text,
        'nameDesc': descTxt.text,
        'category': categoryTxt.text,
        'price': 0,
        'stock': 0,
      });
      hideLoadingIndicator();

      Get.back();
      sucessSnackbar("Product Created", "Successfully created");
    } else {
      errorSnackbar("Fill all the fields", "Error creating");
    }
  }

  Future saveProduct(String id) async {
    showLoadingIndicator();
    final path = 'product/$id';
    final ref = FirebaseFirestore.instance.doc(path);
    await ref.update({
      'name': nameTxt.text,
      'nameDesc': descTxt.text,
      'category': categoryTxt.text,
      'price': 0,
      'stock': 0,
    });
    hideLoadingIndicator();

    Get.back();
    sucessSnackbar("Product Saved", "Successfully updated");
  }

  Future deleteProduct(String id) async {
    showLoadingIndicator();
    final path = 'product/$id';
    final ref = FirebaseFirestore.instance.doc(path);
    await ref.delete();
    hideLoadingIndicator();

    Get.back();
    sucessSnackbar("Product Deleted", "Successfully deleted");
  }
}
