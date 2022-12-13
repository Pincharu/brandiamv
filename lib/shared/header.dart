import 'package:brandiamv/shared/textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:side_sheet/side_sheet.dart';
import 'package:velocity_x/velocity_x.dart';

import '../app/app_colors.dart';
import '../app/app_routing.dart';
import '../pages/cart/cart_page.dart';
import '../pages/login/authcore.dart';

class AppHeader extends StatelessWidget {
  final int page;
  final Color? color;
  const AppHeader({Key? key, required this.page, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var authCore = Get.find<AuthCore>();
    userLogged(authCore);

    return Container(
      color: color ?? Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              10.widthBox,

              if (context.screenWidth < 550) 10.widthBox,
              "Rasdhooni"
                  .text
                  .size(20)
                  .color(kcolorOrange)
                  .bold
                  .make()
                  .p12()
                  .onInkTap(() => Get.toNamed(Routes.main)),
              // const ImagePlacer(
              //   image: 'assets/logo_transparent.png',
              //   height: 40,
              //   width: 80,
              // ),
            ],
          ),
          if (context.screenWidth > 550)
            Obx(
              () => authCore.firestoreUser.value != null
                  ? Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      page == 0
                          ? "SHOP".text.size(16).color(kcolorOrange).bold.make().p8()
                          : "SHOP"
                              .text
                              .size(16)
                              .black
                              .make()
                              .p8()
                              .onInkTap(() => Get.toNamed(Routes.main)),
                      30.widthBox,
                      page == 1
                          ? "ORDERS".text.size(16).color(kcolorOrange).bold.make().p8()
                          : "ORDERS"
                              .text
                              .size(16)
                              .black
                              .make()
                              .p8()
                              .onInkTap(() => Get.toNamed(Routes.orders)),
                      30.widthBox,
                      page == 2
                          ? "Contact".text.size(16).color(kcolorOrange).bold.make().p8()
                          : "Contact"
                              .text
                              .size(16)
                              .black
                              .make()
                              .p8()
                              .onInkTap(() => Get.toNamed(Routes.contact)),
                      30.widthBox,
                      10.widthBox,
                    ])
                  : Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      page == 0
                          ? "SHOP".text.size(16).color(kcolorOrange).bold.make().p12()
                          : "SHOP".text.size(16).black.make().p12().onInkTap(() {
                              Get.back();
                              Get.toNamed(Routes.main);
                            }),
                      10.widthBox,
                      page == 2
                          ? "Contact".text.size(16).color(kcolorOrange).bold.make().p8()
                          : "Contact"
                              .text
                              .size(16)
                              .black
                              .make()
                              .p8()
                              .onInkTap(() => Get.toNamed(Routes.contact)),
                      30.widthBox,
                      VxBox(child: "Login".text.size(18).white.make().pSymmetric(h: 20, v: 8))
                          .roundedLg
                          .color(kcolorOrange)
                          .make()
                          .onInkTap(() {
                        loginAlert(context, authCore);
                      }),
                      10.widthBox,
                    ]),
            )
        ],
      ),
    );
  }
}

registerAlert(BuildContext context, AuthCore authCore) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Register", style: TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: authCore.nameController,
              decoration: textFieldDefault.copyWith(labelText: "Name"),
            ),
            10.heightBox,
            TextField(
              controller: authCore.phoneController,
              decoration: textFieldDefault.copyWith(labelText: "Phone"),
            ),
            10.heightBox,
            TextField(
              controller: authCore.emailController,
              decoration: textFieldDefault.copyWith(labelText: "(Login) Email"),
            ),
            10.heightBox,
            TextField(
              controller: authCore.passwordController,
              obscureText: true,
              decoration: textFieldDefault.copyWith(labelText: "(Login) Password"),
            ),
          ],
        ),
        actions: [
          Row(
            children: [
              TextButton(
                style: TextButton.styleFrom(backgroundColor: kcolorOrange),
                onPressed: () async {
                  authCore.registerWithEmailAndPassword();
                  Get.back();
                },
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("Register", style: TextStyle(color: Colors.white)),
                ),
              ),
              TextButton(
                onPressed: () => Get.back(),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("Cancel", style: TextStyle(color: Colors.black54)),
                ),
              ),
            ],
          )
        ],
      );
    },
  );
}

loginAlert(BuildContext context, AuthCore authCore) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Login", style: TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: authCore.emailController,
              decoration: textFieldDefault.copyWith(labelText: "Email"),
            ),
            10.heightBox,
            TextField(
              controller: authCore.passwordController,
              obscureText: true,
              decoration: textFieldDefault.copyWith(labelText: "Password"),
            ),
          ],
        ),
        actions: [
          Row(
            children: [
              TextButton(
                style: TextButton.styleFrom(backgroundColor: kcolorOrange),
                onPressed: () async {
                  authCore.signInWithEmailAndPassword();
                  Get.back();
                },
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("Login", style: TextStyle(color: Colors.white)),
                ),
              ),
              TextButton(
                onPressed: () {
                  Get.back();
                  registerAlert(context, authCore);
                },
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("Register", style: TextStyle(color: Colors.black54)),
                ),
              ),
            ],
          )
        ],
      );
    },
  );
}

Future userLogged(authCore) async {
  final FirebaseAuth auth = FirebaseAuth.instance;
  await Future.delayed(const Duration(milliseconds: 300), () async {
    if (auth.currentUser != null) {
      authCore.onReady();
    }
  });

  await Future.delayed(const Duration(seconds: 2), () async {
    if (auth.currentUser != null) {
      authCore.onReady();
    }
  });
}

cartDrawer(BuildContext context) {
  return SideSheet.right(
      width: context.screenWidth > 600 ? 600 : context.screenWidth,
      barrierColor: kcolorOrange.withOpacity(.8),
      body: const CartPage(),
      context: context);
}
