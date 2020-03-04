import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
part 'room_manager_event.dart';
part 'room_manager_state.dart';

class RoomManagerBloc extends Bloc<RoomManagerEvent, RoomManagerState> {
  @override
  RoomManagerState get initialState => RoomManagerInitial();

  @override
  Stream<RoomManagerState> mapEventToState(
    RoomManagerEvent event,
  ) async* {
      if(event is EditRoom){
        
      }
      if(event is RemoveRoom){

      }
  }
}
