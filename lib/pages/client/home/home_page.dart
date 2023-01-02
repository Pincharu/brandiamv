import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:side_sheet/side_sheet.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../app/app_assets.dart';
import '../../../app/app_colors.dart';
import '../../../app/maldives_islands.dart';
import '../../../shared/add_product.dart';
import '../../../shared/header.dart';
import '../../../shared/image_placer.dart';
import '../../../shared/authcore.dart';
import '../../../shared/textfield.dart';
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
        toolbarHeight: context.screenWidth < 850 ? 150 : 120,
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
      floatingActionButton: context.screenWidth > 850
          ? Obx(
              () => model.bags.value != 0 || model.bars.value != 0
                  ? VxBox(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              "Checkout".text.white.size(16).bold.make(),
                              "Quantity ${(model.bags.value + model.bars.value)}"
                                  .text
                                  .white
                                  .size(16)
                                  .bold
                                  .make(),
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
                        model.setUserDetails();
                        cartDrawer(context, model);
                      },
                    )
                  : const SizedBox(),
            )
          : const SizedBox(),
      bottomNavigationBar: context.screenWidth < 850
          ? Obx(
              () => model.bags.value != 0 || model.bars.value != 0
                  ? Row(
                      children: [
                        VxBox(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  "Checkout".text.white.size(16).bold.make(),
                                  "Quantity ${(model.bags.value + model.bars.value)}"
                                      .text
                                      .white
                                      .size(16)
                                      .bold
                                      .make(),
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
                            model.setUserDetails();
                            cartDrawer(context, model);
                          },
                        ).expand(),
                      ],
                    )
                  : const SizedBox(),
            )
          : const SizedBox(),
    );
  }
}

Widget list(BuildContext context, ScrollController scrollController, HomeCore model) {
  return context.screenWidth < 600
      ? ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20),
          shrinkWrap: true,
          itemCount: model.currentList.length,
          itemBuilder: (ctx, i) {
            var currentProduct = model.currentList[i];

            return ListTile(
                    tileColor: const Color.fromARGB(221, 214, 214, 214),
                    leading: (currentProduct.image != null)
                        ? SizedBox(
                            height: 120,
                            width: 80,
                            child: Hero(
                              tag: currentProduct.id,
                              child: Image.network(currentProduct.image!, fit: BoxFit.contain),
                            ),
                          )
                        : const SizedBox(
                            height: 120,
                            width: 80,
                            child: ImagePlacer(image: kimageProduct, boxfit: BoxFit.contain)),
                    title: currentProduct.name.text.capitalize.size(16).make().px8(),
                    subtitle: "ITEM CODE: ${currentProduct.itemCode}"
                        .text
                        .size(14)
                        .color(Colors.black54)
                        .make()
                        .px8(),
                    trailing: AddProduct(i: i))
                .pOnly(bottom: 4);
          })
      : ListView(
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
                            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 250,
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
                                            child: Image.network(currentProduct.image!,
                                                fit: BoxFit.contain),
                                          ).expand()
                                        : const ImagePlacer(
                                                image: kimageProduct, boxfit: BoxFit.contain)
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
                                    AddProduct(i: i).centered(),
                                    8.heightBox,
                                  ],
                                ),
                              ).rounded.color(const Color.fromARGB(221, 214, 214, 214)).make();
                            },
                          )
                        : SizedBox(
                            height: context.screenHeight,
                            child: LoadingAnimationWidget.inkDrop(color: kcolorOrange, size: 30)
                                .centered()),
                  ),
                ).expand(),
              ],
            ),
            100.heightBox,
          ],
        );
}

Future<dynamic> cartDrawer(BuildContext context, HomeCore model) {
  return SideSheet.right(
      width: context.screenWidth > 600 ? 600 : context.screenWidth,
      body: ListView(
        children: [
          20.heightBox,
          Row(
            children: [
              const Icon(Icons.arrow_back),
              5.widthBox,
              "Checkout".text.size(20).bold.make(),
            ],
          ).onInkTap(() => Get.back()),
          10.heightBox,
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(20),
            shrinkWrap: true,
            itemCount: model.currentList.length,
            itemBuilder: (ctx, i) {
              var currentProduct = model.currentList[i];

              return ((currentProduct.quantity ?? 0) == 0)
                  ? const SizedBox()
                  : ListTile(
                      tileColor: const Color.fromARGB(221, 214, 214, 214),
                      leading: (currentProduct.image != null)
                          ? SizedBox(
                              height: 120,
                              width: 80,
                              child: Hero(
                                tag: currentProduct.id,
                                child: Image.network(currentProduct.image!, fit: BoxFit.contain),
                              ),
                            )
                          : const SizedBox(
                              height: 120,
                              width: 80,
                              child: ImagePlacer(image: kimageProduct, boxfit: BoxFit.contain)),
                      title: currentProduct.name.text.capitalize.size(16).make().px8(),
                      subtitle: "ITEM CODE: ${currentProduct.itemCode}"
                          .text
                          .size(14)
                          .color(Colors.black54)
                          .make()
                          .px8(),
                      trailing: AddProduct(i: i));
            },
          ),
          Obx(
            () => Container(
              decoration: BoxDecoration(border: Border.all(width: .5)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  "Quantity".text.size(14).bold.make(),
                  5.heightBox,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      "Bags".text.size(14).make(),
                      "${model.bags.value} Quantity".text.size(14).make(),
                    ],
                  ),
                  5.heightBox,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      "Bars".text.size(14).make(),
                      "${model.bars.value} Quantity".text.size(14).make(),
                    ],
                  ),
                ],
              ).p8(),
            ),
          ),
          10.heightBox,
          Container(
            decoration: BoxDecoration(border: Border.all(width: .5)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                "Customer details".text.size(14).bold.make(),
                5.heightBox,
                TextField(
                  controller: model.nameTxt,
                  decoration: textFieldDefault.copyWith(labelText: "Customer Name"),
                ),
                5.heightBox,
                TextField(
                  controller: model.phoneTxt,
                  decoration: textFieldDefault.copyWith(labelText: "Contact Number"),
                ),
                5.heightBox,
                Obx(
                  () => Container(
                    color: kcolorTextfield,
                    child: Row(
                      children: [
                        "Atoll : ".text.size(16).color(Colors.black54).make(),
                        DropdownButton<String>(
                          value: model.selectedAtoll(),

                          icon: const SizedBox(),
                          // elevation: 16,
                          // style: const TextStyle(color: Colors.deepPurple),
                          underline: Container(
                            height: 0,
                            color: Colors.transparent,
                          ),
                          onChanged: (String? value) {
                            if (value != null) {
                              model.selectedAtoll.value = value;
                            }

                            model.selectedIsland.value = 'Select Island';
                          },
                          items: atolls.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ).expand(),
                      ],
                    ).px12(),
                  ),
                ),
                5.heightBox,
                Obx(
                  () => Container(
                    color: kcolorTextfield,
                    child: Row(
                      children: [
                        "Island : ".text.size(16).color(Colors.black54).make(),
                        DropdownButton<String>(
                          value: model.selectedIsland(),

                          icon: const SizedBox(),
                          // elevation: 16,
                          // style: const TextStyle(color: Colors.deepPurple),
                          underline: Container(
                            height: 0,
                            color: Colors.transparent,
                          ),
                          onChanged: (String? value) {
                            if (value != null) {
                              model.selectedIsland.value = value;
                            }
                          },
                          items: getIslandList(model.selectedAtoll())
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ).expand(),
                      ],
                    ).px12(),
                  ),
                ),
                5.heightBox,
                TextField(
                  controller: model.addressTxt,
                  decoration: textFieldDefault.copyWith(labelText: "Address"),
                ),
                5.heightBox,
                TextField(
                  maxLength: 150,
                  minLines: 2,
                  maxLines: 10,
                  controller: model.noteTxt,
                  decoration: textFieldDefault.copyWith(labelText: "Note"),
                ),
              ],
            ).p8(),
          ),
          10.heightBox,
          Obx(
            () => model.authCore.firebaseUser.value != null
                ? Row(
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                        onPressed: () {
                          model.checkout();
                        },
                        child: 'Checkout'.text.size(16).bold.white.make().p8(),
                      ).expand(),
                    ],
                  )
                : Row(
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                        onPressed: () {
                          loginAlert(context, model.authCore);
                        },
                        child: 'Login'.text.size(16).bold.white.make().p8(),
                      ).expand(),
                    ],
                  ),
          ),
          10.heightBox,
        ],
      ).px12(),
      context: context);
}
