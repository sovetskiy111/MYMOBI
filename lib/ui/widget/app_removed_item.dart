import 'package:mobi_kg/const/app_fonts.dart';
import 'package:mobi_kg/data/models/ads_model.dart';
import 'package:mobi_kg/ui/widget/app_image_widget.dart';
import 'package:flutter/material.dart';

class AppRemovedItem extends StatelessWidget {
  const AppRemovedItem({
    super.key,
    required this.adsModel, required this.onPressedRemove, required this.onPressedOpenItem
  });

  final AdsModel adsModel;
  final Function()? onPressedRemove;
  final Function()? onPressedOpenItem;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressedOpenItem,
      child: Container(
        width: double.infinity,
        height: 100,
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.grey[200]),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AppImageWidget(imagePath: adsModel.images[0],radiusTopRight: 10,radiusTopLeft: 10,radiusBottomLeft: 10,radiusBottomRight: 10,width: 80,height: 80,),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    adsModel.title??"",
                    style: AppFonts.w500s16,
                    maxLines: 2,
                  ),
                  Text(
                    adsModel.date??"",
                    style: AppFonts.w400s14.copyWith(color: Colors.green),
                  ),
                  Text(
                    adsModel.user??"",
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Container(
              alignment: Alignment.centerRight,
              child: IconButton(
                  onPressed: onPressedRemove,
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.green,
                  )),
            )
          ],
        ),
      ),
    );
  }
}
