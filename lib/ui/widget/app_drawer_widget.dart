import 'package:animated_background/animated_background.dart';
import 'package:mobi_kg/const/app_const.dart';
import 'package:mobi_kg/const/app_fonts.dart';
import 'package:mobi_kg/const/app_images.dart';
import 'package:mobi_kg/const/app_routs_name.dart';
import 'package:mobi_kg/data/models/user_model.dart';
import 'package:mobi_kg/data/repository/auth_repo.dart';
import 'package:mobi_kg/data/repository/language_saved.dart';
import 'package:mobi_kg/ui/widget/app_drawer_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickalert/quickalert.dart';
import 'package:share_plus/share_plus.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  UserModel? user;

  Future<void> _getUser() async {
    user = await AuthRepo().getUser();
    setState(() {
      user = user;
    });
  }

  @override
  void initState() {
    super.initState();
    _getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            UserHeaderWidget(user: user),
            AddAdsWidget(
              user: user,
            ),
            user != null && user?.root == AppConst.rootAdminFirst
                ? const ButtonsAdminWidget()
                :user != null? Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10))),
                    margin: const EdgeInsets.symmetric(
                        horizontal: 17, vertical: 10),
                    child: Column(
                      children: [
                        AppDrawerButton(
                          text: 'removeAds'.tr,
                          icon: Icons.remove_circle_outline,
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pushNamed(
                                context, AppRoutsName.removedPage);
                          },
                        ),
                      ],
                    )):const Text(''),
            const ButtonsWidget(),
            SignButton(
              user: user,
            ),
          ],
        ),
      ),
    );
  }
}

class SignButton extends StatelessWidget {
  const SignButton({
    Key? key,
    required this.user,
  }) : super(key: key);
  final UserModel? user;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 3),
      decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: const BorderRadius.all(Radius.circular(10))),
      margin: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
      child: AppDrawerButton(
        text: user == null ? 'signIn'.tr : 'signOut'.tr,
        icon: Icons.output,
        onPressed: () {
          if (user == null) {
            Navigator.pushNamed(context, AppRoutsName.loginPage);
          } else {
            AuthRepo().signOut();
            Navigator.of(context).pop();
          }
        },
        endArrowIcon: false,
      ),
    );
  }
}

class ButtonsAdminWidget extends StatelessWidget {
  const ButtonsAdminWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: const BorderRadius.all(Radius.circular(10))),
        margin: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
        child: Column(
          children: [
            Text("admin".tr),
            const SizedBox(
              height: 10,
            ),
            AppDrawerButton(
              text: 'addBalance'.tr,
              icon: Icons.monetization_on_outlined,
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, AppRoutsName.addBalancePage);
              },
            ),
            AppDrawerButton(
              text: 'removeAds'.tr,
              icon: Icons.remove_circle_outline,
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, AppRoutsName.removedPage);
              },
            ),
          ],
        ));
  }
}

class ButtonsWidget extends StatelessWidget {
  const ButtonsWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: const BorderRadius.all(Radius.circular(10))),
        margin: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
        child: Column(
          children: [
            AppDrawerButton(
              text: 'changeLanguage'.tr,
              icon: Icons.language,
              onPressed: () {
                QuickAlert.show(
                    context: context,
                    type: QuickAlertType.loading,
                    barrierDismissible: true,
                    customAsset: AppImages.lang,
                    title: "selectLang".tr,
                    text: '',
                    widget: Column(
                      children: [
                        ListTile(
                          title: const Text(
                            'Кыргыз тили',
                            style: AppFonts.w500s16,
                          ),
                          onTap: ()async {
                            Navigator.pop(context);
                            await LanguageSaved().setLocal('ky', 'KG');
                          },
                        ),
                        ListTile(
                          title: const Text(
                            'Русский язык',
                            style: AppFonts.w500s16,
                          ),
                          onTap: ()async {
                            Navigator.pop(context);
                            await LanguageSaved().setLocal('ru', 'RU');
                          },
                        ),
                        ListTile(
                          title: const Text(
                            'English',
                            style: AppFonts.w500s16,
                          ),
                          onTap: ()async {
                            Navigator.pop(context);
                            await LanguageSaved().setLocal('en', 'US');
                          },
                        ),
                      ],
                    ));
              },
            ),
            AppDrawerButton(
              text: 'agreement'.tr,
              icon: Icons.security,
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, AppRoutsName.securityPage);
              },
            ),
            AppDrawerButton(
              text: 'share'.tr,
              icon: Icons.share,
              onPressed: () => _onShare(context),
            ),
            AppDrawerButton(
              text: 'about'.tr,
              icon: Icons.info,
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, AppRoutsName.aboutPage);
              },
            ),
          ],
        ));
  }

  _onShare(BuildContext context) async {
    final box = context.findRenderObject() as RenderBox?;
    Navigator.of(context).pop();

    await Share.share(
      AppConst.shareUrl,
      subject: AppConst.appName,
      sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
    );
  }
}

class AddAdsWidget extends StatelessWidget {
  const AddAdsWidget({
    Key? key,
    required this.user,
  }) : super(key: key);
  final UserModel? user;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: const BorderRadius.all(Radius.circular(10))),
        margin: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
        child: Column(
          children: [
            Text(
              user != null && user?.root == AppConst.rootAdminFirst
                  ? ""
                  : "adsAddWant".tr,
              style: const TextStyle(
                fontSize: 15,
              ),
              textAlign: TextAlign.center,
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.grey[300]!)),
                  onPressed: () {
                    if (user == null) {
                      Navigator.of(context).pop();
                      Navigator.pushNamed(context, AppRoutsName.loginPage);
                    } else {
                      if (user!.root == AppConst.rootAdminFirst ||
                          user!.balance > -1) {
                        Navigator.of(context).pop();
                        Navigator.pushNamed(context, AppRoutsName.addAdsPage);
                      } else {
                        QuickAlert.show(
                          context: context,
                          type: QuickAlertType.info,
                          title: 'addBalance'.tr,
                          text: 'upYouBalance'.tr,
                          barrierDismissible: false,
                          showCancelBtn: true,
                          confirmBtnText: 'yes'.tr,
                          cancelBtnText: 'not'.tr,

                          onConfirmBtnTap: () {
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                            Navigator.pushNamed(
                                context, AppRoutsName.updateBalanceInfo);
                          },
                          onCancelBtnTap: () {
                            Navigator.of(context).pop();
                          },
                        );
                      }
                    }
                  },
                  child: Text(
                    "addAds".tr,
                    style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                        fontWeight: FontWeight.w400),
                  )),
            )
          ],
        ));
  }
}

class UserHeaderWidget extends StatelessWidget {
  const UserHeaderWidget({
    Key? key,
    required this.user,
  }) : super(key: key);
  final UserModel? user;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 150,
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
            Color(0x667ad3e7),
            Color(0x995a9ac1),
            Color(0xcc229ecb),
            Color(0xff069dde),
          ])),
      child: AnimatedBackground(
        vsync: Scaffold.of(context),
        behaviour: RandomParticleBehaviour(
            options: ParticleOptions(
          image: Image.asset(AppImages.starStroke, color: Colors.amber),
          baseColor: Colors.blue,
          particleCount: 50,
          spawnMaxSpeed: 50.0,
          spawnMinSpeed: 20.0,
        )),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: user != null
              ? user?.root == AppConst.rootAdminFirst
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Spacer(),
                        Row(
                          children: [
                            const Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 20,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              user!.name,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 16),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.email,
                              color: Colors.white,
                              size: 20,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(user!.email,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 14)),
                          ],
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          child: Text(
                            'admin'.tr,
                            style:
                                AppFonts.w500s18.copyWith(color: Colors.white),
                          ),
                        )
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Spacer(),
                        Row(
                          children: [
                            const Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 20,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              user!.name,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 16),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.email,
                              color: Colors.white,
                              size: 20,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(user!.email,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 14)),
                          ],
                        ),
                        Container(
                            width: double.infinity,
                            alignment: Alignment.centerLeft,
                            margin: const EdgeInsets.only(top: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text("${'balance'.tr}: ${user!.balance}${'som'.tr}",
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 17)),
                                SizedBox(
                                  height: 25,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      Navigator.pushNamed(context,
                                          AppRoutsName.updateBalanceInfo);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 0, horizontal: 5),
                                      elevation: 0,
                                    ),
                                    child: Text(
                                      'topUp'.tr,
                                      style:
                                          const TextStyle(color: Colors.green),
                                    ),
                                  ),
                                )
                              ],
                            )),
                      ],
                    )
              : const Center(
                  child: Text(
                    AppConst.appName,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w700),
                  ),
                ),
        ),
      ),
    );
  }
}
