import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../shared/header.dart';
import '../../../shared/authcore.dart';
import '../../../shared/sync_report.dart';
import '../../../shared/textfield.dart';
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
        title: "Orders".text.size(20).bold.make(),
      ),
      body: Column(
        children: [
          20.heightBox,
          Obx(
            () => model.auth.firebaseUser.value == null
                ? VxBox(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        "Please login to view orders".text.size(20).bold.makeCentered(),
                        10.heightBox,
                        ElevatedButton(
                          onPressed: () async {
                            await loginAlert(context, model.auth);
                            model.onInit();
                          },
                          child: "Sign in".text.size(20).make().p12(),
                        ).centered(),
                      ],
                    ).p20(),
                  ).roundedSM.white.makeCentered().p20()
                : model.ordersList.isNotEmpty
                    ? ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: model.ordersList.length,
                        itemBuilder: (BuildContext ctx, int i) {
                          var order = model.ordersList[i];
                          var orderTotal = 0.0.obs;

                          return VxBox(
                            child: ExpansionTile(
                              backgroundColor: Colors.white,
                              expandedCrossAxisAlignment: CrossAxisAlignment.start,
                              leading: order.read
                                  ? null
                                  : VxBox(child: "New".text.size(16).white.bold.make().p12())
                                      .color(Colors.red)
                                      .roundedSM
                                      .make(),
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  "# ${order.id}".text.size(16).make(),
                                  "Order Received".text.size(18).bold.make(),
                                ],
                              ).py12(),
                              onExpansionChanged: (value) {
                                orderTotal.value = 0;
                                for (var aa = 0; i < order.products.length; aa++) {
                                  model.prices.add(TextEditingController(
                                      text: order.products[aa]['price'].toString()));
                                  orderTotal.value = orderTotal.value +
                                      (order.products[aa]['quantity'] *
                                          double.parse(order.products[aa]['price'].toString()));
                                }
                              },
                              children: [
                                5.heightBox,
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: order.products.length,
                                  itemBuilder: (BuildContext ctx, int z) {
                                    return ListTile(
                                      title: "Name: ${order.products[z]['name']}"
                                          .toString()
                                          .text
                                          .size(16)
                                          .make(),
                                      subtitle: "Quantity: ${order.products[z]['quantity']}"
                                          .toString()
                                          .text
                                          .size(16)
                                          .make(),
                                      trailing: SizedBox(
                                        height: 60,
                                        width: 120,
                                        child: TextField(
                                          controller: model.prices[z],
                                          decoration:
                                              textFieldDefault.copyWith(labelText: "Price / Pcs"),
                                          onChanged: (value) {
                                            orderTotal.value = 0;
                                            for (var j = 0; j < order.products.length; j++) {
                                              orderTotal.value += (order.products[j]['quantity'] *
                                                  double.parse((model.prices[j].text == '')
                                                      ? "0"
                                                      : model.prices[j].text));
                                            }
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                ).px12(),
                                const Divider().px12(),
                                Obx(
                                  () => ButtonBar(
                                    children: [
                                      ElevatedButton(
                                              onPressed: () {
                                                model.saveProducts(order);
                                                orderTotal.value = 0;
                                                for (var j = 0; j < order.products.length; j++) {
                                                  orderTotal.value += double.parse(
                                                      (model.prices[j].text == '')
                                                          ? "0"
                                                          : model.prices[j].text);
                                                }
                                              },
                                              child: "Save".text.size(18).bold.make().p4())
                                          .p4(),
                                      ElevatedButton(
                                              onPressed: () {
                                                generatePDF(order);
                                              },
                                              child: "Share".text.size(18).bold.make().p4())
                                          .p4(),
                                      "Total: MVR ${orderTotal.value}"
                                          .text
                                          .size(18)
                                          .bold
                                          .make()
                                          .p4(),
                                    ],
                                  ),
                                ),
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
          ).expand(),
        ],
      ),
    );
  }
}
