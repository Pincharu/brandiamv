import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:side_sheet/side_sheet.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../shared/textfield.dart';
import 'product_core.dart';

class AdminProductPage extends StatelessWidget {
  const AdminProductPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var model = Get.put<AdminCore>(AdminCore());

    return Scaffold(
      body: Obx(() => model.productList.isNotEmpty
          ? ListView.builder(
              itemCount: model.productList.length,
              itemBuilder: (ctx, i) {
                var product = model.productList[i];
                return ListTile(
                  title: product.name.text.size(18).make(),
                  subtitle: product.nameDesc.text.size(18).make(),
                  onTap: () {
                    model.setProductTxt(product);

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
                                    onPressed: () => model.deleteProduct(product.id),
                                    icon: const Icon(Icons.delete)),
                              ],
                            ),
                            20.heightBox,
                            TextField(
                              decoration: textFieldDefault.copyWith(labelText: 'Name'),
                              controller: model.nameTxt,
                            ),
                            5.heightBox,
                            TextField(
                              decoration: textFieldDefault.copyWith(labelText: 'Description'),
                              controller: model.descTxt,
                            ),
                            20.heightBox,
                            Row(
                              children: [
                                ElevatedButton(
                                        onPressed: () => model.saveProduct(product.id),
                                        child: "Save".text.size(20).bold.make())
                                    .expand()
                              ],
                            ),
                          ],
                        ).px12(),
                        context: context);
                  },
                );
              },
            )
          : const CircularProgressIndicator().centered()),
      floatingActionButton: FloatingActionButton(
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
                    decoration: textFieldDefault.copyWith(labelText: 'Description'),
                    controller: model.descTxt,
                  ),
                  5.heightBox,
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
        child: const Icon(Icons.add),
      ),
    );
  }
}
