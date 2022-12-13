import 'package:flutter/material.dart';
import 'package:get/get.dart';

void sucessSnackbar(String title, String subtile) {
  Get.snackbar(title, subtile,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 1),
      backgroundColor: Colors.green,
      colorText: Get.theme.snackBarTheme.actionTextColor);
}

void errorSnackbar(String title, String subtile) {
  Get.snackbar(title, subtile,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 1),
      backgroundColor: Get.theme.snackBarTheme.backgroundColor,
      colorText: Get.theme.snackBarTheme.actionTextColor);
}
