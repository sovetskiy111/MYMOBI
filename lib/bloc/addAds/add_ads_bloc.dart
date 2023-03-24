import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobi_kg/bloc/addAds/add_ads_event.dart';
import 'package:mobi_kg/bloc/addAds/add_ads_state.dart';
import 'package:mobi_kg/const/app_const.dart';
import 'package:mobi_kg/data/repository/auth_repo.dart';
import 'package:mobi_kg/data/repository/auth_status.dart';
import 'package:mobi_kg/data/repository/data_repo.dart';
import 'package:mobi_kg/data/repository/status.dart';

class AddAdsBloc extends Bloc<AddAdsEvent, AddAdsState> {
  final AuthRepo authRepo;
  final Repo dataRepo;
  AddAdsBloc( {required this.dataRepo, required this.authRepo,}) : super(AddAdsInitialState()) {
    on<AddAdsPushDataEvent>((event, emit) async {
      emit(AddAdsLoadingState());
      if (event.adsModel.checkOnEmpty() != AppConst.otherIsEmpty) {
        emit(AddAdsEmptyState(empty: event.adsModel.checkOnEmpty()));
        return;
      }
      final user = await authRepo.getUser();

      final result = await dataRepo.pushAds(adsModel: event.adsModel);

      if (result == Status.successful) {
        if(user?.root!=AppConst.rootAdminFirst){
          final balance = user!.balance - 0;
          await authRepo.pushAds(uid: user.uid, addBalance: balance);
          await authRepo.updateUserParameter();
        }
        emit(AddAdsLoadedState());
      } else if (result == Status.networkRequestFailed) {
        emit(AddAdsErrorState(error: AuthStatus().networkRequestFailed));
      } else {
        emit(AddAdsErrorState(error: result));
      }
    });
  }
}
