import 'package:mobi_kg/data/models/ads_model.dart';

abstract class RemovedState{}
class RemovedInitialState extends RemovedState{}
class RemovedLoadingState extends RemovedState{}
class RemovedLoadedState extends RemovedState{
  final List<AdsModel> adsList;
  RemovedLoadedState(this.adsList);
}
class RemovedEmptyState extends RemovedState{}
class RemovedErrorState extends RemovedState{}