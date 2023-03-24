
import 'package:mobi_kg/bloc/authBloc/auth_event.dart';
import 'package:mobi_kg/bloc/authBloc/auth_state.dart';
import 'package:mobi_kg/data/repository/auth_repo.dart';
import 'package:mobi_kg/data/repository/auth_status.dart';
import 'package:mobi_kg/data/repository/data_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState>{
  final AuthRepo authRepo;
  final Repo dataRepo;
  AuthBloc( {required this.authRepo,required this.dataRepo}): super(AuthInitialState()){

    on<AuthSignInEvent>((event, emit)async{
      emit(AuthLoadingState());
      final result = await authRepo.signIn(
        email: event.email,
        password: event.password,
      );
      getResult(emit, result);
    });

    on<AuthCreateEvent>((event, emit)async{
      emit(AuthLoadingState());
      final result = await authRepo.createAccount(name: event.name, email: event.email, password: event.password);
      getResult(emit, result);
    });

    on<AuthResetPasswordEvent>((event, emit)async{
      emit(AuthLoadingState());
      final result = await authRepo.resetPassword(email: event.email);
      getResult(emit, result);
    });


  }

  void getResult(Emitter<AuthState> emit, String result){
    if(result==AuthStatus().successful){
      emit(AuthLoadedState());
    }else{
      emit(AuthErrorState(result));
    }
  }

}