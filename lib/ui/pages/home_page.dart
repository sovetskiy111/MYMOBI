import 'package:mobi_kg/const/app_const.dart';
import 'package:mobi_kg/ui/pages/search_page.dart';
import 'package:mobi_kg/ui/widget/app_drawer_widget.dart';
import 'package:mobi_kg/ui/widget/app_gradient_general.dart';
import 'package:mobi_kg/ui/widget/app_grid_ads_widget.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<StatefulWidget> createState() => _HomePage();
}

class _HomePage extends State<Home> with TickerProviderStateMixin {
  late TabController tabController;
  bool isSearch = false;
  int categoryIndex = 0;


  @override
  void initState() {
    super.initState();
    tabController =
        TabController(length: AppConst.cotegory.length, vsync: this);
    tabController.addListener(() {});
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: AppConst.cotegory.length,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          flexibleSpace: const AppGradientGeneral(),
          title: Row(
            children: [
              const Text(AppConst.appName),
              const Spacer(),
              IconButton(
                  onPressed: () {
                    Navigator.of(context).push(PageRouteBuilder(
                      pageBuilder: (_, a1, a2) =>  const SearchPage(),
                      transitionDuration: Duration.zero,
                      reverseTransitionDuration: Duration.zero,
                    ));
                  },
                  icon: const Icon(Icons.search))
            ],
          ),
          bottom: TabBar(onTap: (index){
            setState(() {
              categoryIndex = index;
            });

          },
            splashBorderRadius: BorderRadius.circular(50),
            padding: const EdgeInsets.symmetric(vertical: 5),
            indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(50), // Creates border
                color: Colors.lime),
            isScrollable: true,
            tabs: List.generate(AppConst.cotegory.length, (index) {
              return SizedBox(
                height: 30,
                child: Tab(
                  child: Text(
                    AppConst.cotegory[index],
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }),
          ),
        ),
        drawer: const AppDrawer(),
        body:  AppGridAdsWidget(categoryIndex: categoryIndex,),

      ),
    );
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }
}


