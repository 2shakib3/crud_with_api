import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/product_model.dart';
import '../services/product_service.dart';

class ProductFormScreen extends StatefulWidget {
  final Product? product; // product will be null if creating a new one

  ProductFormScreen({this.product});

  @override
  _ProductFormScreenState createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();
  String productName = '';
  String productCode = '';
  String img = '';
  String unitPrice = '';
  String qty = '';
  String totalPrice = '';

  // Initialize form with product data if editing
  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      productName = widget.product!.productName;
      productCode = widget.product!.productCode;
      img = widget.product!.img;
      unitPrice = widget.product!.unitPrice;
      qty = widget.product!.qty;
      totalPrice = widget.product!.totalPrice;
    }
  }

  // Function to show Snackbar
  void showConfirmationSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  // Function to create or update the product
  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        if (widget.product == null) {
          // Create new product
          await ProductService.createProduct(Product(
            productName: productName,
            productCode: productCode,
            img: img,
            unitPrice: unitPrice,
            qty: qty,
            totalPrice: (double.parse(unitPrice) * double.parse(qty)).toString(),
            createdDate: DateTime.now().toString(),
          ));
          showConfirmationSnackbar('Product created successfully!');
        } else {
          // Update existing product
          await ProductService.updateProduct(widget.product!.id!, Product(
            productName: productName,
            productCode: productCode,
            img: img,
            unitPrice: unitPrice,
            qty: qty,
            totalPrice: (double.parse(unitPrice) * double.parse(qty)).toString(),
            createdDate: widget.product!.createdDate,
          ));
          showConfirmationSnackbar('Product updated successfully!');
        }
        Navigator.of(context).pop();
      } catch (e) {
        print('Error: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save product!'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product == null ? 'Create Product' : 'Edit Product'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                initialValue: productName,
                decoration: InputDecoration(labelText: 'Product Name'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a product name';
                  }
                  return null;
                },
                onSaved: (value) {
                  productName = value!;
                },
              ),
              // Other fields for productCode, img, unitPrice, qty
              ElevatedButton(
                onPressed: _submitForm,
                child: Text(widget.product == null ? 'Create' : 'Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
