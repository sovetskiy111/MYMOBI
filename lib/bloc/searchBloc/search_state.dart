import 'package:mobi_kg/data/models/ads_model.dart';

abstract class SearchState{}
class SearchInitialState extends SearchState{}
class SearchLoadingState extends SearchState{}
class SearchLoadedState extends SearchState{
  final List<AdsModel> ads;
  SearchLoadedState({required this.ads});
}
class SearchEmptyState extends SearchState{}
class SearchErrorState extends SearchState{}