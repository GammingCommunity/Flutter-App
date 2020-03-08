import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gamming_community/API/Mutation.dart';
import 'package:gamming_community/API/Query.dart';
import 'package:gamming_community/API/config1.dart';
import 'package:gamming_community/class/LoginData.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  @override
  LoginState get initialState => LoginInitial();

  Config1 config = Config1();

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
      GraphQLClient client = config.clientToQuery();
      var result = await client.mutate(MutationOptions(documentNode: gql(query.login(email.trim(), password.trim()))));
      try {
        //print(result.data.values.first["status"]);
        LoginData loginData = LoginData.fromJson(result.data);
        {
          SharedPreferences refs = await SharedPreferences.getInstance();

          yield LoginSuccess();
          /*refs.setStringList("userToken", [
            "Baka",
            "39",
            "f6fc42184e6383194abbca3e771cc22622727968c274ba6b586b7993d1beaa0c"
          ]);*/
        }
        if (loginData.status == "SUCCESS") {
          yield LoginSuccess();

          SharedPreferences refs = await SharedPreferences.getInstance();
          refs.setStringList("userToken", [loginData.userName,loginData.userID,loginData.token]);
          
          print(loginData.userID);
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
