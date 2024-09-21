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

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id'],
      productName: json['ProductName'],
      productCode: json['ProductCode'],
      img: json['Img'],
      unitPrice: json['UnitPrice'],
      qty: json['Qty'],
      totalPrice: json['TotalPrice'],
      createdDate: json['CreatedDate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ProductName': productName,
      'ProductCode': productCode,
      'Img': img,
      'UnitPrice': unitPrice,
      'Qty': qty,
      'TotalPrice': totalPrice,
    };
  }
}
