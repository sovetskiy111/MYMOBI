import 'package:mobi_kg/bloc/homeBloc/home_event.dart';
import 'package:mobi_kg/bloc/homeBloc/home_state.dart';
import 'package:mobi_kg/const/app_const.dart';
import 'package:mobi_kg/data/models/ads_model.dart';
import 'package:mobi_kg/data/repository/data_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState>{
  final Repo dataRepo;
  HomeBloc({required this.dataRepo}): super(HomeInitialState()){
    on<HomeGetAllEvent>((event, emit)async{
      emit(HomeLoadingState());
      final result = await dataRepo.getAllAds();
      getResult(emit, result);

    });
    on<HomeGetOfCategoryEvent>((event, emit)async{
      emit(HomeLoadingState());
      if(event.category==AppConst.cotegory[0]){
        final result = await dataRepo.getAllAds();
        getResult(emit, result);
      }else{
        final result = await dataRepo.getCategory(event.category);
        getResult(emit, result);
      }


    });


  }
  getResult(Emitter<HomeState> emit, List<AdsModel>? result){
    if(result!=null){
      if(result.isNotEmpty){
        emit(HomeLoadedState(list: result));
      }else{
        emit(HomeEmptyState());
      }
    }else{
      emit(HomeErrorState());
    }
  }

}