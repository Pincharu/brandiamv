import 'package:brandiamv/model/category_model.dart';
import 'package:brandiamv/shared/loading.dart';
import 'package:brandiamv/shared/snackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class AdminCategoryCore extends GetxController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  var categoryList = RxList<CategoryModel>([]);

  @override
  void onInit() {
    categoryList.bindStream(categoryStream());
    super.onInit();
  }

  Stream<List<CategoryModel>> categoryStream() {
    return _db
        .collection('category')
        .orderBy('name')
        .snapshots()
        .map((list) => list.docs.map((doc) => CategoryModel.fromMap(doc.data(), doc.id)).toList());
  }

  TextEditingController nameTxt = TextEditingController();

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
}
