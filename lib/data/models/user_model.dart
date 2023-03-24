
import 'package:mobi_kg/const/app_const.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String name;
  final String email;
  final String lang;
  final int root;
  final int balance;

  UserModel(
      {required this.name,
      required this.uid,
      required this.email,
      required this.lang,
      required this.root,
      required this.balance});

  Map<String, dynamic> toMap(){
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'lang': lang,
      'root': root,
      'balance': balance,

    };
  }

  factory UserModel.fromJson(Map<String, dynamic> parsedJson) {
    return UserModel(
     uid: parsedJson['uid'] ?? "",
     name: parsedJson['name'] ?? "",
     email: parsedJson['email'] ?? "",
     lang: parsedJson['lang'] ?? '',
     root: parsedJson['root'] ?? AppConst.rootUser,
        balance: parsedJson['balance'] ?? 0);
  }

  factory UserModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();
    return UserModel(
      uid: data?['uid']??"",
      name: data?['name']??"",
      email: data?['email']??"",
      lang: data?['lang']??"ru",
      root: data?['root']??3,
      balance: data?['balance']??'0',

    );
  }




}
