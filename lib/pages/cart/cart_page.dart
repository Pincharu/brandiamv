import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:side_sheet/side_sheet.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../app/app_colors.dart';
import '../checkout/checkout_page.dart';
import 'cart_core.dart';

class CartPage extends StatelessWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var model = Get.put<CartCore>(CartCore());

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          20.heightBox,
          "Cart".text.size(20).bold.make(),
          10.heightBox,
          Obx(() => model.cartList.isNotEmpty
              ? ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: model.cartList.length,
                  itemBuilder: (ctx, i) {
                    var currentCart = model.cartList[i];
                    return VxBox(
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              height: 80,
                              width: 80,
                              decoration: const BoxDecoration(
                                  gradient: LinearGradient(colors: [
                                Colors.white,
                                Color.fromARGB(221, 214, 214, 214),
                              ], begin: Alignment.topLeft, end: Alignment.bottomRight)),
                              child: FadeInImage.memoryNetwork(
                                placeholder: kTransparentImage,
                                image: currentCart.image,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          10.widthBox,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  currentCart.name.text.size(18).bold.make(),
                                  "MVR ${currentCart.price * currentCart.quantity}"
                                      .text
                                      .size(16)
                                      .make(),
                                ],
                              ),
                              "MVR ${currentCart.price}".text.size(16).make(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    color: Colors.white,
                                    child: VxStepper(
                                      defaultValue: currentCart.quantity,
                                      disableInput: true,
                                      min: 1,
                                      onChange: (value) => model.updateItem(currentCart.id, value),
                                    ).p4(),
                                  ),
                                  Container(
                                    color: Colors.white,
                                    child: Center(
                                      child: IconButton(
                                        onPressed: () => model.deleteItem(currentCart.id),
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ).expand()
                        ],
                      ).p20(),
                    ).rounded.color(Colors.grey[300]!).make().pOnly(bottom: 4).onInkTap(() {});
                  },
                ).expand()
              : VxBox(
                      child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: ["Looks like there are no Products".text.size(20).make()],
                ).p20())
                  .roundedSM
                  .color(Colors.orange[300]!)
                  .make()
                  .p12()),
          Obx(
            () => model.cartList.isNotEmpty
                ? Row(
                    children: [
                      ElevatedButton(
                              onPressed: () {
                                Get.back();
                                SideSheet.right(
                                    width: context.screenWidth > 600 ? 600 : context.screenWidth,
                                    barrierColor: kcolorOrange.withOpacity(.8),
                                    body: const CheckoutPage(),
                                    context: context);
                                //Get.toNamed(Routes.checkout);
                              },
                              child: "Checkout".text.white.size(18).make().p12())
                          .expand()
                    ],
                  )
                : const SizedBox(),
          )
        ],
      ).p20(),
    );
  }
}
