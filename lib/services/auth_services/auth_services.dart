import 'package:http/http.dart' as http;

class AuthService {
  Future<void> loginUser(String username, String password) async {
    final response = await http.post(
      Uri.parse('https://fakestoreapi.com/auth/login'),
      body: {
        'username': username,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      print('Login successful');
      // Do something with the token, save it securely etc.
    } else {
      throw Exception('Failed to login.');
    }
  }
}
