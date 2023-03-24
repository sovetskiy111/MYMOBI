import 'dart:io';

import 'package:mobi_kg/bloc/addAds/add_ads_bloc.dart';
import 'package:mobi_kg/bloc/addAds/add_ads_event.dart';
import 'package:mobi_kg/bloc/addAds/add_ads_state.dart';
import 'package:mobi_kg/const/app_colors.dart';
import 'package:mobi_kg/const/app_const.dart';
import 'package:mobi_kg/data/models/ads_model.dart';
import 'package:mobi_kg/data/models/user_model.dart';
import 'package:mobi_kg/data/repository/auth_repo.dart';
import 'package:mobi_kg/ui/widget/app_elevated_button.dart';
import 'package:mobi_kg/ui/widget/app_gradient_general.dart';
import 'package:mobi_kg/util/app_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/custom_dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:quickalert/quickalert.dart';

class AddAdsPage extends StatefulWidget {
  const AddAdsPage({Key? key}) : super(key: key);

  @override
  State<AddAdsPage> createState() => _AddAdsPageState();
}

class _AddAdsPageState extends State<AddAdsPage> {
  final List<String?> _images = [];
  final picker = ImagePicker();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  String? titleError;
  String? phoneError;
  String? addressError;
  String? categoryError;
  String? imageError;
  String? selectedCategory;

  chooseImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _images.add(pickedFile.path);
      });
    }
  }

  removeAtImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }

  onChanger(String? value) {
    setState(() {
      selectedCategory = value;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    titleController.dispose();
    phoneController.dispose();
    priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("addAds".tr),
        centerTitle: true,
        flexibleSpace: const AppGradientGeneral(),
      ),
      body: BlocListener<AddAdsBloc, AddAdsState>(
          listener: (context, state) {
            if (state is AddAdsLoadingState) {
              //showLoadingDialog(context);
              QuickAlert.show(
                  context: context,
                  type: QuickAlertType.loading,
                  barrierDismissible: false,
                  title: 'loading'.tr,
                  text: 'loadingAd'.tr);
            } else if (state is AddAdsLoadedState) {
              Navigator.of(context).pop();
              QuickAlert.show(
                  context: context,
                  type: QuickAlertType.success,
                  title: 'success'.tr,
                  text: 'successAddAds'.tr,
                  barrierDismissible: false,
                  onConfirmBtnTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  });
            } else if (state is AddAdsEmptyState) {
              Navigator.of(context).pop();
              switch (state.empty) {
                case AppConst.titleIsEmpty:
                  snackBar(context,
                      msg: 'titleNotEmptyError'.tr,
                      backgroundColor: Colors.red);
                  setState(() {
                    imageError = null;
                    categoryError = null;
                    phoneError = null;
                    addressError = null;
                    titleError = 'titleNotEmptyError'.tr;
                  });
                  break;
                case AppConst.categoryIsEmpty:
                  snackBar(context,
                      msg: 'selectCategory'.tr, backgroundColor: Colors.red);
                  setState(() {
                    titleError = null;
                    imageError = null;
                    phoneError = null;
                    addressError = null;
                    categoryError = 'selectCategory'.tr;
                  });
                  break;
                case AppConst.imagesIsEmpty:
                  snackBar(context,
                      msg: 'selectImage'.tr, backgroundColor: Colors.red);
                  setState(() {
                    categoryError = null;
                    titleError = null;
                    phoneError = null;
                    addressError = null;
                    imageError = 'selectImage'.tr;
                  });
                  break;
                case AppConst.phoneIsEmpty:
                  snackBar(context,
                      msg: 'fillNumberPhone'.tr, backgroundColor: Colors.red);
                  setState(() {
                    imageError = null;
                    categoryError = null;
                    titleError = null;
                    addressError = null;
                    phoneError = 'fillNumberPhone'.tr;
                  });
                  break;
                case AppConst.addressIsEmpty:
                  snackBar(context,
                      msg: 'enterYouAddress'.tr, backgroundColor: Colors.red);
                  setState(() {
                    imageError = null;
                    categoryError = null;
                    titleError = null;
                    phoneError = null;
                    addressError = 'enterYouAddress'.tr;
                  });
                  break;
              }
            } else if (state is AddAdsErrorState) {
              Navigator.of(context).pop();

              QuickAlert.show(
                context: context,
                type: QuickAlertType.error,
                title: 'error'.tr,
                text: 'networkRequestFailed'.tr,
                barrierDismissible: false,
                onConfirmBtnTap: () {
                  Navigator.of(context).pop();
                },
              );
            }
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
                SelectImage(
                  images: _images,
                  chooseImage: chooseImage,
                  removeAtImage: removeAtImage,
                  imageError: imageError,
                ),
                AppInputData(
                  titleError: titleError,
                  controller: titleController,
                ),
                CategoryAndPriceWidget(
                    priceController: priceController,
                    categoryError: categoryError,
                    selectedCategory: selectedCategory,
                    onChanger: ((value) => onChanger(value))),
                AppInputPhone(
                  titleText: 'address'.tr,
                  phoneError: addressError,
                  controller: addressController,
                  hintText: 'address'.tr,
                ),
                AppInputPhone(
                  titleText: "phoneNumber".tr,
                  phoneError: phoneError,
                  keyboardType: TextInputType.phone,
                  controller: phoneController,
                  hintText: 'exampleNumberPhone'.tr,
                ),
                PushButtonEvent(
                  selectedCategory: selectedCategory,
                  titleController: titleController,
                  phoneController: phoneController,
                  priceController: priceController,
                  addressController: addressController,
                  images: _images,
                )
              ],
            ),
          )),
    );
  }
}

class SelectImage extends StatelessWidget {
  const SelectImage(
      {super.key,
      required List<String?> images,
      required this.chooseImage,
      required this.imageError,
      required this.removeAtImage})
      : _images = images;
  final List<String?> _images;
  final Function() chooseImage;
  final void Function(int) removeAtImage;
  final String? imageError;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            margin: const EdgeInsets.only(top: 20, left: 16, right: 16),
            alignment: Alignment.topLeft,
            child: Text(
              "selectImage".tr,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.generalColor),
              textAlign: TextAlign.left,
            )),
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), color: Colors.black12),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
          width: double.infinity,
          height: 2,
        ),
        GridView.custom(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 16),
          gridDelegate: SliverQuiltedGridDelegate(
            crossAxisCount: 4,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
            repeatPattern: QuiltedGridRepeatPattern.inverted,
            pattern: const [
              QuiltedGridTile(2, 2),
              QuiltedGridTile(1, 1),
              QuiltedGridTile(1, 1),
              QuiltedGridTile(1, 1),
              QuiltedGridTile(1, 1),
            ],
          ),
          childrenDelegate: SliverChildBuilderDelegate((context, index) {
            return index < 5
                ? index == _images.length
                    ? GestureDetector(
                        onTap: chooseImage,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color:
                                imageError == null ? Colors.grey : Colors.red,
                          ),
                          alignment: Alignment.center,
                          child: const Icon(Icons.add_photo_alternate_outlined),
                        ),
                      )
                    : Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.white,
                                image: DecorationImage(
                                    image: FileImage(File(_images[index]!)),
                                    fit: BoxFit.cover)),
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: InkWell(
                              onTap: (){
                                removeAtImage(index);
                              }
                              ,
                              child: Container(
                                  decoration:  const BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(8)),
                                      color: Colors.white),
                                  child:  const Icon(Icons.close)),
                            ),
                          )
                        ],
                      )
                : Container(
                    color: Colors.amber,
                  );
          }, childCount: _images.length < 4 ? _images.length + 1 : 5),
        ),
      ],
    );
  }
}

class CategoryAndPriceWidget extends StatelessWidget {
  const CategoryAndPriceWidget(
      {super.key,
      required this.priceController,
      required this.categoryError,
      required this.selectedCategory,
      required this.onChanger});

  final TextEditingController priceController;
  final String? categoryError;
  final String? selectedCategory;
  final void Function(String? value) onChanger;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20, left: 16, right: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 150,
            child: CustomDropdownButton2(
              dropdownDecoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              buttonDecoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                    color: categoryError == null ? Colors.black12 : Colors.red,
                    width: 1),
                borderRadius: BorderRadius.circular(10),
              ),
              hint: 'category'.tr,
              dropdownItems: AppConst.dropDownItems,
              value: selectedCategory,
              onChanged: (value) {
                onChanger(value);
              },
            ),
          ),
          const SizedBox(
            width: 30,
          ),
          Text(
            "price".tr,
            style: const TextStyle(color: AppColors.generalColor),
          ),
          const SizedBox(
            width: 10,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.black12, width: 1),
              borderRadius: BorderRadius.circular(10),
            ),
            width: 80,
            height: 40,
            child: TextField(
              controller: priceController,
              maxLength: 10,
              maxLines: 1,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  counterText: '',
                  border: InputBorder.none,
                  hintText: 'treaty'.tr),
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          Text("som".tr)
        ],
      ),
    );
  }
}

class PushButtonEvent extends StatelessWidget {
  const PushButtonEvent(
      {super.key,
      required this.titleController,
      required this.phoneController,
      required this.priceController,
      required this.selectedCategory,
      required this.images,
      required this.addressController});

  final TextEditingController titleController;
  final TextEditingController phoneController;
  final TextEditingController priceController;
  final TextEditingController addressController;
  final List<String?> images;
  final String? selectedCategory;

  Future<String?> getUser() async {
    final UserModel? user = await AuthRepo().getUser();
    return user?.email;
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<AddAdsBloc>(context);
    return AppElevatedButton(
        onPressed: () async {
          String searchText = titleController.text;
          searchText = searchText.toLowerCase();
          searchText = searchText.replaceAll(".", ' ');
          searchText = searchText.replaceAll(',', ' ');
          searchText = searchText.replaceAll("-", ' ');
          searchText = searchText.replaceAll("!", ' ');
          searchText = searchText.replaceAll("?", ' ');
          searchText = searchText.replaceAll("  ", ' ');
          searchText = searchText.replaceAll("   ", ' ');
          final searchList = searchText.split(' ');
          final microSearchList = [];
          for (String str in searchList) {
            String addString = '';
            for (int i = 0; i < str.length; i++) {
              if (str[i].isNotEmpty) {
                addString = addString + str[i];
                microSearchList.add(addString);
              }
            }
          }

          bloc.add(AddAdsPushDataEvent(
              adsModel: AdsModel.push(
            category: selectedCategory,
            images: images,
            phone: phoneController.text.trim(),
            price: priceController.text.trim(),
            title: titleController.text.trim(),
            address: addressController.text.trim(),
            date: getDate(),
            user: await getUser() ?? '',
            timestamp: getTimestamp(),
            search: microSearchList,
          )));
        },
        text: 'save'.tr);
  }
}

class AppInputData extends StatelessWidget {
  final TextEditingController controller;
  final String? titleError;

  const AppInputData({
    Key? key,
    required this.controller,
    required this.titleError,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20,
          ),
          Text("textDescription".tr,
              style: const TextStyle(
                  color: AppColors.generalColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold)),
          const SizedBox(
            height: 10,
          ),
          Container(
              padding: const EdgeInsets.all(10),
              alignment: Alignment.topLeft,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black12, width: 1),
                borderRadius: BorderRadius.circular(10),
              ),
              height: 150,
              width: double.infinity,
              child: TextField(
                controller: controller,
                maxLength: 500,
                maxLines: 10,
                keyboardType: TextInputType.multiline,
                style: const TextStyle(color: Colors.black87),
                decoration: InputDecoration(
                    errorText: titleError,
                    errorBorder: const OutlineInputBorder(),
                    border: InputBorder.none,
                    hintStyle: const TextStyle(color: Colors.black38)),
              ))
        ],
      ),
    );
  }
}

class AppInputPhone extends StatelessWidget {
  final String? phoneError;
  final String hintText;
  final String titleText;
  final TextInputType? keyboardType;
  final TextEditingController controller;

  const AppInputPhone({
    Key? key,
    required this.controller,
    required this.phoneError,
    required this.hintText,
    required this.titleText,
    this.keyboardType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20,
          ),
          Text(titleText,
              style: const TextStyle(
                  color: AppColors.generalColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold)),
          const SizedBox(
            height: 10,
          ),
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              alignment: Alignment.topLeft,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                    color: phoneError == null ? Colors.black12 : Colors.red,
                    width: 1),
                borderRadius: BorderRadius.circular(10),
              ),
              width: double.infinity,
              child: TextField(
                controller: controller,
                maxLines: 1,
                keyboardType: keyboardType,
                style: const TextStyle(color: Colors.black87),
                decoration: InputDecoration(
                    hintText: hintText,
                    counterText: "",
                    border: InputBorder.none,
                    hintStyle: const TextStyle(color: Colors.black38)),
              ))
        ],
      ),
    );
  }
}

String getDate() {
  final date = Timestamp.now();
  final dateStr = DateFormat("dd.MM.yyyy").format(date.toDate());
  return dateStr;
}

int getTimestamp() {
  final date = Timestamp.now();
  final timestamp = date.seconds;
  return timestamp;
}
