import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';

class ProductService {
  final String baseUrl = 'http://164.68.107.70:6060/api/v1';

  // Fetch products (Read)
  Future<List<Product>> fetchProducts() async {
    final response = await http.get(Uri.parse('$baseUrl/ReadProduct'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final products = data['data'] as List;
      return products.map((product) => Product.fromJson(product)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  // Create a product
  Future<void> createProduct(Product product) async {
    final response = await http.post(
      Uri.parse('$baseUrl/CreateProduct'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(product.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to create product');
    }
  }

  // Update a product
  Future<void> updateProduct(String id, Product product) async {
    final response = await http.put(
      Uri.parse('$baseUrl/UpdateProduct/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(product.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update product');
    }
  }

  // Delete a product
  Future<void> deleteProduct(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/DeleteProduct/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete product');
    }
  }
}
