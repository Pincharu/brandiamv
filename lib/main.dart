import 'shared/loading.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:get/get.dart';

import 'app/app_colors.dart';
import 'app/app_routing.dart';
import 'shared/authcore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyA5_hYk1RdnPk5CA4-QetZAW_QwuMGKk3E",
          authDomain: "brandiamv.firebaseapp.com",
          projectId: "brandiamv",
          storageBucket: "brandiamv.appspot.com",
          messagingSenderId: "291098537897",
          appId: "1:291098537897:web:90c5fc1620b2af723c9eb8",
          measurementId: "G-2D8PRJRHWJ"),
    );
    // setPathUrlStrategy();
  } else {
    await Firebase.initializeApp();
  }

  // await Firebase.initializeApp();
  // await FirebaseMessaging.instance
  //     .setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Loading(
      child: GetMaterialApp(
        title: 'Brandiamv',
        initialRoute: "/",
        getPages: AppRoutes.routes,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          fontFamily: 'Poppins',
          scaffoldBackgroundColor: kcolorbg,
          snackBarTheme: const SnackBarThemeData(
            backgroundColor: Colors.red,
            actionTextColor: Colors.white,
          ),
        ),
        initialBinding: BindingsController(),
      ),
    );
  }
}

class BindingsController implements Bindings {
  @override
  void dependencies() {
    Get.put<AuthCore>(AuthCore());
  }
}


// darkTheme: ThemeData(
//   primarySwatch: Colors.orange,
//   visualDensity: VisualDensity.adaptivePlatformDensity,
//   fontFamily: 'Poppins',
//   brightness: Brightness.light,
//   snackBarTheme: const SnackBarThemeData(
//     backgroundColor: Colors.red,
//     actionTextColor: Colors.white,
//   ),
// ),