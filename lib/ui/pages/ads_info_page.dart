
import 'package:mobi_kg/const/app_colors.dart';
import 'package:mobi_kg/const/app_fonts.dart';
import 'package:mobi_kg/data/models/ads_model.dart';
import 'package:mobi_kg/ui/pages/photo_view_page.dart';
import 'package:mobi_kg/ui/widget/app_elevated_button.dart';
import 'package:mobi_kg/ui/widget/app_image_widget.dart';
import 'package:mobi_kg/util/app_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class AdsInfoPage extends StatefulWidget {
  const AdsInfoPage({Key? key, required this.adsModel}) : super(key: key);
  final AdsModel adsModel;

  @override
  State<AdsInfoPage> createState() => _AdsInfoPageState();
}

class _AdsInfoPageState extends State<AdsInfoPage> {
  int _current = 0;
  final PageController controller = PageController();


  // List<Widget> _getList(double width) {
  //   List<Widget> listWidget = [];
  //   for (String path in widget.adsModel.images) {
  //     //listWidget.add();
  //   }
  //   return listWidget;
  // }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  Future<void> _openWhatsapp(
      BuildContext context, String whatsAppNumber) async {
    String number = whatsAppNumber.replaceAll(' ', '');
    number = number.replaceAll('+', '');
    number = number.replaceAll('-', '');
    number = number.replaceAll('(', '');
    number = number.replaceAll(')', '');
    if(number.length==10&&number[0]=='0'){
      number = '996${number.substring(1, number.length)}';
  }
    if (!await launchUrl(Uri(scheme:'https', host:'wa.me', path: number),      mode: LaunchMode.externalApplication,
    )) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("whatsappNoInstalled".tr)));
    }
    /*var whatsappAndroid =
        "whatsapp://send?phone=$whatsAppNumber";
    var whatsappIos =
        "https://wa.me/$whatsAppNumber";
    if (Platform.isIOS) {
      // for iOS phone only
      if (!await launchUrl(Uri(scheme: whatsappIos))) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("whatsappNoInstalled".tr)));
      }
    } else {
      // android , web
      if (!await launchUrl(Uri(scheme:'https',path: whatsappAndroid))) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("whatsappNoInstalled".tr)));
      }
    }*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(onPressed:(){
          Navigator.pop(context);
        },icon: const Icon(Icons.arrow_back, color: Colors.black,)),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.5,
              child: Column(children: [
                Expanded(
                  child: PageView.builder(
                    /// [PageView.scrollDirection] defaults to [Axis.horizontal].
                    /// Use [Axis.vertical] to scroll vertically.
                    itemCount: widget.adsModel.images.length,
                    onPageChanged: (index) {
                      setState(() {
                        _current = index;
                      });
                    },
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: AppImageWidget(
                          imagePath: widget.adsModel.images[index],
                          radiusBottomRight: 10,
                          radiusBottomLeft: 10,
                          radiusTopLeft: 10,
                          radiusTopRight: 10,
                          onTap: () {
                            Navigator.push(context, CupertinoPageRoute(builder: (context)=> PhotoViewPage(adsModel: widget.adsModel, initIndex: index,)));
                          },
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: 20,
                  child: Center(
                    child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: widget.adsModel.images.length,
                        itemBuilder: (context, index) {
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            child: Padding(
                              padding: const EdgeInsets.all(1.0),
                              child: widget.adsModel.images.length==1?Container():Icon(
                                _current == index
                                    ? Icons.lens
                                    : Icons.lens_outlined,
                                color: AppColors.green,
                                size: _current == index?10:5,
                              ),
                            ),
                          );
                        }),
                  ),
                ),
              ]),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10, left: 16, right: 16),
              child: Text(
                widget.adsModel.price == null || widget.adsModel.price == ''
                    ? 'treaty'.tr
                    : "${widget.adsModel.price!} ${'som'.tr}",
                style: AppFonts.w500s20.copyWith(color: AppColors.green),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[100]),
              child: Text(
                widget.adsModel.title ?? "",
                style: AppFonts.w500s16,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 16, right: 16),
              child: Text('${'date'.tr}:  ${widget.adsModel.date ?? '__.__.____'}'),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Icon(Icons.location_on_outlined, color: AppColors.generalColor,),
                  const SizedBox(width: 10,),
                  Text(
                    widget.adsModel.address==null||widget.adsModel.address!.isEmpty? "noAddress".tr : widget.adsModel.address!,
                    style: AppFonts.w500s16,
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.only( left: 16, right: 16),
              child: InkWell(onTap:(){
                Clipboard.setData( ClipboardData(text: widget.adsModel.phone));
                snackBar(context, msg: 'Copy');

              },child: Text('${'phoneNumber'.tr}: ${widget.adsModel.phone??''}', style: AppFonts.w500s18,)),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
              Expanded(
                child: AppElevatedButton(
                    onPressed: () {
                      if (widget.adsModel.phone != null &&
                          widget.adsModel.phone!.isNotEmpty) {
                        _makePhoneCall(widget.adsModel.phone!);
                      }
                    },
                    text: 'call'.tr),
              ),
                Expanded(
                  child: AppElevatedButton(
                      onPressed: () {
                        if (widget.adsModel.phone != null &&
                            widget.adsModel.phone!.isNotEmpty) {
                          _openWhatsapp(context,widget.adsModel.phone!);
                        }
                      },
                      text: "WhatsApp"),
                )
            ],),


          ],
        ),
      ),
    );
  }
}
