import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:easy_table/easy_table.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:side_sheet/side_sheet.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../app/app_assets.dart';
import '../../../app/app_colors.dart';
import '../../../model/product_model.dart';
import '../../../shared/header.dart';
import '../../../shared/image_placer.dart';
import '../../../shared/textfield.dart';
import '../../../shared/authcore.dart';
import 'home_core.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ScrollController scrollController = ScrollController();
  var model = Get.put<HomeCore>(HomeCore());
  var authCore = Get.find<AuthCore>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        toolbarHeight: 120,
        elevation: 0,
        flexibleSpace: SizedBox(
          width: context.screenWidth < 1200 ? context.screenWidth : 1200,
          child: Column(
            children: [
              const AppHeader(),
              Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DefaultTabController(
                      initialIndex: Get.arguments != null
                          ? int.parse(Get.arguments['tab'])
                          : model.selectedTab,
                      length: model.categoryName.length,
                      child: TabBar(
                        labelColor: Colors.blue,
                        labelPadding: const EdgeInsets.symmetric(horizontal: 15),
                        indicatorSize: TabBarIndicatorSize.tab,
                        unselectedLabelColor: Colors.white54,
                        indicator: const BubbleTabIndicator(
                          indicatorHeight: 30,
                          indicatorColor: Colors.white,
                          tabBarIndicatorSize: TabBarIndicatorSize.tab,
                        ),
                        isScrollable: true,
                        tabs: <Widget>[
                          for (String item in model.categoryName())
                            Tab(child: item.text.capitalize.size(18).bold.make()).px4(),
                        ],
                        onTap: (int i) {
                          model.selectedTab = i;
                          model.setCategoryName(i);
                          model.resetProducts();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: Obx(
        () => DefaultTabController(
          length: model.categoryName.length,
          child: TabBarView(
            physics: const NeverScrollableScrollPhysics(),
            children: [
              for (int i = 0; i < model.categoryName.length; i++)
                list(context, scrollController, model),
            ],
          ),
        ),
      ),
      floatingActionButton: Obx(
        () => model.cartList.isNotEmpty
            ? VxBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        "Checkout".text.white.size(16).bold.make(),
                        "${model.cartList.length} Items".text.white.size(16).make(),
                      ],
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        "Total".text.white.size(16).make(),
                        "Rf ${model.cartTotal}".text.white.size(16).bold.make(),
                      ],
                    ),
                  ],
                ).p12(),
              )
                .roundedSM
                .color(Colors.green)
                .make()
                .w(context.screenWidth > 600 ? 600 : context.screenWidth)
                .onInkTap(
                () {
                  model.cartListTable = EasyTableModel<ProductModel>(rows: [
                    for (var i = 0; i < model.cartList.length; i++) model.cartList[i]
                  ], columns: [
                    EasyTableColumn(name: 'Name', stringValue: (row) => row.name, width: 270),
                    EasyTableColumn(name: 'Price', stringValue: (row) => row.price.toString()),
                    EasyTableColumn(
                        name: 'Quantity', stringValue: (row) => row.quantity.toString()),
                    EasyTableColumn(
                        name: 'Total',
                        stringValue: (row) => (row.price * row.quantity!).toString()),
                  ]);

                  model.setUserDetails();

                  SideSheet.right(
                      width: context.screenWidth > 600 ? 600 : context.screenWidth,
                      body: ListView(
                        children: [
                          20.heightBox,
                          "Checkout".text.size(20).bold.make(),
                          10.heightBox,
                          SizedBox(
                              height: 300, child: EasyTable<ProductModel>(model.cartListTable)),
                          Container(
                            decoration: BoxDecoration(border: Border.all(width: .5)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                "Order Details".text.size(14).bold.make(),
                                for (var i = 0; i < model.categoryTotal.length; i++)
                                  if (model.categoryQty.values.elementAt(i) != 0)
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        "${model.categoryTotal.keys.elementAt(i)}"
                                            .text
                                            .size(14)
                                            .make(),
                                        Row(
                                          children: [
                                            "x${model.categoryQty.values.elementAt(i)}"
                                                .text
                                                .size(14)
                                                .make(),
                                            5.widthBox,
                                            "Rf ${model.categoryTotal.values.elementAt(i)}"
                                                .text
                                                .size(14)
                                                .make(),
                                          ],
                                        ),
                                      ],
                                    ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    "Sub Total".text.size(14).bold.make(),
                                    "Rf ${model.cartTotal}".text.size(14).bold.make(),
                                  ],
                                ),
                              ],
                            ).p8(),
                          ),
                          10.heightBox,
                          Container(
                            decoration: BoxDecoration(border: Border.all(width: .5)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                "User Details".text.size(14).bold.make(),
                                5.heightBox,
                                TextField(
                                  controller: model.nameTxt,
                                  decoration: textFieldDefault.copyWith(labelText: "Name"),
                                ),
                                5.heightBox,
                                TextField(
                                  controller: model.phoneTxt,
                                  decoration: textFieldDefault.copyWith(labelText: "Phone"),
                                ),
                                5.heightBox,
                                TextField(
                                  controller: model.addressTxt,
                                  decoration: textFieldDefault.copyWith(labelText: "Address"),
                                ),
                              ],
                            ).p8(),
                          ),
                          10.heightBox,
                          Row(
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                                onPressed: () {
                                  model.checkout();
                                },
                                child: 'Checkout'.text.size(16).bold.white.make().p8(),
                              ).expand(),
                            ],
                          ),
                        ],
                      ).px12(),
                      context: context);

                  // for (var i = 0; i < model.cartList.length; i++) {
                  //   print("${model.cartList[i].name} ${model.cartList[i].stock}");
                  // }
                },
              )
            : const SizedBox(),
      ),
    );
  }
}

Widget list(BuildContext context, ScrollController scrollController, HomeCore model) {
  return ListView(
    physics: const BouncingScrollPhysics(),
    controller: scrollController,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: context.screenWidth,
            child: Obx(
              () => model.currentList.isNotEmpty
                  ? GridView.builder(
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: context.screenWidth > 600 ? 350 : 400,
                        childAspectRatio: 0.8,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                      ),
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(20),
                      shrinkWrap: true,
                      itemCount: model.currentList.length,
                      itemBuilder: (ctx, i) {
                        var currentProduct = model.currentList[i];

                        return VxBox(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              8.heightBox,
                              (currentProduct.image != null)
                                  ? Hero(
                                      tag: currentProduct.id,
                                      child:
                                          Image.network(currentProduct.image!, fit: BoxFit.cover),
                                    ).expand()
                                  : const ImagePlacer(image: kimageProduct, boxfit: BoxFit.contain)
                                      .p12()
                                      .expand(),
                              currentProduct.name.text.capitalize.size(16).make().px8(),
                              "ITEM CODE: ${currentProduct.itemCode}"
                                  .text
                                  .size(14)
                                  .color(Colors.black54)
                                  .make()
                                  .px8(),
                              10.heightBox,
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      "RF ${currentProduct.price}"
                                          .text
                                          .capitalize
                                          .size(16)
                                          .bold
                                          .make()
                                          .px8(),
                                      currentProduct.nameDesc.text.capitalize
                                          .size(12)
                                          .color(Colors.black54)
                                          .make()
                                          .px8(),
                                    ],
                                  ),
                                  Obx(
                                    () => (model.cartListIDs.contains(currentProduct.id))
                                        ? VxStepper(
                                            defaultValue: 1,
                                            disableInput: true,
                                            min: 0,
                                            max: currentProduct.stock,
                                            onChange: (value) {
                                              if (value == 0) {
                                                model.cartList.removeWhere(
                                                    (cart) => cart.id == currentProduct.id);
                                                model.cartListIDs.removeWhere(
                                                    (cartID) => cartID == currentProduct.id);
                                              } else {
                                                int currentID;
                                                currentID = model.cartList.indexWhere(
                                                    (cart) => cart.id == currentProduct.id);

                                                model.cartList[currentID].quantity = value;
                                              }
                                              model.calculateCartTotal();
                                            },
                                          )
                                        : ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.blue),
                                            onPressed: (currentProduct.stock > 0)
                                                ? () {
                                                    var addedProduct = currentProduct;
                                                    addedProduct.quantity = 1;
                                                    model.cartList.add(addedProduct);
                                                    model.cartListIDs.add(addedProduct.id);
                                                    model.calculateCartTotal();
                                                  }
                                                : null,
                                            child: (currentProduct.stock > 0)
                                                ? "+ Add".text.size(14).white.make()
                                                : "Out of Stock".text.size(14).white.make(),
                                          ).pOnly(right: 4),
                                  )
                                ],
                              ),
                              8.heightBox,
                            ],
                          ),
                        ).rounded.color(const Color.fromARGB(221, 214, 214, 214)).make();
                      },
                    )
                  : SizedBox(
                      height: context.screenHeight,
                      child:
                          LoadingAnimationWidget.inkDrop(color: kcolorOrange, size: 30).centered()),
            ),
          ).expand(),
        ],
      ),
      100.heightBox,
    ],
  );
}
