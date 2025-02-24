import 'package:pagination_example/data/models/user_model.dart';

class PaginatedUsersResponse {
  final int page;
  final int perPage;
  final int total;
  final int totalPages;
  final List<UserModel> users;

  PaginatedUsersResponse({
    required this.page,
    required this.perPage,
    required this.total,
    required this.totalPages,
    required this.users,
  });

  factory PaginatedUsersResponse.fromJson(Map<String, dynamic> json) {
    final List<dynamic> data = json['data'];
    final users = data.map((userJson) => UserModel.fromJson(userJson)).toList();
    return PaginatedUsersResponse(
      page: json['page'] as int,
      perPage: json['per_page'] as int,
      total: json['total'] as int,
      totalPages: json['total_pages'] as int,
      users: users,
    );
  }
}
