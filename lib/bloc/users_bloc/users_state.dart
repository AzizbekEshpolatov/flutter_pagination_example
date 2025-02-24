import 'package:pagination_example/data/models/user_model.dart';

enum UserStatus { initial, loading, success, failure }

class UserState {
  final UserStatus status;
  final List<UserModel> users;
  final int page;
  final int totalPages;
  final bool hasReachedMax;
  final String errorMessage;

  const UserState({
    this.status = UserStatus.initial,
    this.users = const [],
    this.page = 1,
    this.totalPages = 1,
    this.hasReachedMax = false,
    this.errorMessage = '',
  });

  UserState copyWith({
    UserStatus? status,
    List<UserModel>? users,
    int? page,
    int? totalPages,
    bool? hasReachedMax,
    String? errorMessage,
  }) {
    return UserState(
      status: status ?? this.status,
      users: users ?? this.users,
      page: page ?? this.page,
      totalPages: totalPages ?? this.totalPages,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  factory UserState.initial() {
    return UserState(
      status: UserStatus.initial,
      users: [],
      page: 0,
      totalPages: 0,
      hasReachedMax: false,
      errorMessage: '',
    );
  }
}
