abstract class AdminEvent{}
class AdminGetUsers extends AdminEvent{}
class AdminAddBalanceState extends AdminEvent{
  final String uid;
  final int balance;
  AdminAddBalanceState({required this.uid,required this.balance});
}