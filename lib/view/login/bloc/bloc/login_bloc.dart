import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gamming_community/API/Mutation.dart';
import 'package:gamming_community/API/Query.dart';
import 'package:gamming_community/class/LoginData.dart';
import 'package:gamming_community/repository/sub_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  @override
  LoginState get initialState => LoginInitial();

  GraphQLMutation mutation = GraphQLMutation();
  GraphQLQuery query = GraphQLQuery();
  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is Submited) {
      yield LoginLoading();
      
      String email = event.email;
      String password = event.password;
      var result = await SubRepo.queryGraphQL("", query.login(email.trim(), password.trim()));
      try {
        //print(result.data.values.first["status"]);
        LoginData loginData = LoginData.fromJson(result.data);
        /*{
          SharedPreferences refs = await SharedPreferences.getInstance();

          yield LoginSuccess();

        }*/
        if (loginData.status == "SUCCESS") {
          yield LoginSuccess();

          SharedPreferences refs = await SharedPreferences.getInstance();
          refs.setStringList("userToken", [loginData.userName,loginData.userID,loginData.token]);
          refs.setString("userID", loginData.userID);
          refs.setString("userProfile",loginData.userProfile);
          refs.setString("userName", loginData.userName);
          refs.setBool("isLogin", true);
          print("loginBloc "+loginData.userID + refs.getBool("isLogin ").toString() + loginData.userProfile + loginData.userName );
        } else {
          yield LoginFailed();
        }
      } catch (e) {
        yield LoginFailed();
      }
    }
    if (event is LoginWithSocial) {
      yield LoginLoading();
    }
  }
}
