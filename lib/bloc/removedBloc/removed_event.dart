import 'package:mobi_kg/data/models/ads_model.dart';

abstract class RemovedEvent{}
class RemoveAdsEvent extends RemovedEvent{
  final AdsModel adsModel;
  final String? user;
  RemoveAdsEvent( {required this.adsModel,this.user,});
}
class RemoveGetAdsEvent extends RemovedEvent{}
class RemoveUserGetAdsEvent extends RemovedEvent{
  final String user;
  RemoveUserGetAdsEvent({required this.user});
}