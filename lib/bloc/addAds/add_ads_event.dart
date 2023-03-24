
import 'package:mobi_kg/data/models/ads_model.dart';

abstract class AddAdsEvent{}
class AddAdsPushDataEvent extends AddAdsEvent{
  final AdsModel adsModel;
  AddAdsPushDataEvent({required this.adsModel});
}