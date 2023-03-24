import 'package:mobi_kg/bloc/adminBloc/admin_bloc.dart';
import 'package:mobi_kg/bloc/adminBloc/admin_event.dart';
import 'package:mobi_kg/bloc/adminBloc/admin_state.dart';
import 'package:mobi_kg/ui/widget/app_add_balance_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddBalancePage extends StatefulWidget {
  const AddBalancePage({Key? key}) : super(key: key);

  @override
  State<AddBalancePage> createState() => _AddBalancePageState();
}

class _AddBalancePageState extends State<AddBalancePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Добавить баланс'),
        centerTitle: true,
      ),
      body: const AddBalanceBlocBuilder(),
    );
  }
}

class AddBalanceBlocBuilder extends StatelessWidget {
  const AddBalanceBlocBuilder({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc= BlocProvider.of<AdminBloc>(context);
    bloc.add(AdminGetUsers());
    return BlocBuilder<AdminBloc, AdminState>(
      builder: (context, state) {
        if(state is AdminLoadingState){
          return const Center(child:  CircularProgressIndicator());
        }else if(state is AdminLoadedState){
          return ListView.builder(
              itemCount: state.users.length,
              itemBuilder: ((context, index) {
            return AppAddBalanceItem(user: state.users[index], bloc: bloc,);
          }));
        }else if(state is AdminEmptyState){
          return Container();
        }else if(state is AdminErrorState){
          return Container();
        }else{
          return Container();
        }

      }
    );
  }
}
