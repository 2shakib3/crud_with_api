import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../services/product_service.dart';
import 'product_form_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Product> products = [];
  bool isLoading = true;
  ProductService productService = ProductService();

  void showConfirmationSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }


  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  _fetchProducts() async {
    try {
      List<Product> fetchedProducts = await productService.getProducts();
      setState(() {
        products = fetchedProducts;
        isLoading = false;
      });
      print('Fetched Products: $products');
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching products: $error');
    }
  }


  _deleteProduct(String id) async {
    await productService.deleteProduct(id);
    _fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product List'),
        backgroundColor: Colors.purple,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : products.isEmpty
          ? Center(child: Text('No Product Found'))
          : ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Name: ${product.productName}',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text('Product Code: ${product.productCode}'),
                  Text('Price: \$${product.unitPrice}'),
                  Text('Quantity: ${product.qty}'),
                  Text('Total Price: \$${product.totalPrice}'),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.purple),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductFormScreen(product: product),
                            ),
                          ).then((value) => _fetchProducts());
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () => _deleteProduct(product.id!),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProductFormScreen()),
          ).then((value) => _fetchProducts());
        },
        backgroundColor: Colors.purple,
        child: Icon(Icons.add),
      ),
    );
  }
}
