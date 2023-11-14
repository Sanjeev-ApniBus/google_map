import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'custom_info_window_event.dart';
part 'custom_info_window_state.dart';

class CustomInfoWindowBloc extends Bloc<CustomInfoWindowEvent, CustomInfoWindowState> {
  CustomInfoWindowBloc() : super(CustomInfoWindowInitial()) {
    on<CustomInfoChangeEvent>((event, emit) {
      emit(CustomInfoWindowChange(Luggage: event.value));
    });
  }
}
