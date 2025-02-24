import 'package:equatable/equatable.dart';

abstract class UserEvent extends Equatable {}

class FetchUsers extends UserEvent {
  @override
  List<Object?> get props => [];
}
