import 'package:mobi_kg/bloc/addAds/add_ads_bloc.dart';
import 'package:mobi_kg/bloc/adminBloc/admin_bloc.dart';
import 'package:mobi_kg/bloc/authBloc/auth_bloc.dart';
import 'package:mobi_kg/bloc/homeBloc/home_bloc.dart';
import 'package:mobi_kg/bloc/removedBloc/removed_bloc.dart';
import 'package:mobi_kg/bloc/searchBloc/search_bloc.dart';
import 'package:mobi_kg/const/app_const.dart';
import 'package:mobi_kg/const/app_language.dart';
import 'package:mobi_kg/const/app_routs_name.dart';
import 'package:mobi_kg/data/repository/auth_repo.dart';
import 'package:mobi_kg/data/repository/data_repo.dart';
import 'package:mobi_kg/data/repository/language_saved.dart';
import 'package:mobi_kg/ui/pages/about_page.dart';
import 'package:mobi_kg/ui/pages/add_ads_page.dart';
import 'package:mobi_kg/ui/pages/add_balance_page.dart';
import 'package:mobi_kg/ui/pages/auth/login_page.dart';
import 'package:mobi_kg/ui/pages/auth/register_page.dart';
import 'package:mobi_kg/ui/pages/auth/reset_password_page.dart';
import 'package:mobi_kg/ui/pages/home_page.dart';
import 'package:mobi_kg/ui/pages/removed_page.dart';
import 'package:mobi_kg/ui/pages/security_page.dart';
import 'package:mobi_kg/ui/pages/update_balance_info.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await LanguageSaved().getLocale();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MultiBlocProvider(
      providers: [
        BlocProvider<AddAdsBloc>(create:(context)=> AddAdsBloc( dataRepo: Repo(),authRepo: AuthRepo())),
        BlocProvider<AdminBloc>(create:(context)=> AdminBloc( AuthRepo() )),
        BlocProvider<AuthBloc>(create:(context)=> AuthBloc(authRepo: AuthRepo(), dataRepo: Repo()  )),
        BlocProvider<HomeBloc>(create:(context)=> HomeBloc( dataRepo: Repo()  )),
        BlocProvider<SearchBloc>(create:(context)=> SearchBloc( Repo()  )),
        BlocProvider<RemovedBloc>(create:(context)=> RemovedBloc( Repo()  )),
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        translations: AppLanguage(),
        title: AppConst.appName,
        color: Colors.red,
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.green,
        ),
        initialRoute: AppRoutsName.homePage,
        routes: {
          AppRoutsName.homePage: (context) => const Home(),
          AppRoutsName.loginPage: (context) => const LoginPage(),
          AppRoutsName.registerPage: (context) => const RegisterPage(),
          AppRoutsName.resetPasswordPage: (context) => const ResetPasswordPage(),
          AppRoutsName.addAdsPage: (context) => const AddAdsPage(),
          AppRoutsName.addBalancePage: (context) => const AddBalancePage(),
          AppRoutsName.updateBalanceInfo: (context) => const UpdateBalanceInfo(),
          AppRoutsName.securityPage: (context) => const SecurityPage(),
          AppRoutsName.aboutPage: (context) => const AboutPage(),
          AppRoutsName.removedPage: (context) => const RemovedPage(),
        },
      ),
    );
  }
}
