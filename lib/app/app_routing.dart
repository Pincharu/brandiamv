import 'package:brandiamv/pages/admin/admin_page.dart';
import 'package:get/get.dart';

import '../pages/client/home/home_page.dart';
import '../pages/client/orders/orders_page.dart';

class AppRoutes {
  AppRoutes._(); //this is to prevent anyone from instantiating this object
  static final routes = [
    GetPage(
      name: Routes.main,
      transition: Transition.downToUp,
      page: () => const HomePage(),
    ),
    GetPage(
      name: Routes.orders,
      transition: Transition.downToUp,
      page: () => const OrdersPage(),
    ),
    GetPage(
      name: Routes.admin,
      transition: Transition.downToUp,
      page: () => const AdminPage(),
    ),
  ];
}

class Routes {
  Routes._();

  static const String main = '/';
  static const String orders = '/orders';
  static const String admin = '/admin';
}
