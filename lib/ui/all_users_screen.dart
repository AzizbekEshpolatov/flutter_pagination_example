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
  int page = 1;
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadMore(page);
    scrollController.addListener(() {
      debugPrint("CURRENT LIST PIXEL: ${scrollController.position.pixels}");
      debugPrint(
          "MAX LIST PIXEL: ${scrollController.position.maxScrollExtent}");
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent) {
        _loadMore(page);
      }
    });
  }

  void _loadMore(int currentPage) {
    final bloc = context.read<UsersBloc>();
    if (bloc.state.status != UserStatus.loading) {
      bloc.add(FetchUsers(page: currentPage));
      page++;
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
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
          } else {
            return ListView.builder(
              controller: scrollController,
              itemCount: state.users.length + 1,
              itemBuilder: (context, index) {
                if (index == state.users.length) {
                  return const SizedBox(
                    height: 40,
                    child: Center(child: CircularProgressIndicator()),
                  );
                } else {
                  final user = state.users[index];
                  return UserItem(user: user);
                }
              },
            );
          }
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
