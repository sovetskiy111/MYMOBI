import '../../data/models/ads_model.dart';

abstract class HomeState{}
class HomeInitialState extends HomeState{}
class HomeEmptyState extends HomeState{}
class HomeLoadingState extends HomeState{}
class HomeLoadedState extends HomeState{
  final List<AdsModel> list;
  HomeLoadedState({required this.list});
}
class HomeErrorState extends HomeState{}