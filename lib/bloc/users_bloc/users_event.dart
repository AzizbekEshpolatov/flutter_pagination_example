import 'package:equatable/equatable.dart';

abstract class UserEvent extends Equatable {}

class FetchUsers extends UserEvent {
  final int page;

  FetchUsers({required this.page});

  @override
  List<Object?> get props => [page];
}
