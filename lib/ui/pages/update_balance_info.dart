
import 'package:mobi_kg/const/app_fonts.dart';
import 'package:mobi_kg/data/models/user_model.dart';
import 'package:mobi_kg/data/repository/auth_repo.dart';
import 'package:mobi_kg/ui/widget/app_contact_burron.dart';
import 'package:mobi_kg/ui/widget/app_gradient_general.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpdateBalanceInfo extends StatefulWidget {
  const UpdateBalanceInfo({Key? key}) : super(key: key);

  @override
  State<UpdateBalanceInfo> createState() => _UpdateBalanceInfoState();
}

class _UpdateBalanceInfoState extends State<UpdateBalanceInfo> {
  final auth = AuthRepo();
  UserModel? user;
  bool isClicked = false;
  Future<void>_getUser()async{
    user = await auth.getUser();
  }
  @override
  void initState() {
    super.initState();
    _getUser();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        flexibleSpace: const AppGradientGeneral(),
        title:  Text('addBalance'.tr),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 35),
        child: Column(
          children: [
            Text("addBalanceDescription".tr, textAlign: TextAlign.center, style: AppFonts.w500s18,),
            const SizedBox(height: 20,),
            AppContactButton(isWhatsApp: true,  number: '996500920800',user: user,),
            const SizedBox(height: 10,),
            AppContactButton(isWhatsApp: false,  number: '996500920800',user: user),
            const Spacer(),
            Text(!isClicked?"updateAfterAdd".tr:"")
            ,const SizedBox(height: 10,),

            Container(child: !isClicked?ElevatedButton(onPressed: ()async{
              await auth.updateUserParameter();
              isClicked = !isClicked;
              setState(() {

              });
            }, child: Text('update'.tr)):Container(),)
            ,const SizedBox(height: 50,),

          ],
        ),
      ),
    );
  }
}
