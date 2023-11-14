part of 'custom_info_window_bloc.dart';

@immutable
abstract class CustomInfoWindowEvent {}

class CustomInfoChangeEvent extends CustomInfoWindowEvent{
  final int value;

  CustomInfoChangeEvent({required this.value});
}
