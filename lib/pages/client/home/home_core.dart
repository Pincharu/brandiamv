import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_table/easy_table.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../model/category_model.dart';
import '../../../model/product_model.dart';
import '../../../shared/loading.dart';
import '../../../shared/snackbar.dart';
import '../../../shared/authcore.dart';

class HomeCore extends GetxController {
  var scrollTop = true.obs;
  var page = 0.obs;
  var category = 'All'.obs;
  var authCore = Get.find<AuthCore>();

  var selectedAtoll = 'Select Atoll'.obs;
  var selectedIsland = 'Select Island'.obs;

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  var productList = RxList<ProductModel>([]);
  var currentList = RxList<ProductModel>([]);
  var categoryList = RxList<CategoryModel>([]);
  EasyTableModel<ProductModel>? cartListTable;
  TextEditingController nameTxt = TextEditingController();
  TextEditingController phoneTxt = TextEditingController();
  TextEditingController addressTxt = TextEditingController();
  TextEditingController noteTxt = TextEditingController();

  var bags = 0.obs;
  var bars = 0.obs;

  var categoryName = ['All'].obs;
  int selectedTab = 0;
  var cartTotal = 0.0.obs;
  var categoryQty = {}.obs;

  @override
  void onReady() {
    categoryList.bindStream(categoryStream());
    productList.bindStream(productStream());
    ever(productList, setProducts);
    ever(categoryList, setCategory);

    super.onReady();
  }

  setUserDetails() {
    if (authCore.firestoreUser.value != null) {
      nameTxt.text = authCore.firestoreUser.value!.name;
      phoneTxt.text = authCore.firestoreUser.value!.phone;
      selectedAtoll.value = authCore.firestoreUser.value!.atoll ?? 'Select Atoll';
      selectedIsland.value = authCore.firestoreUser.value!.island ?? 'Select Island';
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
      categoryQty.addAll({categoryList[i].name: 0});
    }
  }

  Future checkout() async {
    String dateTime = DateTime.now().microsecondsSinceEpoch.toString();
    List<Map> productsList = [];

    for (int i = 0; i < currentList.length; i++) {
      if ((currentList[i].quantity ?? 0) != 0) {
        productsList.add({
          "id": currentList[i].id,
          "name": currentList[i].name,
          "quantity": currentList[i].quantity,
          "itemCode": currentList[i].itemCode,
          "price": 0.0,
        });
      }
    }

    showLoadingIndicator();
    final path = 'orders/$dateTime';
    final ref = FirebaseFirestore.instance.doc(path);
    await ref.set({
      'name': nameTxt.text,
      'phone': phoneTxt.text,
      'atoll': selectedAtoll.value,
      'island': selectedIsland.value,
      'note': noteTxt.text,
      'address': addressTxt.text,
      'products': productsList,
      'user': authCore.getUser,
      'orderTime': DateTime.now(),
      'read': false,
      'bars': bars.value,
      'bags': bags.value,
    });

    final userpath = 'users/${authCore.getUser}';
    final userref = FirebaseFirestore.instance.doc(userpath);
    await userref.update({
      'address': addressTxt.text,
      'atoll': selectedAtoll.value,
      'island': selectedIsland.value,
    });

    for (int i = 0; i < currentList.length; i++) {
      currentList[i].quantity = 0;
    }

    bars.value = 0;
    bags.value = 0;

    hideLoadingIndicator();

    Get.back();
    sucessSnackbar("Ordered Successfully", "Order Received");
  }
}
