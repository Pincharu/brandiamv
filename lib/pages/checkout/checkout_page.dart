import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/app_colors.dart';
import '../../shared/textfield.dart';
import 'checkout_core.dart';
import 'package:velocity_x/velocity_x.dart';

import '../cart/cart_core.dart';

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var model = Get.put<CheckoutCore>(CheckoutCore());
    var cart = Get.find<CartCore>();

    return Scaffold(
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          20.heightBox,
          Row(
            children: [
              IconButton(onPressed: () => Get.back(), icon: const Icon(Icons.arrow_back)),
              "Checkout".text.size(20).bold.make(),
            ],
          ),
          20.heightBox,
          "Order Info".text.size(20).bold.make(),
          10.heightBox,
          VxBox(
            child: Column(
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemCount: cart.cartList.length,
                  itemBuilder: (BuildContext ctx, int i) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        "${cart.cartList[i].name} x${cart.cartList[i].quantity}"
                            .text
                            .size(18)
                            .make(),
                        (cart.cartList[i].price * cart.cartList[i].quantity)
                            .toStringAsFixed(2)
                            .text
                            .size(18)
                            .make(),
                      ],
                    );
                  },
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    "Toal".text.size(18).bold.make(),
                    model.calculateTotal(cart.cartList).text.size(18).bold.make(),
                  ],
                ),
              ],
            ).p12(),
          ).white.roundedSM.make(),
          // 20.heightBox,
          // "Delivery Method".text.size(20).bold.make(),
          // 10.heightBox,
          // Obx(
          //   () => VxBox(
          //     child: Column(
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       children: [
          //         Row(
          //           children: [
          //             ElevatedButton(
          //               style: ElevatedButton.styleFrom(
          //                   backgroundColor:
          //                       model.method.value == 1 ? Colors.orange : Colors.white),
          //               onPressed: () {
          //                 model.method.value = 1;
          //                 model.payment.value = 1;
          //                 model.address.value = true;
          //               },
          //               child: model.method.value == 1
          //                   ? "Delivery".text.size(18).bold.make().py12()
          //                   : "Delivery".text.size(18).black.make().py12(),
          //             ).expand(),
          //             5.widthBox,
          //             ElevatedButton(
          //               style: ElevatedButton.styleFrom(
          //                   backgroundColor:
          //                       model.method.value == 2 ? Colors.orange : Colors.white),
          //               onPressed: () {
          //                 model.method.value = 2;
          //                 model.address.value = false;
          //               },
          //               child: model.method.value == 2
          //                   ? "Pickup".text.size(18).bold.make().py12()
          //                   : "Pickup".text.size(18).black.make().py12(),
          //             ).expand(),
          //           ],
          //         ),
          //         5.heightBox,
          //         "Delivery can only be made to Male' / Hulhumale".text.size(14).make(),
          //       ],
          //     ).p12(),
          //   ).white.roundedSM.make(),
          // ),
          20.heightBox,
          "Location".text.size(20).bold.make(),
          10.heightBox,
          Obx(
            () => model.address.value
                ? VxBox(
                    child: Row(
                      children: [
                        VxBox(child: const Icon(Icons.map_rounded).centered())
                            .shadowSm
                            .roundedSM
                            .white
                            .make()
                            .h(50)
                            .w(50),
                        10.widthBox,
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            model.addressTxt.text == ''
                                ? "Select Address".text.bold.size(16).make()
                                : model.addressString.value.text.bold.size(16).make(),
                            (model.place.value != 0)
                                ? model.place.value == 1
                                    ? "Male', Maldives".text.size(16).make()
                                    : "Hulhumale', Maldives".text.size(16).make()
                                : "Select Place".text.size(16).make()
                          ],
                        )),
                        model.address.value
                            ? const Icon(Icons.arrow_forward_ios)
                            : const Icon(Icons.copy, size: 18)
                      ],
                    ).p12(),
                  ).white.roundedSM.make().onInkTap(() {
                    addressDrawer(context, model);
                  })
                : VxBox(
                    child: Row(
                      children: [
                        VxBox(child: const Icon(Icons.map_rounded).centered())
                            .shadowSm
                            .roundedSM
                            .white
                            .make()
                            .h(50)
                            .w(50),
                        10.widthBox,
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            model.address.value
                                ? "Select Place".text.bold.size(16).make()
                                : "H. Ranvehi, Violet Magu, Male’".text.size(16).make(),
                            // "Male', Maldives".text.size(14).make(),
                          ],
                        )),
                        model.address.value ? const Icon(Icons.arrow_forward_ios) : const SizedBox()
                      ],
                    ).p12(),
                  ).white.roundedSM.make(),
          ),
          20.heightBox,
          "Transfer Details".text.size(20).bold.make(),
          VxBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                "BML Account".text.size(18).bold.make(),
                10.heightBox,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    "Ali Ruwan (MVR)".text.size(18).make(),
                    Row(
                      children: [
                        "7704264311101".text.size(18).make(),
                        5.widthBox,
                        const Icon(Icons.copy, size: 18)
                      ],
                    ).onInkTap(() {}),
                  ],
                ),
                10.heightBox,
                Obx(
                  () => model.image.value != null
                      ? Image.network(model.image.value!.path).p12()
                      : const SizedBox(),
                ),
                Row(children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                    onPressed: () => model.getImage(),
                    child: "UPLOAD TRANSFER SLIP".text.size(16).white.bold.make().p12(),
                  ).expand()
                ])
              ],
            ).p12(),
          ).white.roundedSM.make()
        ],
      ).px12(),
      bottomNavigationBar: Obx(
        () => Row(children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            onPressed: model.checkoutActive()
                ? () => model.checkout(cart.cartList, "MVR ${model.calculateTotal(cart.cartList)}")
                : null,
            child: "CONFIRM (MVR ${model.calculateTotal(cart.cartList)})"
                .text
                .size(18)
                .white
                .make()
                .p12(),
          ).expand()
        ]).p12(),
      ),
    );
  }
}

Future addressDrawer(BuildContext context, CheckoutCore model) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Delivery Address", style: TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: model.addressTxt,
              onChanged: (value) => model.addressString.value = value,
              decoration: textFieldDefault.copyWith(labelText: "Address"),
            ),
            10.heightBox,
            SizedBox(
              height: 70,
              width: 500,
              child: Obx(
                () => Row(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: model.place.value == 1 ? Colors.orange : Colors.white),
                      onPressed: () => model.place.value = 1,
                      child: model.place.value == 1
                          ? "Male".text.size(18).bold.white.make().py12()
                          : "Male".text.size(18).black.make().py12(),
                    ).expand(),
                    5.widthBox,
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: model.place.value == 2 ? Colors.orange : Colors.white),
                      onPressed: () => model.place.value = 2,
                      child: model.place.value == 2
                          ? "Hulhumale".text.size(18).bold.white.make().py12()
                          : "Hulhumale".text.size(18).black.make().py12(),
                    ).expand(),
                  ],
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(backgroundColor: kcolorOrange),
            onPressed: () => Get.back(),
            child: const Padding(
              padding: EdgeInsets.all(12),
              child: Text("Save", style: TextStyle(color: Colors.white, fontSize: 14)),
            ),
          ),
        ],
      );
    },
  );
}
