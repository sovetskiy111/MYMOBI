import 'package:mobi_kg/bloc/adminBloc/admin_event.dart';
import 'package:mobi_kg/bloc/adminBloc/admin_state.dart';
import 'package:mobi_kg/data/repository/auth_repo.dart';
import 'package:mobi_kg/data/repository/status.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminBloc extends Bloc<AdminEvent, AdminState> {
  final AuthRepo repo;

  AdminBloc(this.repo) : super(AdminInitialState()) {
    on<AdminGetUsers>((event, emit) async {
      emit(AdminLoadingState());
      final result = await repo.getUsers();
      if (result != null) {
        if (result.isNotEmpty) {
          emit(AdminLoadedState(result));
        } else {
          emit(AdminEmptyState());
        }
      } else {
        emit(AdminErrorState());
      }
    });

    on<AdminAddBalanceState>((event, emit) async {
      emit(AdminLoadingState());
      final pushResult =
          await repo.pushAds(uid: event.uid, addBalance: event.balance);
      if (pushResult == Status.successful) {
        final result = await repo.getUsers();
        if (result != null) {
          if (result.isNotEmpty) {
            emit(AdminLoadedState(result));
          } else {
            emit(AdminEmptyState());
          }
        } else {
          emit(AdminErrorState());
        }
      } else {
        emit(AdminErrorState());
      }
    });
  }
}
