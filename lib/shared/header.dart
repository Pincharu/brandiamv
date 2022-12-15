import 'textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:velocity_x/velocity_x.dart';

import '../app/app_colors.dart';
import '../app/app_routing.dart';
import 'authcore.dart';

class AppHeader extends StatelessWidget {
  const AppHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var authCore = Get.find<AuthCore>();
    userLogged(authCore);

    return Obx(
      () => authCore.firebaseUser.value != null ? loggedHeader(context) : loggedOutHeader(context),
    ).pOnly(top: 10);
  }
}

Widget loggedHeader(BuildContext context) {
  var authCore = Get.find<AuthCore>();

  return context.screenWidth <= 850
      ? Column(
          children: [
            "Brandiamv".text.size(20).white.bold.make(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, elevation: 0),
                    onPressed: () async {
                      final Uri url = Uri.parse('tel:7771898');
                      if (!await launchUrl(url)) {
                        throw 'Could not launch $url';
                      }
                    },
                    child: const Icon(Icons.phone, size: 14).p8()),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, elevation: 0),
                    onPressed: () async {
                      final Uri url = Uri.parse('https://api.whatsapp.com/send?phone=+9607771898');
                      if (!await launchUrl(url)) {
                        throw 'Could not launch $url';
                      }
                    },
                    child: const Icon(Icons.whatsapp, size: 14).p8()),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, elevation: 0),
                    onPressed: () {
                      Get.toNamed(Routes.main);
                    },
                    child: const Icon(Icons.home, size: 14).p8()),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, elevation: 0),
                    onPressed: () {
                      Get.toNamed(Routes.orders);
                    },
                    child: const Icon(Icons.newspaper, size: 14).p8()),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, elevation: 0),
                    onPressed: () async {
                      await authCore.signOut();
                      Get.offAllNamed(Routes.main);
                    },
                    child: const Icon(Icons.logout, size: 14).p8()),
              ],
            ).px12(),
          ],
        )
      : Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            "Brandiamv".text.size(20).white.bold.make(),
            Row(
              children: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, elevation: 0),
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
                        "Call us".text.white.size(14).make(),
                      ],
                    ).p12()),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, elevation: 0),
                    onPressed: () async {
                      final Uri url = Uri.parse('https://api.whatsapp.com/send?phone=+9607771898');
                      if (!await launchUrl(url)) {
                        throw 'Could not launch $url';
                      }
                    },
                    child: Row(
                      children: [
                        const Icon(Icons.whatsapp, size: 14),
                        5.widthBox,
                        "Whatsapp".text.white.size(14).make(),
                      ],
                    ).p12()),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, elevation: 0),
                    onPressed: () {
                      Get.toNamed(Routes.main);
                    },
                    child: Row(
                      children: [
                        const Icon(Icons.home, size: 14),
                        5.widthBox,
                        "Home".text.white.size(14).make(),
                      ],
                    ).p12()),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, elevation: 0),
                    onPressed: () {
                      Get.toNamed(Routes.orders);
                    },
                    child: Row(
                      children: [
                        const Icon(Icons.newspaper, size: 14),
                        5.widthBox,
                        "Orders".text.white.size(14).make(),
                      ],
                    ).p12()),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, elevation: 0),
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
            ),
          ],
        ).px12();
}

Widget loggedOutHeader(BuildContext context) {
  var authCore = Get.find<AuthCore>();

  return context.screenWidth <= 850
      ? Column(
          children: [
            "Brandiamv".text.size(20).white.bold.make(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, elevation: 0),
                    onPressed: () async {
                      final Uri url = Uri.parse('tel:7771898');
                      if (!await launchUrl(url)) {
                        throw 'Could not launch $url';
                      }
                    },
                    child: const Icon(Icons.phone, size: 14).p8()),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, elevation: 0),
                    onPressed: () async {
                      final Uri url = Uri.parse('https://api.whatsapp.com/send?phone=+9607771898');
                      if (!await launchUrl(url)) {
                        throw 'Could not launch $url';
                      }
                    },
                    child: const Icon(Icons.whatsapp, size: 14).p8()),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, elevation: 0),
                    onPressed: () {
                      loginAlert(context, authCore);
                    },
                    child: "Login".text.bold.white.size(14).make().p12()),
              ],
            ).px12(),
          ],
        )
      : Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            "Brandiamv".text.size(20).white.bold.make(),
            Row(
              children: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, elevation: 0),
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
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, elevation: 0),
                    onPressed: () async {
                      final Uri url = Uri.parse('https://api.whatsapp.com/send?phone=+9607771898');
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
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, elevation: 0),
                    onPressed: () {
                      loginAlert(context, authCore);
                    },
                    child: "Login".text.bold.white.size(14).make().p12()),
              ],
            )
          ],
        ).px12();
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
