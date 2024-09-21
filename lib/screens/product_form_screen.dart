import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../services/product_service.dart';

class ProductFormScreen extends StatefulWidget {
  final Product? product;
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
  String totalPrice = '0.00';

  ProductService productService = ProductService();

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

  void _calculateTotalPrice() {
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
        title: Text(widget.product == null ? 'Create Product' : 'Update Product'),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: productName,
                decoration: InputDecoration(labelText: 'Product Name'),
                onSaved: (value) => productName = value!,
                validator: (value) => value!.isEmpty ? 'Enter product name' : null,
              ),
              TextFormField(
                initialValue: productCode,
                decoration: InputDecoration(labelText: 'Product Code'),
                onSaved: (value) => productCode = value!,
                validator: (value) => value!.isEmpty ? 'Enter product code' : null,
              ),
              TextFormField(
                initialValue: unitPrice,
                decoration: InputDecoration(labelText: 'Unit Price'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  unitPrice = value;
                  _calculateTotalPrice();
                },
                validator: (value) => value!.isEmpty ? 'Enter unit price' : null,
              ),
              TextFormField(
                initialValue: qty,
                decoration: InputDecoration(labelText: 'Quantity'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  qty = value;
                  _calculateTotalPrice();
                },
                validator: (value) => value!.isEmpty ? 'Enter quantity' : null,
              ),
              SizedBox(height: 16),
              Text('Total Price: \$${totalPrice}'),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text(widget.product == null ? 'Create' : 'Update'),
                style: ElevatedButton.styleFrom(primary: Colors.purple),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
