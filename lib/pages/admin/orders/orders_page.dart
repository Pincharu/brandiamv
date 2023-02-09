import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../shared/sync_report.dart';
import '../../../shared/textfield.dart';
import 'orders_core.dart';

class AdminOrdersPage extends StatelessWidget {
  const AdminOrdersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var model = Get.put<AdminOrdersCore>(AdminOrdersCore());

    return Scaffold(
      body: Obx(
        () => model.ordersList.isNotEmpty
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
                          model.prices.add(
                              TextEditingController(text: order.products[aa]['price'].toString()));
                          orderTotal.value = orderTotal.value +
                              (order.products[aa]['quantity'] *
                                  double.parse(order.products[aa]['price'].toString()));
                        }
                      },
                      children: [
                        5.heightBox,
                        "Name: ${order.name}".text.size(16).make().px12(),
                        "Address: ${order.atoll}, ${order.island}".text.size(16).make().px12(),
                        "Note: ${order.note}".selectableText.size(16).make().px12(),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: order.products.length,
                          itemBuilder: (BuildContext ctx, int z) {
                            return ListTile(
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  "Name: ${order.products[z]['name']}"
                                      .toString()
                                      .text
                                      .size(16)
                                      .make(),
                                  "Quantity: ${order.products[z]['quantity']}"
                                      .toString()
                                      .text
                                      .size(16)
                                      .make(),
                                  "Total ${(order.products[z]['quantity']) * double.parse((model.prices[z].text == '') ? "0" : model.prices[z].text)}"
                                      .text
                                      .size(16)
                                      .make(),
                                  10.heightBox,
                                ],
                              ),
                              subtitle: SizedBox(
                                height: 60,
                                width: 240,
                                child: Row(
                                  children: [
                                    TextField(
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
                                    ).expand()
                                  ],
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
                                          orderTotal.value += (order.products[j]['quantity'] *
                                              double.parse((model.prices[j].text == '')
                                                  ? "0"
                                                  : model.prices[j].text));
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
                              if (order.pdf != null)
                                ElevatedButton(
                                        onPressed: () {
                                          launchUrlString(order.pdf!);
                                        },
                                        child: "Download receipt".text.size(18).bold.make().p4())
                                    .px12(),
                              "Total: MVR ${orderTotal.value}".text.size(18).bold.make().p4(),
                            ],
                          ),
                        ),
                        10.heightBox,
                      ],
                    ),
                  ).white.roundedSM.make().pOnly(bottom: 12, top: (i == 0) ? 20 : 0);
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
      ),
    );
  }
}
