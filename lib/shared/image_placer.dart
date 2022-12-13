import 'package:flutter/material.dart';

class ImagePlacer extends StatelessWidget {
  final String image;
  final BoxFit? boxfit;
  final double? height;
  final double? width;
  final Widget? child;

  const ImagePlacer({
    Key? key,
    required this.image,
    this.height,
    this.width,
    this.boxfit,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(image),
          fit: boxfit ?? BoxFit.contain,
        ),
      ),
      child: child,
    );
  }
}
