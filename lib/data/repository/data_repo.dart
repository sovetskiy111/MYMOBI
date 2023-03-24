import 'dart:io';
import 'package:mobi_kg/const/app_const.dart';
import 'package:mobi_kg/data/models/ads_model.dart';
import 'package:mobi_kg/data/repository/status.dart';
import 'package:mobi_kg/util/app_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

class Repo {
  final db = FirebaseFirestore.instance;
  ///Удаляет объявление
  Future<List<AdsModel>?> removeAds(String? uid,{String? user})async{
    try{
    db.collection(AppConst.collectionData).doc(uid).delete();
    return user==null?await getAllAds():await getUserAds(user);
    }on FirebaseException {
      return null;
    }
  }
  ///Поиск по тексту
  Future<List<AdsModel>?> searchData(List<String> searchList) async {
    final List<AdsModel> ads = [];
    try {
      final res = searchList.length == 1
          ? await db
              .collection(AppConst.collectionData)
              .where("search", arrayContains: searchList[0])
              .get()
          : await db
              .collection(AppConst.collectionData)
              .where("search", arrayContainsAny: searchList)
              .get();
      for (int i = 0; i < res.docs.length; i++) {
        final DocumentSnapshot<Map<String, dynamic>> snapshot = res.docs[i];
        final d = AdsModel.fromFirestore(snapshot, null);
        ads.add(d);
      }
      return ads;
    } on FirebaseException {
      return null;
    }
  }

  /// Получает данные по категории
  Future<List<AdsModel>?> getCategory(String category) async {
    final List<AdsModel> ads = [];
    try {
      final res = await db
          .collection(AppConst.collectionData)
          .where("category", isEqualTo: category)
          .get();
      for (int i = 0; i < res.docs.length; i++) {
        final DocumentSnapshot<Map<String, dynamic>> snapshot = res.docs[i];
        final d = AdsModel.fromFirestore(snapshot, null);
        ads.add(d);
      }
      return ads;
    } on FirebaseException {
      return null;
    }
  }

  /// Получает все данные
  Future<List<AdsModel>?> getAllAds() async {
    final List<AdsModel> ads = [];
    try {
      final res = await db.collection(AppConst.collectionData)
          .orderBy("timestamp", descending: true).get();
      for (int i = 0; i < res.docs.length; i++) {
        final DocumentSnapshot<Map<String, dynamic>> snapshot = res.docs[i];
        final d = AdsModel.fromFirestore(snapshot, null);
        ads.add(d);
      }
      return ads;
    } on FirebaseException {
      return null;
    }
  }

  /// Получает по email данные
  Future<List<AdsModel>?> getUserAds(String user) async {
    final List<AdsModel> ads = [];
    try {
      final res = await db.collection(AppConst.collectionData).where("user", isEqualTo: user).get();
      for (int i = 0; i < res.docs.length; i++) {
        final DocumentSnapshot<Map<String, dynamic>> snapshot = res.docs[i];
        final d = AdsModel.fromFirestore(snapshot, null);
        ads.add(d);
      }
      return ads;
    } on FirebaseException {
      return null;
    }
  }

  /// Добавляет объявление на сервер
  Future<String> pushAds({required AdsModel adsModel}) async {
    List<String?> images = [];
    final userCurrent = FirebaseAuth.instance.currentUser;
    for (String? path in adsModel.images) {
      if (userCurrent != null && path != null) {
        final String? uploadPath =
            await uploadImageToStorage(userCurrent, path);
        if (uploadPath != null) {
          images.add(uploadPath);
        }
      }
    }
    adsModel.images = images;
    final firestore = db.collection(AppConst.collectionData).doc();
    try {
      await firestore
          .set(adsModel.toMap())
          .onError((e, _) => 'Error writing document: $e');
      return Status.successful;
    } catch (e) {
      return Status.networkRequestFailed;
    }
  }

  ///Загружает фото на сервер
  Future<String?> uploadImageToStorage(User user, String path) async {
    File? file = await getFileImage(File(path));
    if (file == null) {
      return null;
    }
    final storageRef = FirebaseStorage.instance.ref();

    final randomSp = generateRandomString(20);
    final storagePath = storageRef.child('image/${user.uid}}/$randomSp.jpg');
    try {
      await storagePath.putFile(file);
      return storagePath.getDownloadURL();
    } on FirebaseException {
      return null;
    }
  }
  ///Удаляет фото
  Future<void> deleteImage(String url)async{
    try{
      final desertRef  = FirebaseStorage.instance.refFromURL(url);
      await desertRef.delete();
    }on FirebaseException catch(e){
      if (kDebugMode) {
        print(e);
      }
    }
  }

  ///Содает ссылку для компреса изоброжения
  Future<File?> getFileImage(File file) async {
    final dir = await path_provider.getTemporaryDirectory();
    final targetPath = '${dir.absolute.path}/image.jpg';
    return await testCompressAndGetFile(file, targetPath);
  }

  /// Компрессиует изоброжения
  Future<File?> testCompressAndGetFile(File file, String targetPath) async {
    final result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 50,
    );
    return result;
  }
}
