abstract class AuthEvent{}
class AuthCreateEvent extends AuthEvent{
  final String name;
  final String email;
  final String password;
  AuthCreateEvent({required this.name, required this.email, required this.password});
}
class AuthSignInEvent extends AuthEvent{
  final String email;
  final String password;
  AuthSignInEvent({required this.email, required this.password});
}
class AuthResetPasswordEvent extends AuthEvent{
  final String email;
  AuthResetPasswordEvent({required this.email});
}
