import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../data/models/pagination_model.dart';

class UserApiClient {
  final http.Client httpClient;

  UserApiClient({required this.httpClient});

  Future<PaginatedUsersResponse> fetchUsers({int page = 1}) async {
    final url = Uri.parse('https://reqres.in/api/users?page=$page');
    final response = await httpClient.get(url);

    if (response.statusCode != 200) {
      throw Exception('Error fetching users: ${response.statusCode}');
    }

    final jsonResponse = jsonDecode(response.body);
    return PaginatedUsersResponse.fromJson(jsonResponse);
  }
}
