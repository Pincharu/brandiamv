import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../app/app_routing.dart';
import '../../../shared/header.dart';
import '../../../shared/authcore.dart';
import 'admin_orders_core.dart';

class AdminOrdersPage extends StatelessWidget {
  const AdminOrdersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var model = Get.put<AdminOrdersCore>(AdminOrdersCore());
    var authCore = Get.find<AuthCore>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
        title: "Admin Orders".text.size(20).bold.make(),
      ),
      body: Column(children: [
        20.heightBox,
        Obx(
          () => authCore.firebaseUser.value != null
              ? authCore.getUser == 'QqQaGjdHO4OcYlie5YcmNfuttW03'
                  ? Obx(
                      () => model.ordersList.isNotEmpty
                          ? ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              itemCount: model.ordersList.length,
                              itemBuilder: (BuildContext ctx, int i) {
                                var order = model.ordersList[i];
                                return VxBox(
                                  child: ExpansionTile(
                                    backgroundColor: Colors.white,
                                    expandedCrossAxisAlignment: CrossAxisAlignment.start,
                                    title: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        "# ${order.id}".text.size(16).make(),
                                        "Order Received".text.size(18).bold.make(),
                                      ],
                                    ).py12(),
                                    children: [
                                      5.heightBox,
                                      ListView.builder(
                                        shrinkWrap: true,
                                        physics: const NeverScrollableScrollPhysics(),
                                        itemCount: order.products.length,
                                        itemBuilder: (BuildContext ctx, int z) {
                                          return Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              "${order.products[z]['name']} x${order.products[z]['quantity']}"
                                                  .toString()
                                                  .text
                                                  .size(14)
                                                  .make(),
                                              "MVR ${order.products[z]['price'] * order.products[z]['quantity']}"
                                                  .toString()
                                                  .text
                                                  .size(14)
                                                  .make(),
                                            ],
                                          );
                                        },
                                      ).px12(),
                                      const Divider().px12(),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          "Total".text.size(18).bold.make(),
                                          order.total.text.size(18).bold.make(),
                                        ],
                                      ).px12(),
                                      10.heightBox,
                                    ],
                                  ),
                                ).white.roundedSM.make().pOnly(bottom: 12);
                              },
                            ).px20()
                          : VxBox(
                                  child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: ["Looks like there are no Orders".text.size(20).make()],
                            ).p20())
                              .roundedSM
                              .color(Colors.blue[300]!)
                              .makeCentered()
                              .p12()
                              .centered(),
                    ).expand()
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        "Not logged in as admin".text.size(20).make(),
                        20.widthBox,
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue, elevation: 0),
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
      ]),
    );
  }
}
