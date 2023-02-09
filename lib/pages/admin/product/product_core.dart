import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../../../model/category_model.dart';
import '../../../model/product_model.dart';
import '../../../shared/loading.dart';
import '../../../shared/snackbar.dart';

class AdminCore extends GetxController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  var productList = RxList<ProductModel>([]);
  var categoryList = RxList<CategoryModel>([]);
  var categoryListString = RxList<String>([]);
  var categorySelect = ''.obs;

  @override
  void onInit() {
    productList.bindStream(productStream());
    categoryList.bindStream(categoryStream());
    ever(categoryList, setCategory);

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

  setCategory(List<CategoryModel> categoryList) {
    categoryListString.value = [];
    categorySelect.value = categoryList[0].name;
    categoryListString.add('');
    for (var i = 0; i < categoryList.length; i++) {
      categoryListString.add(categoryList[i].name);
    }
  }

  var amount = 100.0.obs;
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

  TextEditingController nameTxt = TextEditingController();
  TextEditingController descTxt = TextEditingController();
  TextEditingController categoryTxt = TextEditingController();
  TextEditingController priceTxt = TextEditingController();
  TextEditingController stockTxt = TextEditingController();
  TextEditingController itemCodeTxt = TextEditingController();

  resetTxt() {
    nameTxt.text = '';
    descTxt.text = '';
    categoryTxt.text = '';
    priceTxt.text = '';
    stockTxt.text = '';
    itemCodeTxt.text = '';
    image.value = null;
  }

  setProductTxt(ProductModel product) {
    nameTxt.text = product.name;
    descTxt.text = product.nameDesc;
    categoryTxt.text = product.category ?? '';
    priceTxt.text = product.price.toString();
    stockTxt.text = product.stock.toString();
    itemCodeTxt.text = product.itemCode ?? '';
    categorySelect.value = product.category ?? categoryList[0].name;
  }

  Future createProduct() async {
    if (nameTxt.text != '' && descTxt.text != '') {
      showLoadingIndicator();
      var dateTime = DateTime.now();

      String? url;
      String firebasePath = 'products/${dateTime.millisecondsSinceEpoch}';

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

      final path = 'product/${dateTime.millisecondsSinceEpoch}';
      final ref = FirebaseFirestore.instance.doc(path);
      await ref.set({
        'name': nameTxt.text,
        'nameDesc': descTxt.text,
        'category': categorySelect.value,
        'itemCode': itemCodeTxt.text,
        'image': url,
        'price': 0,
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
      'category': categorySelect.value,
      'itemCode': itemCodeTxt.text,
      'price': 0,
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
