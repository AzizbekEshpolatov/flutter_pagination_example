import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pagination_example/bloc/users_bloc/users_event.dart';
import 'package:pagination_example/bloc/users_bloc/users_state.dart';
import 'package:pagination_example/core/api/users_api.dart';

class UsersBloc extends Bloc<UserEvent, UserState> {
  final UserApiClient repository;

  UsersBloc(this.repository) : super(const UserState()) {
    on<FetchUsers>(_onFetchUsers);
  }

  Future<void> _onFetchUsers(FetchUsers event, Emitter<UserState> emit) async {
    if (state.hasReachedMax) return;
    try {
      if (state.status == UserStatus.initial) {
        final response = await repository.fetchUsers(page: 1);
        return emit(state.copyWith(
          status: UserStatus.success,
          users: response.users,
          page: response.page,
          totalPages: response.totalPages,
          hasReachedMax: response.page >= response.totalPages,
        ));
      }

      final nextPage = state.page + 1;
      final response = await repository.fetchUsers(page: nextPage);

      emit(
        response.users.isEmpty
            ? state.copyWith(hasReachedMax: true)
            : state.copyWith(
                status: UserStatus.success,
                users: List.of(state.users)..addAll(response.users),
                page: response.page,
                totalPages: response.totalPages,
                hasReachedMax: response.page >= response.totalPages,
              ),
      );
    } catch (error) {
      emit(state.copyWith(
        status: UserStatus.failure,
        errorMessage: error.toString(),
      ));
    }
  }
}
