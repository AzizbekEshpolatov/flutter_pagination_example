import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pagination_example/bloc/users_bloc/users_bloc.dart';
import 'package:pagination_example/bloc/users_bloc/users_event.dart';
import 'package:pagination_example/bloc/users_bloc/users_state.dart';
import 'package:pagination_example/data/models/user_model.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<UsersBloc>().add(FetchUsers());
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (currentScroll >= maxScroll - 200) {
      final currentState = context.read<UsersBloc>().state;
      if (currentState.status != UserStatus.loading &&
          !currentState.hasReachedMax) {
        context.read<UsersBloc>().add(FetchUsers());
      }
    }
    debugPrint("Scroll position: $currentScroll");
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Users")),
      body: BlocBuilder<UsersBloc, UserState>(
        builder: (context, state) {
          if (state.status == UserStatus.initial && state.users.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.status == UserStatus.failure) {
            return Center(child: Text("Error: ${state.errorMessage}"));
          } else if (state.status == UserStatus.success ||
              state.status == UserStatus.loading) {
            if (state.users.isEmpty) {
              return const Center(child: Text("No users available"));
            }
            final itemCount = state.hasReachedMax
                ? state.users.length
                : state.users.length +
                    (state.status == UserStatus.loading ? 1 : 0);

            return ListView.builder(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: itemCount,
              itemBuilder: (context, index) {
                if (index >= state.users.length) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                final user = state.users[index];
                return UserItem(user: user);
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class UserItem extends StatelessWidget {
  final UserModel user;

  const UserItem({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      elevation: 4,
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(user.avatar),
          radius: 35,
        ),
        title: Text(
          '${user.firstName} ${user.lastName}',
          style: const TextStyle(fontSize: 22),
        ),
        subtitle: Text(
          user.email,
          style: const TextStyle(fontSize: 22),
        ),
      ),
    );
  }
}
