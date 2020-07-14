import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gamming_community/API/Mutation.dart';
import 'package:gamming_community/API/Query.dart';
import 'package:gamming_community/class/LoginInfo.dart';
import 'package:gamming_community/repository/sub_repo.dart';
import 'package:gamming_community/resources/values/app_constraint.dart';
import 'package:gamming_community/utils/get_token.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc(LoginState initialState) : super(initialState);

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
      
      try {
        var result =
          await SubRepo.queryGraphQL(await getToken(), query.login(email.trim(), password.trim()));
        //print(result.data.values.first["status"]);
        LoginInfo loginData = LoginInfo.fromJson(result.data);
        /*{
          SharedPreferences refs = await SharedPreferences.getInstance();

          yield LoginSuccess();

        }*/
        if (loginData.status == "SUCCESS") {
          yield LoginSuccess();

          SharedPreferences refs = await SharedPreferences.getInstance();
          refs.setStringList("loginInfo", [email, password]);
          refs.setString("userToken", loginData.token);
          refs.setString("userID", loginData.userID);
          refs.setString("userProfile", loginData.userProfile ?? AppConstraint.default_profile);
          refs.setString("userName", loginData.userName);
          refs.setBool("isLogin", true);
          print(refs.getStringList("loginInfo"));
          //print("loginBloc "+loginData.userID + refs.getBool("isLogin ").toString() + loginData.userProfile + loginData.userName );
        } else {
          yield LoginFailed();
        }
      } catch (e) {
        print(e);
        yield LoginFailed();
      }
    }
    if (event is LoginWithSocial) {
      yield LoginLoading();
    }
  }
}
