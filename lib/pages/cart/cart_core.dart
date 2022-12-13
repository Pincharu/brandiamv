import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../model/cart_model.dart';
import '../../shared/loading.dart';
import '../login/authcore.dart';

class CartCore extends GetxController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  var cartList = RxList<CartModel>([]);
  var authCore = Get.find<AuthCore>();

  @override
  void onInit() {
    if (authCore.firebaseUser.value != null) cartList.bindStream(cartStream());
    super.onInit();
  }

  Stream<List<CartModel>> cartStream() {
    return _db
        .collection('users/${authCore.getUser}/cart')
        .snapshots()
        .map((list) => list.docs.map((doc) => CartModel.fromMap(doc.data(), doc.id)).toList());
  }

  Future updateItem(String id, int amount) async {
    showLoadingIndicator();
    final path = 'users/${authCore.getUser}/cart/$id';
    final ref = FirebaseFirestore.instance.doc(path);
    await ref.update({'quantity': amount});
    hideLoadingIndicator();
  }

  Future deleteItem(String id) async {
    showLoadingIndicator();
    final path = 'users/${authCore.getUser}/cart/$id';
    final ref = FirebaseFirestore.instance.doc(path);
    await ref.delete();

    final userpath = 'users/${authCore.getUser}';
    final userref = FirebaseFirestore.instance.doc(userpath);
    await userref.update({'cart': FieldValue.increment(-1)});
    hideLoadingIndicator();
  }
}
