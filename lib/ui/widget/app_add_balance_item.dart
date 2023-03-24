import 'package:mobi_kg/bloc/adminBloc/admin_bloc.dart';
import 'package:mobi_kg/bloc/adminBloc/admin_event.dart';
import 'package:mobi_kg/const/app_fonts.dart';
import 'package:mobi_kg/data/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppAddBalanceItem extends StatelessWidget {
  AppAddBalanceItem(
      {super.key,
      required this.user, required this.bloc});
  final TextEditingController controller = TextEditingController();
  final UserModel user;
  final AdminBloc bloc;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
      decoration: BoxDecoration(color: const Color(0xffF6F6F6), borderRadius: BorderRadius.circular(5)),

      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${'name'.tr}:  ${user.name}', style: AppFonts.w500s18,),
          Text('Email:  ${user.email}', style: AppFonts.w500s16.copyWith(color: Colors.green),),
          const SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text('${'balance'.tr}:  ${user.balance} + ', style: AppFonts.w500s16,),
              Container(
                width: 100,
                height: 40,
                color: Colors.white,
                child: TextField(
                  maxLength: 5,
                  decoration: const InputDecoration(border: OutlineInputBorder(), counterText: "", contentPadding: EdgeInsets.symmetric(vertical: 0,horizontal: 10)),
                  controller: controller,
                  keyboardType: TextInputType.number,
                ),
              ),
              TextButton(
                  onPressed: (){
                    if(controller.text.isNotEmpty){
                      final int summ = user.balance + int.tryParse(controller.text.trim())!;
                      bloc.add(AdminAddBalanceState(uid: user.uid, balance: summ));
                    }
                  },
                  child: Text('add'.tr))
            ],
          )
        ],
      ),
    );
  }
}
