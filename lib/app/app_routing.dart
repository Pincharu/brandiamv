import 'package:get/get.dart';

import '../pages/admin/admin_orders/admin_orders_page.dart';
import '../pages/admin/admin_product/admin_product_page.dart';
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
      name: Routes.adminProduct,
      transition: Transition.downToUp,
      page: () => const AdminProductPage(),
    ),
    GetPage(
      name: Routes.adminOrders,
      transition: Transition.downToUp,
      page: () => const AdminOrdersPage(),
    ),
  ];
}

class Routes {
  Routes._();

  static const String main = '/';
  static const String orders = '/orders';
  static const String adminProduct = '/adminProduct';
  static const String adminOrders = '/adminOrders';
}
