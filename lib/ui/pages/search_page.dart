import 'package:mobi_kg/bloc/searchBloc/search_bloc.dart';
import 'package:mobi_kg/bloc/searchBloc/search_event.dart';
import 'package:mobi_kg/bloc/searchBloc/search_state.dart';
import 'package:mobi_kg/ui/widget/app_gradient_general.dart';
import 'package:mobi_kg/ui/widget/app_item_ads.dart';
import 'package:mobi_kg/ui/widget/app_shimmer_grid_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final widthScreen = MediaQuery.of(context).size.width;
    final bloc = BlocProvider.of<SearchBloc>(context);
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.blue,
          flexibleSpace: const AppGradientGeneral(),
          // The search area here
          title: Container(
            width: double.infinity,
            height: 40,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(5)),
            child: Center(
              child: TextField(
                controller: searchController,
                autofocus: true,
                decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Colors.green,
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(
                        Icons.clear,
                        color: Colors.green,
                      ),
                      onPressed: () {
                        searchController.clear();
                      },
                    ),
                    hintText: 'hintSearch'.tr,
                    border: InputBorder.none),
                onSubmitted: (value) {
                  String searchText = value.toLowerCase();
                  searchText = searchText.replaceAll(".", ' ');
                  searchText = searchText.replaceAll(',', ' ');
                  searchText = searchText.replaceAll("-", ' ');
                  searchText = searchText.replaceAll("!", ' ');
                  searchText = searchText.replaceAll("?", ' ');
                  searchText = searchText.replaceAll("  ", ' ');
                  searchText = searchText.replaceAll("   ", ' ');
                  final searchList = searchText.split(' ');
                  bloc.add(SearchGetEvent(searchList: searchList));
                },
              ),
            ),
          )),
      body: BlocBuilder<SearchBloc, SearchState>(
        bloc: bloc,
        builder: (context, state) {
          return state is SearchLoadingState
              ? const AppShimmerGridWidget()
              : state is SearchLoadedState
                  ? MasonryGridView.count(
                      padding: const EdgeInsets.all(10),
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      itemCount: state.ads.length,
                      itemBuilder: (context, index) {
                        return AppItemAds(
                            widthScreen: widthScreen,
                            adsModel: state.ads[index]);
                      },
                    )
                  : state is SearchEmptyState
                      ? Center(
                          child: Text('searchEmpty'.tr),
                        )
                      : state is SearchErrorState
                          ? Center(
                              child: Text('networkRequestFailed'.tr),
                            )
                          : Container();
        },
      ),
    );
  }
}
