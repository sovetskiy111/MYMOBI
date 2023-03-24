import 'package:mobi_kg/bloc/removedBloc/removed_event.dart';
import 'package:mobi_kg/bloc/removedBloc/removed_state.dart';
import 'package:mobi_kg/data/repository/data_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RemovedBloc extends Bloc<RemovedEvent, RemovedState>{
  final Repo repo;
  RemovedBloc(this.repo): super(RemovedInitialState()){

    //Admin get all ad
    on<RemoveGetAdsEvent>((event, emit)async{
      emit(RemovedLoadingState());
      final result = await repo.getAllAds();
      if(result!=null){
        emit(RemovedLoadedState(result));
      }else{
        emit(RemovedErrorState());
      }

    });

    //User get ad
    on<RemoveUserGetAdsEvent>((event, emit)async{
      emit(RemovedLoadingState());
      final result = await repo.getUserAds(event.user);
      if(result!=null){
        emit(RemovedLoadedState(result));
      }else{
        emit(RemovedErrorState());
      }

    });

    

    //removed  ad
   on<RemoveAdsEvent>((event, emit)async{
     emit(RemovedLoadingState());
     for(String path in event.adsModel.images){
       await repo.deleteImage(path);
     }
     final result = await repo.removeAds(event.adsModel.uid,user: event.user);
     if(result!=null){
       emit(RemovedLoadedState(result));
     }else{
       emit(RemovedErrorState());
     }


   });
  }
}