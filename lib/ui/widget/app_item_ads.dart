import 'package:mobi_kg/data/models/ads_model.dart';
import 'package:mobi_kg/ui/pages/ads_info_page.dart';
import 'package:mobi_kg/ui/widget/app_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppItemAds extends StatelessWidget {
  const AppItemAds(
      {super.key, required this.widthScreen, required this.adsModel});

  final double widthScreen;
  final AdsModel adsModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              PageRouteBuilder(
                  transitionDuration: const Duration(milliseconds: 500),
                  reverseTransitionDuration: const Duration(milliseconds: 500),
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      FadeTransition(
                        opacity: animation,
                        child: AdsInfoPage(adsModel: adsModel),
                      )));
        },
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              AppImageWidget(
                imagePath: adsModel.images[0]!,
                height: widthScreen * 0.5,
                radiusTopLeft: 10,
                radiusTopRight: 10,
              ),
              Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(top: 10, left: 5, right: 5, bottom: 3),
                child: Text(
                  adsModel.date!,
                  style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontWeight: FontWeight.w400),
                ),
              ),
              Container(
                  margin: const EdgeInsets.only(left: 5, right: 5),
                  child: Text(
                    adsModel.title!,
                    maxLines: 3,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.w400),
                  )),
              Container(
                  margin: const EdgeInsets.only(top: 4, left: 5, right: 5),
                  child: Text(
                    adsModel.price != ''
                        ? '${adsModel.price!} сом'
                        : 'treaty'.tr,
                    style: const TextStyle(
                        color: Colors.green,
                        fontSize: 15,
                        fontWeight: FontWeight.normal),
                  )),
              Container(
                alignment: Alignment.centerRight,
                margin:
                    const EdgeInsets.only(top: 1, left: 5, right: 5, bottom: 5),
                child: Text(
                  adsModel.phone!,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.normal),
                ),
              )
            ]),
      ),
    );
  }
}
