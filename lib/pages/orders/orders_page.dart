import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../app/app_routing.dart';
import '../../shared/footer.dart';
import '../../shared/header.dart';
import '../login/authcore.dart';
import 'orders_core.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var model = Get.put<OrdersCore>(OrdersCore());
    var authCore = Get.find<AuthCore>();

    return Scaffold(
       appBar: AppBar(
        backgroundColor: Colors.blue,
        toolbarHeight: 120,
        elevation: 0,
        flexibleSpace: SizedBox(
          width: context.screenWidth < 1200 ? context.screenWidth : 1200,
          child: Column(
            children: [
              10.heightBox,
              Obx(
                () => authCore.firebaseUser.value != null
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          "Brandiamv".text.size(20).white.bold.make(),
                          Row(
                            children: [
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue, elevation: 0),
                                  onPressed: () async {
                                    final Uri url = Uri.parse('tel:7771898');
                                    if (!await launchUrl(url)) {
                                      throw 'Could not launch $url';
                                    }
                                  },
                                  child: Row(
                                    children: [
                                      const Icon(Icons.phone, size: 14),
                                      5.widthBox,
                                      "Call us".text.bold.white.size(14).make(),
                                    ],
                                  ).p12()),
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue, elevation: 0),
                                  onPressed: () async {
                                    final Uri url = Uri.parse(
                                        'https://api.whatsapp.com/send?phone=+9607771898');
                                    if (!await launchUrl(url)) {
                                      throw 'Could not launch $url';
                                    }
                                  },
                                  child: Row(
                                    children: [
                                      const Icon(Icons.whatsapp, size: 14),
                                      5.widthBox,
                                      "Whatsapp".text.bold.white.size(14).make(),
                                    ],
                                  ).p12()),
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue, elevation: 0),
                                  onPressed: () {
                                    Get.toNamed(Routes.main);

                                  },
                                  child: Row(
                                    children: [
                                      const Icon(Icons.home, size: 14),
                                      5.widthBox,
                                      "Home".text.bold.white.size(14).make(),
                                    ],
                                  ).p12()),
                               ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue, elevation: 0),
                                  onPressed: () {
                                    Get.toNamed(Routes.orders);

                                  },
                                  child: Row(
                                    children: [
                                      const Icon(Icons.newspaper, size: 14),
                                      5.widthBox,
                                      "Orders".text.bold.white.size(14).make(),
                                    ],
                                  ).p12()),
                            ],
                          )
                        ],
                      ).px12()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          "Brandiamv".text.size(20).white.bold.make(),
                          Row(
                            children: [
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue, elevation: 0),
                                  onPressed: () async {
                                    final Uri url = Uri.parse('tel:7771898');
                                    if (!await launchUrl(url)) {
                                      throw 'Could not launch $url';
                                    }
                                  },
                                  child: Row(
                                    children: [
                                      const Icon(Icons.phone, size: 14),
                                      5.widthBox,
                                      "Call us".text.bold.white.size(14).make(),
                                    ],
                                  ).p12()),
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue, elevation: 0),
                                  onPressed: () async {
                                    final Uri url = Uri.parse(
                                        'https://api.whatsapp.com/send?phone=+9607771898');
                                    if (!await launchUrl(url)) {
                                      throw 'Could not launch $url';
                                    }
                                  },
                                  child: Row(
                                    children: [
                                      const Icon(Icons.whatsapp, size: 14),
                                      5.widthBox,
                                      "Whatsapp".text.bold.white.size(14).make(),
                                    ],
                                  ).p12()),
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue, elevation: 0),
                                  onPressed: () {
                                    loginAlert(context, authCore);
                                  },
                                  child: "Login".text.bold.white.size(14).make().p12()),
                            ],
                          )
                        ],
                      ).px12(),
              ),
             
            ],
          ),
        ),
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
                          onPressed: () {
                            loginAlert(context, model.auth);
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
          ).expand(),
        ],
      ),
    );
  }
}
