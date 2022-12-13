import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_table/easy_table.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../model/category_model.dart';
import '../../model/product_model.dart';
import '../../shared/loading.dart';
import '../../shared/snackbar.dart';
import '../login/authcore.dart';

class HomeCore extends GetxController {
  var scrollTop = true.obs;
  var page = 0.obs;
  var category = 'All'.obs;
  var authCore = Get.find<AuthCore>();

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  var productList = RxList<ProductModel>([]);
  var currentList = RxList<ProductModel>([]);
  var cartList = RxList<ProductModel>([]);
  var cartListIDs = RxList<String>([]);
  var categoryList = RxList<CategoryModel>([]);
  EasyTableModel<ProductModel>? cartListTable;
  TextEditingController nameTxt = TextEditingController();
  TextEditingController phoneTxt = TextEditingController();
  TextEditingController addressTxt = TextEditingController();

  var categoryName = ['All'].obs;
  int selectedTab = 0;
  var cartTotal = 0.0.obs;
  var categoryTotal = {};
  var categoryQty = {};

  @override
  void onReady() {
    categoryList.bindStream(categoryStream());
    productList.bindStream(productStream());
    ever(productList, setProducts);
    ever(categoryList, setCategory);
    cartListIDs.value = cartList.map((cart) => cart.id).toList();

    super.onReady();
  }

  setUserDetails() {
    if (authCore.firestoreUser.value != null) {
      nameTxt.text = authCore.firestoreUser.value!.name;
      phoneTxt.text = authCore.firestoreUser.value!.phone;
      addressTxt.text = authCore.firestoreUser.value!.address ?? '';

    }
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

  setProducts(List<ProductModel> productList) {
    currentList.clear();

    for (var i = 0; i < productList.length; i++) {
      if (category.value == "All") {
        currentList.add(productList[i]);
      } else {
        if (category.value == productList[i].category) {
          currentList.add(productList[i]);
        }
      }
    }
  }

  resetProducts() {
    currentList.clear();

    for (var i = 0; i < productList.length; i++) {
      if (category.value == "All") {
        currentList.add(productList[i]);
      } else {
        if (category.value == productList[i].category) {
          currentList.add(productList[i]);
        }
      }
    }
  }

  setCategoryName(int i) {
    if (i == 0) {
      category.value = "All";
    } else {
      category.value = categoryList[--i].name;
    }
  }

  setCategory(List<CategoryModel> categoryList) {
    categoryName.clear();
    categoryName.add("All");
    category.value = 'All';

    for (var i = 0; i < categoryList.length; i++) {
      categoryName.add(categoryList[i].name);
      categoryTotal.addAll({categoryList[i].name: 0});
      categoryQty.addAll({categoryList[i].name: 0});
    }
  }

  calculateCartTotal() {
    cartTotal.value = 0;
    for (var i = 0; i < cartList.length; i++) {
      cartTotal.value = cartTotal.value + (cartList[i].price * cartList[i].quantity!);
    }

    categoryTotal.forEach((key, value) {
      categoryTotal[key] = 0;
    });

    categoryQty.forEach((key, value) {
      categoryQty[key] = 0;
    });

    categoryTotal.forEach((key, value) {
      for (var i = 0; i < cartList.length; i++) {
        if (cartList[i].category == key) {
          categoryTotal[key] += (cartList[i].price * cartList[i].quantity!);
        }
      }
    });

    categoryQty.forEach((key, value) {
      for (var i = 0; i < cartList.length; i++) {
        if (cartList[i].category == key) {
          categoryQty[key] += (cartList[i].quantity!);
        }
      }
    });

    // print(categoryTotal);
  }

  Future checkout() async {
    cartList.value = [];
    String dateTime = DateTime.now().microsecondsSinceEpoch.toString();
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
    final path = 'orders/$dateTime';
    final ref = FirebaseFirestore.instance.doc(path);
    await ref.set({
      'address': addressTxt.text,
      'products': productsList,
      'total': cartTotal.value,
      'user': authCore.getUser,
      'orderTime': DateTime.now(),
    });

    final userpath = 'users/${authCore.getUser}';
    final userref = FirebaseFirestore.instance.doc(userpath);
    await userref.update({
      'address' : addressTxt.text,

    });

    for (int i = 0; i < productsList.length; i++) {
      final productpath = 'product/${productsList[i]['id']}';
      final productref = FirebaseFirestore.instance.doc(productpath);
      await productref.update({'stock': FieldValue.increment(-productsList[i]['quantity'])});

      final cartpath = 'users/${authCore.getUser}/cart/${productsList[i]['id']}';
      final cartref = FirebaseFirestore.instance.doc(cartpath);
      await cartref.delete();
    }

    hideLoadingIndicator();

    Get.back();
    sucessSnackbar("Ordered Successfully", "Order Received");
  }
}
