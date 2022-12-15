import 'package:easy_table/easy_table.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:side_sheet/side_sheet.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../app/app_routing.dart';
import '../../../model/category_model.dart';
import '../../../model/product_model.dart';
import '../../../shared/header.dart';
import '../../../shared/textfield.dart';
import '../../../shared/authcore.dart';
import 'admin_product_core.dart';

class AdminProductPage extends StatelessWidget {
  const AdminProductPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var model = Get.put<AdminCore>(AdminCore());
    var authCore = Get.find<AuthCore>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
        title: "Admin Products".text.size(20).bold.make(),
      ),
      body: Obx(
        () => authCore.firebaseUser.value != null
            ? authCore.getUser == 'QqQaGjdHO4OcYlie5YcmNfuttW03'
                ? ListView(
                    children: [
                      20.heightBox,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          "Categories".text.size(20).bold.make(),
                          IconButton(
                              onPressed: () {
                                model.resetTxt();

                                SideSheet.right(
                                    width: context.screenWidth > 600 ? 600 : context.screenWidth,
                                    body: ListView(
                                      children: [
                                        20.heightBox,
                                        "Catgory Edit".text.size(20).bold.make(),
                                        20.heightBox,
                                        TextField(
                                          decoration: textFieldDefault.copyWith(labelText: 'Name'),
                                          controller: model.nameTxt,
                                        ),
                                        20.heightBox,
                                        Row(
                                          children: [
                                            ElevatedButton(
                                                    onPressed: () => model.createCategory(),
                                                    child: "Create".text.size(20).bold.make())
                                                .expand()
                                          ],
                                        ),
                                      ],
                                    ).px12(),
                                    context: context);
                              },
                              icon: const Icon(Icons.add)),
                        ],
                      ),
                      10.heightBox,
                      Obx(() => model.categoryList.isNotEmpty
                          ? SizedBox(
                              height: model.categoryList.length * 50,
                              child: EasyTable<CategoryModel>(
                                model.cartListTable,
                                onRowTap: (row) {
                                  model.resetTxt();
                                  model.setCategoryTxt(row);

                                  SideSheet.right(
                                      width: context.screenWidth > 600 ? 600 : context.screenWidth,
                                      body: ListView(
                                        children: [
                                          20.heightBox,
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              "Catgory Edit".text.size(20).bold.make(),
                                              IconButton(
                                                  onPressed: () => model.deleteCategory(row.id),
                                                  icon: const Icon(Icons.delete)),
                                            ],
                                          ),
                                          20.heightBox,
                                          TextField(
                                            decoration:
                                                textFieldDefault.copyWith(labelText: 'Name'),
                                            controller: model.nameTxt,
                                          ),
                                          20.heightBox,
                                          Row(
                                            children: [
                                              ElevatedButton(
                                                      onPressed: () => model.saveCategory(row.id),
                                                      child: "Save".text.size(20).bold.make())
                                                  .expand()
                                            ],
                                          ),
                                        ],
                                      ).px12(),
                                      context: context);
                                },
                              ),
                            )
                          : const SizedBox()),
                      20.heightBox,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          "Products".text.size(20).bold.make(),
                          IconButton(
                              onPressed: () {
                                model.resetTxt();

                                SideSheet.right(
                                    width: context.screenWidth > 600 ? 600 : context.screenWidth,
                                    body: ListView(
                                      children: [
                                        20.heightBox,
                                        "Create Product".text.size(20).bold.make(),
                                        20.heightBox,
                                        TextField(
                                          decoration: textFieldDefault.copyWith(labelText: 'Name'),
                                          controller: model.nameTxt,
                                        ),
                                        5.heightBox,
                                        TextField(
                                          decoration:
                                              textFieldDefault.copyWith(labelText: 'Description'),
                                          controller: model.descTxt,
                                        ),
                                        5.heightBox,
                                        TextField(
                                          decoration: textFieldDefault.copyWith(labelText: 'Price'),
                                          controller: model.priceTxt,
                                        ),
                                        5.heightBox,
                                        TextField(
                                          decoration: textFieldDefault.copyWith(labelText: 'Stock'),
                                          controller: model.stockTxt,
                                        ),
                                        20.heightBox,
                                        Row(
                                          children: [
                                            ElevatedButton(
                                                    onPressed: () => model.createProduct(),
                                                    child: "Save".text.size(20).bold.make())
                                                .expand()
                                          ],
                                        ),
                                      ],
                                    ).px12(),
                                    context: context);
                              },
                              icon: const Icon(Icons.add)),
                        ],
                      ),
                      10.heightBox,
                      Obx(() => model.productList.isNotEmpty
                          ? SizedBox(
                              height: model.productList.length * 50,
                              child: EasyTable<ProductModel>(
                                model.productListTable,
                                onRowTap: (row) {
                                  model.resetTxt();
                                  model.setProductTxt(row);

                                  SideSheet.right(
                                      width: context.screenWidth > 600 ? 600 : context.screenWidth,
                                      body: ListView(
                                        children: [
                                          20.heightBox,
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              "Product Edit".text.size(20).bold.make(),
                                              IconButton(
                                                  onPressed: () => model.deleteProduct(row.id),
                                                  icon: const Icon(Icons.delete)),
                                            ],
                                          ),
                                          20.heightBox,
                                          TextField(
                                            decoration:
                                                textFieldDefault.copyWith(labelText: 'Name'),
                                            controller: model.nameTxt,
                                          ),
                                          5.heightBox,
                                          TextField(
                                            decoration:
                                                textFieldDefault.copyWith(labelText: 'Description'),
                                            controller: model.descTxt,
                                          ),
                                          5.heightBox,
                                          TextField(
                                            decoration:
                                                textFieldDefault.copyWith(labelText: 'Price'),
                                            controller: model.priceTxt,
                                          ),
                                          5.heightBox,
                                          TextField(
                                            decoration:
                                                textFieldDefault.copyWith(labelText: 'Stock'),
                                            controller: model.stockTxt,
                                          ),
                                          20.heightBox,
                                          Row(
                                            children: [
                                              ElevatedButton(
                                                      onPressed: () => model.saveProduct(row.id),
                                                      child: "Save".text.size(20).bold.make())
                                                  .expand()
                                            ],
                                          ),
                                        ],
                                      ).px12(),
                                      context: context);
                                },
                              ),
                            )
                          : const SizedBox())
                    ],
                  ).px12()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      "Not logged in as admin".text.size(20).make(),
                      20.widthBox,
                      ElevatedButton(
                          style:
                              ElevatedButton.styleFrom(backgroundColor: Colors.blue, elevation: 0),
                          onPressed: () async {
                            await authCore.signOut();
                            Get.offAllNamed(Routes.main);
                          },
                          child: Row(
                            children: [
                              const Icon(Icons.logout, size: 14),
                              5.widthBox,
                              "Logout".text.white.size(14).make(),
                            ],
                          ).p12()),
                    ],
                  ).centered()
            : ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, elevation: 0),
                    onPressed: () {
                      loginAlert(context, authCore);
                    },
                    child: "Login".text.bold.white.size(14).make().p12())
                .centered(),
      ),
    );
  }
}
