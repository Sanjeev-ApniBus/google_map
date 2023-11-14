part of 'custom_info_window_bloc.dart';

@immutable
abstract class CustomInfoWindowState {}

class CustomInfoWindowInitial extends CustomInfoWindowState {
}class CustomInfoWindowChange extends CustomInfoWindowState {
  final int Luggage;

  CustomInfoWindowChange({required this.Luggage});
}

