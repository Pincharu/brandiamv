import 'package:brandiamv/pages/client/home/home_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

import '../app/app_colors.dart';

class AddProduct extends StatelessWidget {
  final int i;
  const AddProduct({super.key, required this.i});

  @override
  Widget build(BuildContext context) {
    var model = Get.find<HomeCore>();

    return Obx(
      () => ((model.currentList[i].quantity ?? 0) != 0)
          ? ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                color: kcolorOrange,
                width: 100,
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        if (model.currentList[i].quantity! > 0) {
                          model.currentList[i].quantity = model.currentList[i].quantity! - 1;
                          if (model.currentList[i].category == "BAGS") {
                            model.bags--;
                          } else if (model.currentList[i].category == "DEFORM BARS") {
                            model.bars--;
                          }
                          model.resetProducts();
                        }
                      },
                      icon: const Icon(
                        Icons.remove,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                    "${model.currentList[i].quantity}".text.size(16).white.make(),
                    IconButton(
                      onPressed: () {
                        model.currentList[i].quantity = model.currentList[i].quantity! + 1;
                        if (model.currentList[i].category == "BAGS") {
                          model.bags++;
                        } else if (model.currentList[i].category == "DEFORM BARS") {
                          model.bars++;
                        }
                        model.resetProducts();
                      },
                      icon: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ],
                ),
              ),
            )
          : ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              onPressed: (model.currentList[i].stock > 0)
                  ? () {
                      model.currentList[i].quantity = 1;
                      if (model.currentList[i].category == "BAGS") {
                        model.bags++;
                      } else if (model.currentList[i].category == "DEFORM BARS") {
                        model.bars++;
                      }
                      model.resetProducts();
                    }
                  : null,
              child: (model.currentList[i].stock > 0)
                  ? "+ Add".text.size(14).white.make()
                  : "Out of Stock".text.size(14).white.make(),
            ).pOnly(right: 4),
    );
  }
}
