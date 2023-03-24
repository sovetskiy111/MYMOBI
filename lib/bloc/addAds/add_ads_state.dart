abstract class AddAdsState{}
class AddAdsInitialState extends AddAdsState{}
class AddAdsLoadingState extends AddAdsState{}
class AddAdsLoadedState extends AddAdsState{}
class AddAdsErrorState extends AddAdsState{
  final String error;
  AddAdsErrorState({required this.error});
}
class AddAdsEmptyState extends AddAdsState{
  final int empty;
  AddAdsEmptyState({required this.empty});
}