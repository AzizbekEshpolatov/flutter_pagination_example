import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pagination_example/bloc/users_bloc/users_bloc.dart';
import 'package:pagination_example/ui/all_users_screen.dart';
import 'package:http/http.dart' as http;
import 'core/api/users_api.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              UsersBloc(UserApiClient(httpClient: http.Client())),
        ),
      ],
      child: MaterialApp(
        title: 'Pagination example',
        theme: ThemeData(useMaterial3: true),
        home: UsersScreen(),
      ),
    );
  }
}
