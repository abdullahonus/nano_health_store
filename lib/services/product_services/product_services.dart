import 'dart:convert';
import 'package:http/http.dart' as http;

class ProductService {
  Future<List<dynamic>> getAllProducts() async {
    final response =
        await http.get(Uri.parse('https://fakestoreapi.com/products'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load products.');
    }
  }

  Future<Map<String, dynamic>> getProduct(int id) async {
    final response =
        await http.get(Uri.parse('https://fakestoreapi.com/products/$id'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load product.');
    }
  }
}
