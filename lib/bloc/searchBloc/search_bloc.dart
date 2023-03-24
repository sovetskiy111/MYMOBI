import 'package:mobi_kg/bloc/searchBloc/search_event.dart';
import 'package:mobi_kg/bloc/searchBloc/search_state.dart';
import 'package:mobi_kg/data/repository/data_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState>{
  final Repo repo;
  SearchBloc(this.repo): super(SearchInitialState()){
    on<SearchGetEvent>((event, emit)async{
      emit(SearchLoadingState());
      final result = await repo.searchData(event.searchList);
      if(result!=null){
        if(result.isNotEmpty){
          emit(SearchLoadedState(ads: result));
        }else{
          emit(SearchEmptyState());
        }
      }else{
        emit(SearchErrorState());
      }
    });

  }

}