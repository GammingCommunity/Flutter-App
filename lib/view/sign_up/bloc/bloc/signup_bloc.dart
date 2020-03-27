import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gamming_community/API/Mutation.dart';
import 'package:gamming_community/class/LoginData.dart';
import 'package:gamming_community/repository/sub_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'signup_event.dart';
part 'signup_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  GraphQLMutation mutation = GraphQLMutation();
 

  @override
  SignUpState get initialState => SignUpInitial();

  @override
  Stream<SignUpState> mapEventToState(
    SignUpEvent event,
  ) async* {
    if (event is Register) {
      yield SignUpLoading();

      try {
        var result = await SubRepo.mutationGraphQL("", mutation.register(event.loginName, event.password, event.userName));

        RegisterData registerResult= RegisterData.fromJson(result.data);
        //print(registerResult.status);
        if(registerResult.status== "SUCCESS"){
          SharedPreferences refs= await SharedPreferences.getInstance();
          refs.setStringList("userToken", [registerResult.token]);
          yield SignUpSuccess();
        }
        else yield SignUpFailed();
      } catch (e) {
        yield SignUpFailed();
      }
    }
  }
}
