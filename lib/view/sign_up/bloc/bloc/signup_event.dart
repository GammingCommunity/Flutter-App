part of 'signup_bloc.dart';

abstract class SignUpEvent extends Equatable {
  const SignUpEvent();
}

class Register extends SignUpEvent {
  final String userName;
  final String loginName;
  final String password;
  final String email;
  @override
  Register({this.email, this.userName,this.loginName, this.password});
  List<Object> get props => [email,userName,loginName, password ];
}
