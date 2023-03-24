import 'package:mobi_kg/bloc/homeBloc/home_bloc.dart';
import 'package:mobi_kg/bloc/homeBloc/home_event.dart';
import 'package:mobi_kg/bloc/homeBloc/home_state.dart';
import 'package:mobi_kg/const/app_const.dart';
import 'package:mobi_kg/const/app_fonts.dart';
import 'package:mobi_kg/const/app_images.dart';
import 'package:mobi_kg/ui/widget/app_item_ads.dart';
import 'package:mobi_kg/ui/widget/app_shimmer_grid_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

class AppGridAdsWidget extends StatelessWidget {
  const AppGridAdsWidget({Key? key, required this.categoryIndex})
      : super(key: key);
  final int categoryIndex;

  @override
  Widget build(BuildContext context) {
    final widthScreen = MediaQuery.of(context).size.width;
    final bloc = BlocProvider.of<HomeBloc>(context);
    bloc.add(
        HomeGetOfCategoryEvent(category: AppConst.cotegory[categoryIndex]));
    return BlocBuilder<HomeBloc, HomeState>(
      bloc: bloc,
      builder: (context, state) {
        return AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: (state is HomeLoadingState)
                ? const AppShimmerGridWidget()
                : state is HomeLoadedState
                ? MasonryGridView.count(
              padding: const EdgeInsets.all(10),
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              itemCount: state.list.length,
              itemBuilder: (context, index) {
                print('------------------ ${state.list[index].images} --------------------------');
                return AppItemAds(
                    widthScreen: widthScreen,
                    adsModel: state.list[index]);
              },
            )
                : state is HomeEmptyState
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(AppImages.empty),
                  const SizedBox(
                    height: 20,
                  ),
                  Text("empty".tr, style: AppFonts.w500s18.copyWith(color: Colors.greenAccent),)
                ],
              ),
            )
                : state is HomeErrorState
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(AppImages.errorInternet),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                      "networkRequestFailed".tr,style: AppFonts.w500s18.copyWith(color: Colors.greenAccent))
                ],
              ),
            )
                : const Text(''));
      },
    );
  }
}
