import 'package:get/get.dart';

import '../pages/checkout/checkout_page.dart';
import '../pages/home/home_page.dart';
import '../pages/orders/orders_page.dart';

class AppRoutes {
  AppRoutes._(); //this is to prevent anyone from instantiating this object
  static final routes = [
    GetPage(
      name: Routes.main,
      transition: Transition.zoom,
      page: () => const HomePage(),
    ),
    GetPage(
      name: Routes.orders,
      transition: Transition.zoom,
      page: () => const OrdersPage(),
    ),
    GetPage(
      name: Routes.checkout,
      transition: Transition.zoom,
      page: () => const CheckoutPage(),
    ),
  ];
}

class Routes {
  Routes._();

  static const String main = '/';
  static const String orders = '/orders';
  static const String contact = '/contact';
  static const String productDetails = '/productDetails';
  static const String checkout = '/checkout';
  static const String about = '/about';
  static const String privacy = '/privacy';
  static const String terms = '/terms';
}
