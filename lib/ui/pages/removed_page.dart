import 'package:mobi_kg/bloc/removedBloc/removed_bloc.dart';
import 'package:mobi_kg/bloc/removedBloc/removed_event.dart';
import 'package:mobi_kg/bloc/removedBloc/removed_state.dart';
import 'package:mobi_kg/const/app_const.dart';
import 'package:mobi_kg/data/repository/auth_repo.dart';
import 'package:mobi_kg/ui/pages/ads_info_page.dart';
import 'package:mobi_kg/ui/widget/app_gradient_general.dart';
import 'package:mobi_kg/ui/widget/app_removed_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:quickalert/quickalert.dart';

class RemovedPage extends StatefulWidget {
  const RemovedPage({super.key});

  @override
  State<RemovedPage> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<RemovedPage> {
  late RemovedBloc bloc;
  String? mUser;
  Future<void> root() async {
    final user = await AuthRepo().getUser();
    if (user?.root == AppConst.rootAdminFirst) {
      bloc.add(RemoveGetAdsEvent());
    } else if (user?.root == AppConst.rootUser) {
      bloc.add(RemoveUserGetAdsEvent(user: user?.email ?? 'non'));
      mUser = user?.email;
    }
  }

  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.of<RemovedBloc>(context);
    root();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text('removeAds'.tr),
        flexibleSpace: const AppGradientGeneral(),
        backgroundColor: Colors.blue,
      ),
      backgroundColor: Colors.white,
      body: BlocBuilder<RemovedBloc, RemovedState>(
          bloc: bloc,
          builder: (context, state) {
            return state is RemovedLoadingState
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : state is RemovedLoadedState
                    ? Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        width: double.infinity,
                        child: ListView.builder(
                            itemCount: state.adsList.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return AppRemovedItem(
                                adsModel: state.adsList[index],
                                onPressedRemove: () {
                                  QuickAlert.show(
                                    context: context,
                                    type: QuickAlertType.warning,
                                    title: 'remove'.tr,
                                    text: 'isNotSubject'.tr,
                                    barrierDismissible: false,
                                    confirmBtnText: 'yes'.tr,
                                    cancelBtnText: 'no'.tr,
                                    showCancelBtn: true,
                                    onConfirmBtnTap: () {
                                      bloc.add(RemoveAdsEvent(
                                          adsModel: state.adsList[index], user: mUser));
                                      Navigator.pop(context);
                                    },
                                    onCancelBtnTap: () {
                                      Navigator.pop(context);
                                    },
                                  );
                                },
                                onPressedOpenItem: () {
                                  Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                          pageBuilder: (context, animation,
                                                  secondaryAnimation) =>
                                              FadeTransition(
                                                opacity: animation,
                                                child: AdsInfoPage(
                                                    adsModel:
                                                        state.adsList[index]),
                                              )));
                                },
                              );
                            }),
                      )
                    : state is RemovedEmptyState
                        ? Container()
                        : state is RemovedErrorState
                            ?  Center(
                                child: Text('error'.tr),
                              )
                            : Container();
          }),
    );
  }
}
