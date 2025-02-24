import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pagination_example/bloc/users_bloc/users_event.dart';
import 'package:pagination_example/bloc/users_bloc/users_state.dart';
import 'package:pagination_example/core/api/users_api.dart';

class UsersBloc extends Bloc<UserEvent, UserState> {
  final UserApiClient repository;
  int _currentPage = 0;
  int _totalPages = 1;
  bool _hasReachedMax = false;

  UsersBloc(this.repository) : super(const UserState()) {
    on<FetchUsers>(_onFetchUsers);
  }

  Future<void> _onFetchUsers(FetchUsers event, Emitter<UserState> emit) async {
    if (_hasReachedMax) return;
    try {
      if (state.status == UserStatus.initial) {
        _currentPage = 1;
        final response = await repository.fetchUsers(page: _currentPage);
        _totalPages = response.totalPages;
        if (response.users.isEmpty || _currentPage >= _totalPages) {
          _hasReachedMax = true;
        }
        return emit(state.copyWith(
          status: UserStatus.success,
          users: response.users,
        ));
      }
      _currentPage++;
      final response = await repository.fetchUsers(page: _currentPage);
      if (response.users.isEmpty || _currentPage >= _totalPages) {
        _hasReachedMax = true;
      }
      emit(state.copyWith(
        status: UserStatus.success,
        users: List.of(state.users)..addAll(response.users),
      ));
    } catch (error) {
      emit(state.copyWith(
        status: UserStatus.failure,
        errorMessage: error.toString(),
      ));
    }
  }
}
