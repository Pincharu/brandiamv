import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

import '../app/app_colors.dart';
import '../app/app_routing.dart';
import '../pages/login/authcore.dart';
import 'header.dart';

class AppFooter extends StatelessWidget {
  final int page;
  const AppFooter({Key? key, required this.page}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var authCore = Get.find<AuthCore>();

    return Container(
      color: kcolorOrangeAccent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              30.heightBox,
              "Rashdhooni".text.size(20).black.bold.make().p12(),
              "Get Authentic Maldivian Hand crafted products"
                  .text
                  .size(16)
                  .black
                  .make()
                  .p12()
                  .onInkTap(() {
                Get.back();
                Get.toNamed(Routes.main);
              }),
              40.widthBox,
              Row(
                children: [
                  IconButton(onPressed: () {}, icon: const Icon(Icons.facebook)),
                  10.widthBox,
                  IconButton(onPressed: () {}, icon: const Icon(Icons.face)),
                  10.widthBox,
                  IconButton(onPressed: () {}, icon: const Icon(Icons.facebook)),
                ],
              ),
              if (context.screenWidth < 750) 40.heightBox,
              if (context.screenWidth < 750)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(() => authCore.firestoreUser.value != null
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              30.heightBox,
                              "Shop"
                                  .text
                                  .size(16)
                                  .black
                                  .make()
                                  .p12()
                                  .onInkTap(() => Get.toNamed(Routes.main)),
                              "Orders"
                                  .text
                                  .size(16)
                                  .black
                                  .make()
                                  .p12()
                                  .onInkTap(() => Get.toNamed(Routes.orders)),
                              "Cart"
                                  .text
                                  .size(16)
                                  .black
                                  .make()
                                  .p12()
                                  .onInkTap(() => cartDrawer(context)),
                              "Account"
                                  .text
                                  .size(16)
                                  .black
                                  .make()
                                  .p12()
                                  .onInkTap(() => Get.toNamed(Routes.contact)),
                              30.heightBox,
                            ],
                          )
                        : const SizedBox()),
                    "About"
                        .text
                        .size(16)
                        .black
                        .make()
                        .p12()
                        .onInkTap(() => Get.toNamed(Routes.about)),
                    "Contact us"
                        .text
                        .size(16)
                        .black
                        .make()
                        .p12()
                        .onInkTap(() => Get.toNamed(Routes.contact)),
                    "Terms & Conditions"
                        .text
                        .size(16)
                        .black
                        .make()
                        .p12()
                        .onInkTap(() => Get.toNamed(Routes.terms)),
                    "Privacy Policy"
                        .text
                        .size(16)
                        .black
                        .make()
                        .p12()
                        .onInkTap(() => Get.toNamed(Routes.privacy)),
                    30.heightBox,
                  ],
                ),
            ],
          ).flexible(),
          if (context.screenWidth > 750)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(
                  () => authCore.firestoreUser.value != null
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            30.heightBox,
                            "Shop"
                                .text
                                .size(16)
                                .black
                                .make()
                                .p12()
                                .onInkTap(() => Get.toNamed(Routes.main)),
                            "Orders"
                                .text
                                .size(16)
                                .black
                                .make()
                                .p12()
                                .onInkTap(() => Get.toNamed(Routes.orders)),
                            "Cart"
                                .text
                                .size(16)
                                .black
                                .make()
                                .p12()
                                .onInkTap(() => cartDrawer(context)),
                            "Account"
                                .text
                                .size(16)
                                .black
                                .make()
                                .p12()
                                .onInkTap(() => Get.toNamed(Routes.contact)),
                            30.heightBox,
                          ],
                        )
                      : const SizedBox(),
                ),
                10.widthBox,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    30.heightBox,
                    "About"
                        .text
                        .size(16)
                        .black
                        .make()
                        .p12()
                        .onInkTap(() => Get.toNamed(Routes.about)),
                    "Contact us"
                        .text
                        .size(16)
                        .black
                        .make()
                        .p12()
                        .onInkTap(() => Get.toNamed(Routes.contact)),
                    "Terms & Conditions"
                        .text
                        .size(16)
                        .black
                        .make()
                        .p12()
                        .onInkTap(() => Get.toNamed(Routes.terms)),
                    "Privacy Policy"
                        .text
                        .size(16)
                        .black
                        .make()
                        .p12()
                        .onInkTap(() => Get.toNamed(Routes.privacy)),
                    30.heightBox,
                  ],
                ),
                10.widthBox,
              ],
            ),
        ],
      ).p32(),
    );
  }
}
