
import 'dart:convert';

import 'package:mobi_kg/const/app_const.dart';
import 'package:mobi_kg/data/models/user_model.dart';
import 'package:mobi_kg/data/repository/auth_status.dart';
import 'package:mobi_kg/data/repository/status.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepo{
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;


  /// Создает аккаунт
  Future<String> createAccount({required String name, required String email, required String password})async{
    try {
      final  account = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      final docUser = db.collection(AppConst.collectionUsers).doc(account.user?.uid);
      final user = UserModel(name: name, uid: docUser.id, email: email, root: AppConst.rootUser, balance: 0, lang: 'ru');
       await docUser.set(user.toMap());
       await setUser(user);
      return AuthStatus().successful;
    } on FirebaseAuthException catch (e) {
      return AuthStatus().getAuthStatus(e.code);
    } catch (e) {
      return AuthStatus().networkRequestFailed;
    }
  }

  /// Вход в аккаунт
  Future<String> signIn({required String email, required String password})async{
    try {
    final account = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    await setUser(await getUserInFirestore(account.user!.uid))
    ;
      return AuthStatus().successful;
    } on FirebaseAuthException catch (e) {
      return AuthStatus().getAuthStatus(e.code);
    }
  }
  /// Сброс пароля
  Future<String> resetPassword({required String email}) async {
    try {
      await _firebaseAuth
          .sendPasswordResetEmail(email: email);
      return AuthStatus().successful;
    } on FirebaseAuthException catch (e) {
      return AuthStatus().getAuthStatus(e.code);
    }
  }
  ///Обновляет пользовательские данные
  Future<void> updateUserParameter()async{
    await setUser(await getUserInFirestore(_firebaseAuth.currentUser!.uid));
  }



  /// Получает пользовательские данные если вошел в аккаунт, иначе Null
  Future<UserModel?> getUser()async{
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString("user");
    if(jsonString!=null){
      Map<String, dynamic> userMap = jsonDecode(jsonString);
      return UserModel.fromJson(userMap);
    }else{
      return null;
    }
  }

  

  /// Сохроняет данные на локальный память
  Future<void> setUser(UserModel userModel)async{
    String user = jsonEncode(userModel.toMap());
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('user', user);
    debugPrint('+++set+++++++${prefs.getString('user')}');
  }

  /// Получает данные прользевателя по UID с Firestore
  Future<UserModel> getUserInFirestore(String uid)async{
    final ref = db.collection(AppConst.collectionUsers).doc(uid).withConverter(
      fromFirestore: UserModel.fromFirestore,
      toFirestore: (UserModel userModel, _) => userModel.toMap(),
    );
    final docSnap = await ref.get();
    return docSnap.data() as UserModel;
  }

  ///Выход из аккаунта и Удаление данные с локальной памяти
  Future<void> signOut()async{
    await _firebaseAuth.signOut();
    await removeUser();
  }

  /// Удаляет локальные даннные пользователя
  Future<void>removeUser()async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user');
  }

  /// Получает всех пользувателей
  Future<List<UserModel>?> getUsers() async {
    final List<UserModel> ads = [];
    try {
      db.settings = const Settings(persistenceEnabled: false);
      final res = await db.collection(AppConst.collectionUsers).get();
      for (int i = 0; i < res.docs.length; i++) {
        final DocumentSnapshot<Map<String, dynamic>> snapshot = res.docs[i];
        final d = UserModel.fromFirestore(snapshot, null);
        ads.add(d);
      }
      return ads;
    } on FirebaseException {
      return null;
    }
  }

  /// Добавляет объявление на сервер
  Future<String> pushAds({required String uid, required int addBalance}) async {
    db.settings = const Settings(persistenceEnabled: false);
    final firestore = db.collection(AppConst.collectionUsers).doc(uid);
    try {
      await firestore.update({'balance': addBalance}).then((value) {
        return Status.successful;
      }).onError((error, stackTrace) {
        return Status.networkRequestFailed;
      });
      return Status.successful;
    } on FirebaseException {
      return Status.networkRequestFailed;
    }
  }


}