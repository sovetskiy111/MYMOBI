import 'package:mobi_kg/data/models/user_model.dart';

abstract class AdminState{}
class AdminInitialState extends AdminState{}
class AdminLoadingState extends AdminState{}
class AdminLoadedState extends AdminState{
  final List<UserModel> users;
  AdminLoadedState(this.users);
}
class AdminEmptyState extends AdminState{}
class AdminErrorState extends AdminState{}