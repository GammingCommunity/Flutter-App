part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();
  @override

  List<Object> get props => [];
}
class Submited extends LoginEvent{
  final String email;
  final String password;
  const Submited({this.email,this.password});
  @override
  
  List<Object> get props => [email,password];

}
class LoginWithSocial extends LoginEvent{
  
  @override
  List<Object> get props => [];
}
