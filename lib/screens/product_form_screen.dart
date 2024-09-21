import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../services/product_service.dart';

class ProductFormScreen extends StatefulWidget {
  final Product? product;
  const ProductFormScreen({super.key, this.product});

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

  ProductService productService = ProductService();

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      // Pre-fill values for editing
      productName = widget.product!.productName;
      productCode = widget.product!.productCode;
      img = widget.product!.img;
      unitPrice = widget.product!.unitPrice;
      qty = widget.product!.qty;
      totalPrice = widget.product!.totalPrice;
    }
  }

  _calculateTotalPrice() {
    if (qty.isNotEmpty && unitPrice.isNotEmpty) {
      final quantity = int.tryParse(qty) ?? 0;
      final price = double.tryParse(unitPrice) ?? 0;
      final total = quantity * price;
      setState(() {
        totalPrice = total.toStringAsFixed(2);
      });
    }
  }

  _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      Product product = Product(
        productName: productName,
        productCode: productCode,
        img: img,
        unitPrice: unitPrice,
        qty: qty,
        totalPrice: totalPrice,
        createdDate: DateTime.now().toString(),
      );

      if (widget.product == null) {
        await productService.createProduct(product);
      } else {
        await productService.updateProduct(widget.product!.id!, product);
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product == null ? 'Create Product' : 'Edit Product'),
        backgroundColor: Colors.purple, // Custom AppBar Color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField('Product Name', productName, (value) => productName = value!),
              _buildTextField('Product Code', productCode, (value) => productCode = value!),
              _buildTextField('Image URL', img, (value) => img = value!, isOptional: true),
              _buildTextField('Unit Price', unitPrice, (value) {
                unitPrice = value!;
                _calculateTotalPrice(); // Recalculate total price
              }, isNumeric: true),
              _buildTextField('Quantity', qty, (value) {
                qty = value!;
                _calculateTotalPrice(); // Recalculate total price
              }, isNumeric: true),
              _buildTextField('Total Price', totalPrice, null, isNumeric: true, isReadOnly: true),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple, // Button color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  widget.product == null ? 'Create' : 'Update',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String initialValue, void Function(String?)? onSaved,
      {bool isNumeric = false, bool isReadOnly = false, bool isOptional = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        initialValue: initialValue,
        keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
        readOnly: isReadOnly,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.purple), // Label Color
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.purple), // Border color
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.purple), // Focused border color
          ),
        ),
        onSaved: onSaved,
        validator: isOptional ? null : (value) {
          if (value == null || value.isEmpty) {
            return '$label is required';
          }
          return null;
        },
      ),
    );
  }
}
