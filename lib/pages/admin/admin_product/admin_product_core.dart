import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_table/easy_table.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../model/category_model.dart';
import '../../../model/product_model.dart';
import '../../../shared/loading.dart';
import '../../../shared/snackbar.dart';

class AdminCore extends GetxController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  var productList = RxList<ProductModel>([]);
  var categoryList = RxList<CategoryModel>([]);

  @override
  void onInit() {
    productList.bindStream(productStream());
    categoryList.bindStream(categoryStream());
    ever(productList, calculateProduct);
    ever(categoryList, calculateCategory);

    super.onInit();
  }

  Stream<List<ProductModel>> productStream() {
    return _db
        .collection('product')
        .orderBy('name')
        .snapshots()
        .map((list) => list.docs.map((doc) => ProductModel.fromMap(doc.data(), doc.id)).toList());
  }

  Stream<List<CategoryModel>> categoryStream() {
    return _db
        .collection('category')
        .orderBy('name')
        .snapshots()
        .map((list) => list.docs.map((doc) => CategoryModel.fromMap(doc.data(), doc.id)).toList());
  }

  EasyTableModel<ProductModel>? productListTable;
  EasyTableModel<CategoryModel>? cartListTable;

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

  setCategoryTxt(CategoryModel category) {
    nameTxt.text = category.name;
  }

  calculateProduct(List<ProductModel> products) {
    productListTable = EasyTableModel<ProductModel>(rows: [
      for (var i = 0; i < products.length; i++) products[i]
    ], columns: [
      EasyTableColumn(name: 'Name', stringValue: (row) => row.name, width: 270),
      EasyTableColumn(name: 'Desc', stringValue: (row) => row.nameDesc),
      EasyTableColumn(name: 'Category', stringValue: (row) => row.category),
      EasyTableColumn(name: 'Price', stringValue: (row) => row.price.toString()),
      EasyTableColumn(name: 'Stock', stringValue: (row) => row.stock.toString()),
    ]);
  }

  calculateCategory(List<CategoryModel> categorys) {
    cartListTable = EasyTableModel<CategoryModel>(rows: [
      for (var i = 0; i < categorys.length; i++) categorys[i]
    ], columns: [
      EasyTableColumn(name: 'Name', stringValue: (row) => row.name, width: 270),
    ]);
  }

  Future createCategory() async {
    if (nameTxt.text != '') {
      showLoadingIndicator();
      var dateTime = DateTime.now();
      final path = 'category/${dateTime.millisecondsSinceEpoch}';
      final ref = FirebaseFirestore.instance.doc(path);
      await ref.set({'name': nameTxt.text.toUpperCase()});
      hideLoadingIndicator();

      Get.back();
      sucessSnackbar("Category Created", "Successfully created");
    } else {
      errorSnackbar("Fill all the fields", "Error creating");
    }
  }

  Future saveCategory(String id) async {
    showLoadingIndicator();
    final path = 'category/$id';
    final ref = FirebaseFirestore.instance.doc(path);
    await ref.update({'name': nameTxt.text.toUpperCase()});
    hideLoadingIndicator();

    Get.back();
    sucessSnackbar("Category Saved", "Successfully updated");
  }

  Future deleteCategory(String id) async {
    showLoadingIndicator();
    final path = 'category/$id';
    final ref = FirebaseFirestore.instance.doc(path);
    await ref.delete();
    hideLoadingIndicator();

    Get.back();
    sucessSnackbar("Category Deleted", "Successfully deleted");
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
        'price': double.parse(priceTxt.text),
        'stock': int.parse(stockTxt.text),
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
      'price': double.parse(priceTxt.text),
      'stock': int.parse(stockTxt.text),
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
