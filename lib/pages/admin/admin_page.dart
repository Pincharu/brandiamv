import 'package:brandiamv/shared/header.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../app/app_routing.dart';
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

    return Scaffold(
      body: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Admin'),
            backgroundColor: Colors.blue,
            bottom: const TabBar(
              tabs: [
                Tab(icon: Text('Order', style: TextStyle(fontWeight: FontWeight.bold))),
                Tab(icon: Text('Product', style: TextStyle(fontWeight: FontWeight.bold))),
                Tab(icon: Text('Category', style: TextStyle(fontWeight: FontWeight.bold))),
              ],
            ),
            actions: [
              IconButton(
                  onPressed: () async {
                    await authCore.signOut();
                    Get.offAllNamed(Routes.main);
                  },
                  icon: const Icon(Icons.logout))
            ],
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
    );
  }
}
