import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:side_sheet/side_sheet.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../app/app_assets.dart';
import '../../../shared/image_placer.dart';
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
                  leading: (product.image != null)
                      ? SizedBox(
                          height: 80,
                          width: 80,
                          child: Image.network(product.image!, fit: BoxFit.contain),
                        )
                      : const SizedBox(
                          height: 80,
                          width: 80,
                          child: ImagePlacer(image: kimageProduct, boxfit: BoxFit.contain)),
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
                                Row(
                                  children: [
                                    IconButton(
                                        onPressed: () => Get.back(),
                                        icon: const Icon(Icons.arrow_back)),
                                    "Product Edit".text.size(20).bold.make(),
                                  ],
                                ),
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
                            5.heightBox,
                            "Category".text.size(18).make(),
                            5.heightBox,
                            Obx(
                              () => model.categoryList.isNotEmpty
                                  ? DropdownButton<String>(
                                      value: model.categorySelect.value,
                                      items: model.categoryListString
                                          .map<DropdownMenuItem<String>>((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: value.text.size(20).make(),
                                        );
                                      }).toList(),
                                      onChanged: (String? newValue) {
                                        model.categorySelect.value = newValue!;
                                      },
                                    )
                                  : const SizedBox(),
                            ),
                            5.heightBox,
                            TextField(
                              decoration: textFieldDefault.copyWith(labelText: 'Item Code'),
                              controller: model.itemCodeTxt,
                            ),
                            5.heightBox,
                            TextField(
                              decoration: textFieldDefault.copyWith(labelText: 'Stock'),
                              controller: model.stockTxt,
                              keyboardType: TextInputType.number,
                            ),
                            5.heightBox,
                            VxBox(
                              child: Obx(
                                () => model.fileSelected.value
                                    ? Row(
                                        children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              "Image selected".text.size(18).make(),
                                              10.heightBox,
                                              Row(
                                                children: [
                                                  ElevatedButton(
                                                    style: ElevatedButton.styleFrom(
                                                        backgroundColor: Colors.blue),
                                                    onPressed: () {
                                                      model.getImage();
                                                    },
                                                    child: "Change Product Image"
                                                        .text
                                                        .size(18)
                                                        .bold
                                                        .make()
                                                        .p12(),
                                                  ).expand(),
                                                ],
                                              )
                                            ],
                                          ).expand(flex: 3),
                                          SizedBox(
                                            child: Image.network(model.image.value!.path).p12(),
                                          ).expand(flex: 2),
                                        ],
                                      ).p12()
                                    : product.image != null
                                        ? Row(
                                            children: [
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  "Image selected".text.size(18).make(),
                                                  10.heightBox,
                                                  Row(
                                                    children: [
                                                      ElevatedButton(
                                                        style: ElevatedButton.styleFrom(
                                                            backgroundColor: Colors.blue),
                                                        onPressed: () {
                                                          model.getImage();
                                                        },
                                                        child: "Change Product Image"
                                                            .text
                                                            .size(18)
                                                            .bold
                                                            .make()
                                                            .p12(),
                                                      ).expand(),
                                                    ],
                                                  )
                                                ],
                                              ).expand(flex: 3),
                                              SizedBox(
                                                child: Image.network(product.image!).p12(),
                                              ).expand(flex: 2),
                                            ],
                                          ).p12()
                                        : Row(
                                            children: [
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  "No image selected".text.bold.size(18).make(),
                                                  10.heightBox,
                                                  Row(
                                                    children: [
                                                      ElevatedButton(
                                                        style: ElevatedButton.styleFrom(
                                                            backgroundColor: Colors.white),
                                                        onPressed: () {
                                                          model.getImage();
                                                        },
                                                        child: "Select Product Image"
                                                            .text
                                                            .color(Colors.blue)
                                                            .size(18)
                                                            .bold
                                                            .make()
                                                            .p12(),
                                                      ).expand(),
                                                    ],
                                                  )
                                                ],
                                              ).expand(flex: 3),
                                              const Icon(
                                                Icons.receipt,
                                                color: Colors.black26,
                                                size: 90,
                                              ).expand(flex: 2),
                                            ],
                                          ).p12(),
                              ),
                            ).rounded.color(Colors.grey[300]!).shadowSm.make(),
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
                  Row(
                    children: [
                      IconButton(onPressed: () => Get.back(), icon: const Icon(Icons.arrow_back)),
                      "Create Product".text.size(20).bold.make(),
                    ],
                  ),
                  20.heightBox,
                  TextField(
                    decoration: textFieldDefault.copyWith(labelText: 'Name'),
                    controller: model.nameTxt,
                  ),
                  5.heightBox,
                  TextField(
                    decoration:
                        textFieldDefault.copyWith(labelText: 'Description', hintText: 'Per Bag'),
                    controller: model.descTxt,
                  ),
                  5.heightBox,
                  "Category".text.size(18).make(),
                  5.heightBox,
                  Obx(
                    () => model.categoryList.isNotEmpty
                        ? DropdownButton<String>(
                            value: model.categorySelect.value,
                            items: model.categoryListString
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: value.text.size(20).make(),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              model.categorySelect.value = newValue!;
                            },
                          )
                        : const SizedBox(),
                  ),
                  5.heightBox,
                  TextField(
                    decoration: textFieldDefault.copyWith(labelText: 'Item Code'),
                    controller: model.itemCodeTxt,
                  ),
                  5.heightBox,
                  TextField(
                    decoration: textFieldDefault.copyWith(labelText: 'Stock'),
                    controller: model.stockTxt,
                    keyboardType: TextInputType.number,
                  ),
                  5.heightBox,
                  VxBox(
                      child: Obx(
                    () => model.fileSelected.value
                        ? Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  "Image selected".text.size(18).make(),
                                  10.heightBox,
                                  Row(
                                    children: [
                                      ElevatedButton(
                                        style:
                                            ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                                        onPressed: () {
                                          model.getImage();
                                        },
                                        child:
                                            "Change Product Image".text.size(18).bold.make().p12(),
                                      ).expand(),
                                    ],
                                  )
                                ],
                              ).expand(flex: 3),
                              SizedBox(
                                child: Image.network(model.image.value!.path).p12(),
                              ).expand(flex: 2),
                            ],
                          ).p12()
                        : Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  "No image selected".text.bold.size(18).make(),
                                  10.heightBox,
                                  Row(
                                    children: [
                                      ElevatedButton(
                                        style:
                                            ElevatedButton.styleFrom(backgroundColor: Colors.white),
                                        onPressed: () {
                                          model.getImage();
                                        },
                                        child: "Select Product Image"
                                            .text
                                            .color(Colors.blue)
                                            .size(18)
                                            .bold
                                            .make()
                                            .p12(),
                                      ).expand(),
                                    ],
                                  )
                                ],
                              ).expand(flex: 3),
                              const Icon(
                                Icons.receipt,
                                color: Colors.black26,
                                size: 90,
                              ).expand(flex: 2),
                            ],
                          ).p12(),
                  )).rounded.color(Colors.grey[300]!).shadowSm.make(),
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
