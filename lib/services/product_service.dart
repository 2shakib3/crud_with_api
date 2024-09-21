import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';

class ProductService {
  final String baseUrl = 'http://164.68.107.70:6060/api/v1';

  Future<List<Product>> getProducts() async {
    final response = await http.get(Uri.parse('$baseUrl/ReadProduct'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      print('API Response: $jsonResponse');
      final List<dynamic> data = jsonResponse['data'];
      return data.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }



  // Create a new product (POST request)
  Future<void> createProduct(Product product) async {
    final response = await http.post(
      Uri.parse('$baseUrl/CreateProduct'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(product.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to create product');
    }
  }

  // Update a product (PUT request)
  Future<void> updateProduct(String id, Product product) async {
    print('Updating product with ID: $id');
    print('Product to Update: ${product.toJson()}');

    final response = await http.post(
      Uri.parse('$baseUrl/UpdateProduct/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(product.toJson()),
    );

    print('Update Response Status: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode != 200) {
      throw Exception('Failed to update product: ${response.reasonPhrase}');
    }
  }



  // Delete a product (DELETE request)
  Future<void> deleteProduct(String id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/DeleteProduct/$id'),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete product');
    }
  }
}
