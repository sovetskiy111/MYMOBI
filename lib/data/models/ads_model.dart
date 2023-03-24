import 'package:mobi_kg/const/app_const.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdsModel {
  String? uid;
  String? user;
  final String? title;
  final String? date;
  final int? timestamp;
  final String? phone;
  final String? price;
  final String? category;
  final String? address;
  List<dynamic> images;
  List<dynamic>? search;

  AdsModel.push(
      {required this.price,
       this.user,
      required this.title,
      required this.date,
      required this.timestamp,
      required this.phone,
      required this.category,
      required this.images,
      required this.search,
        required this.address,
      });

  AdsModel(
      {required this.uid,
      required this.price,
      required this.user,
      required this.title,
      required this.date,
      required this.timestamp, 
      required this.phone,
      required this.category,
      required this.images,
        required this.address,
      });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'user': user,
      'title': title,
      'date': date,
      'timestamp': timestamp,
      'phone': phone,
      'price': price,
      'category': category,
      'images': images,
      'search': search,
      'address': address,
    };
  }

  factory AdsModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();
    return AdsModel(
      uid: snapshot.id,
      user: data?['user'],
      title: data?['title'],
      date: data?['date'],
      timestamp: data?['timestamp'],
      phone: data?['phone'],
      price: data?['price'],
      category: data?['category'],
      images: data?['images'],
      address: data?['address'],
    );
  }




  int checkOnEmpty() {
    if (images.isEmpty) {
      return AppConst.imagesIsEmpty;
    } else if (title == null || title!.isEmpty) {
      return AppConst.titleIsEmpty;
    } else if (category == null || category!.isEmpty) {
      return AppConst.categoryIsEmpty;
    } else if (phone == null || phone!.isEmpty) {
      return AppConst.phoneIsEmpty;
    } else if (address == null || address!.isEmpty) {
      return AppConst.addressIsEmpty;
    }  else {
      return AppConst.otherIsEmpty;
    }
  }
}
