class Product {
  String? id;
  String productName;
  String productCode;
  String img;
  String unitPrice;
  String qty;
  String totalPrice;
  String createdDate;

  Product({
    this.id,
    required this.productName,
    required this.productCode,
    required this.img,
    required this.unitPrice,
    required this.qty,
    required this.totalPrice,
    required this.createdDate,
  });

  // Factory method to create a Product from JSON
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id'] as String?,
      productName: json['ProductName'] ?? '',
      productCode: json['ProductCode'] ?? '',
      img: json['Img'] ?? '',
      unitPrice: json['UnitPrice'] ?? '0',
      qty: json['Qty'] ?? '0',
      totalPrice: json['TotalPrice'] ?? '0.00',
      createdDate: json['CreatedDate'] ?? DateTime.now().toString(),
    );
  }

  // Convert Product instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'ProductName': productName,
      'ProductCode': productCode,
      'Img': img,
      'UnitPrice': unitPrice,
      'Qty': qty,
      'TotalPrice': totalPrice,
      'CreatedDate': createdDate,
    };
  }
}

