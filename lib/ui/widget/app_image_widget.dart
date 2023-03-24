import 'package:mobi_kg/const/app_images.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class AppImageWidget extends StatelessWidget {
  const AppImageWidget(
      {Key? key,
      required this.imagePath,
      this.width = double.infinity,
      this.height = double.infinity,
      this.radiusBottomRight = 0,
      this.radiusBottomLeft = 0,
      this.radiusTopLeft = 0,
      this.radiusTopRight = 0,
      this.onTap})
      : super(key: key);
  final String imagePath;
  final double width;
  final double height;
  final double radiusBottomRight;
  final double radiusBottomLeft;
  final double radiusTopLeft;
  final double radiusTopRight;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Hero(
        tag: imagePath,
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(radiusTopRight),
            topLeft: Radius.circular(radiusTopLeft),
            bottomLeft: Radius.circular(radiusBottomLeft),
            bottomRight: Radius.circular(radiusBottomRight),
          ),
          child: Image.network(
            imagePath,
            frameBuilder: (BuildContext context, Widget child, int? frame,
                bool wasSynchronouslyLoaded) {
              if (wasSynchronouslyLoaded) {
                return child;
              }
              return AnimatedOpacity(
                opacity: frame == null ? 0 : 1,
                duration: const Duration(seconds: 1),
                curve: Curves.easeOut,
                child: child,
              );
            },
            errorBuilder:
                (BuildContext context, Object exception, StackTrace? stackTrace) {
              return Image.asset(AppImages.errorImage,
                  width: width, height: height, fit: BoxFit.cover);
            },
            loadingBuilder: (BuildContext context, Widget child,
                ImageChunkEvent? loadingProgress) {
              if (loadingProgress == null) {
                return child;
              }
              return Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    width: width,
                    height: height,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(radiusBottomRight),
                            bottomLeft: Radius.circular(radiusBottomLeft),
                            topLeft: Radius.circular(radiusTopLeft),
                            topRight: Radius.circular(radiusTopRight)),
                        color: Colors.white),
                  ));
            },
            height: height,
            width: width,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
