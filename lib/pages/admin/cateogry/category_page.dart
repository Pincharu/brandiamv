import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:side_sheet/side_sheet.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../shared/textfield.dart';
import 'category_core.dart';

class AdminCategoryPage extends StatelessWidget {
  const AdminCategoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var model = Get.put<AdminCategoryCore>(AdminCategoryCore());

    return Scaffold(
      body: Obx(() => model.categoryList.isNotEmpty
          ? ListView.builder(
              itemCount: model.categoryList.length,
              itemBuilder: (ctx, i) {
                var category = model.categoryList[i];
                return ListTile(
                  title: category.name.text.size(18).make(),
                  onTap: () {
                    model.nameTxt.text = category.name;

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
                                    onPressed: () => model.deleteCategory(category.id),
                                    icon: const Icon(Icons.delete)),
                              ],
                            ),
                            20.heightBox,
                            TextField(
                              decoration: textFieldDefault.copyWith(labelText: 'Name'),
                              controller: model.nameTxt,
                            ),
                            20.heightBox,
                            Row(
                              children: [
                                ElevatedButton(
                                        onPressed: () => model.saveCategory(category.id),
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
          model.nameTxt.text = '';
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
        child: const Icon(Icons.add),
      ),
    );
  }
}
