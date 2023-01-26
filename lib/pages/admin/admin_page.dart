import 'package:brandiamv/shared/header.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../shared/authcore.dart';
import 'cateogry/category_page.dart';
import 'orders/orders_page.dart';
import 'product/product_core.dart';
import 'product/product_page.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var model = Get.put<AdminCore>(AdminCore());
    var authCore = Get.find<AuthCore>();

    return Obx(
      () => authCore.firebaseUser.value == null
          ? Scaffold(
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  "Login as Admin to access".text.size(20).bold.make(),
                  10.heightBox,
                  ElevatedButton(
                          onPressed: () {
                            loginAlert(context, authCore);
                          },
                          child: "Login".text.size(20).white.bold.make().p12())
                      .p20()
                ],
              ).centered(),
            )
          : (authCore.firestoreUser.value!.isAdmin == null ||
                  authCore.firestoreUser.value!.isAdmin == false)
              ? Scaffold(
                  body: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      "This login is not an admin".text.size(20).bold.make(),
                      10.heightBox,
                      ElevatedButton(
                              onPressed: () {
                                authCore.signOut();
                              },
                              child: "Logout".text.size(20).white.bold.make().p12())
                          .p20()
                    ],
                  ).centered(),
                )
              : Scaffold(
                  body: DefaultTabController(
                    length: 3,
                    child: Scaffold(
                      appBar: AppBar(
                        title: const Text('Admin'),
                        backgroundColor: Colors.blue,
                        bottom: const TabBar(
                          tabs: [
                            Tab(icon: Text('Order', style: TextStyle(fontWeight: FontWeight.bold))),
                            Tab(
                                icon:
                                    Text('Product', style: TextStyle(fontWeight: FontWeight.bold))),
                            Tab(
                                icon: Text('Category',
                                    style: TextStyle(fontWeight: FontWeight.bold))),
                          ],
                        ),
                      ),
                      body: const TabBarView(
                        children: [
                          AdminOrdersPage(),
                          AdminProductPage(),
                          AdminCategoryPage(),
                        ],
                      ),
                    ),
                  ),
                ),
    );
  }
}
