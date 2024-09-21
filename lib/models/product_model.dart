// class Product {
//   String? id;
//   String productName;
//   String productCode;
//   String img;
//   String unitPrice;
//   String qty;
//   String totalPrice;
//   String createdDate;
//
//   Product({
//     this.id,
//     required this.productName,
//     required this.productCode,
//     required this.img,
//     required this.unitPrice,
//     required this.qty,
//     required this.totalPrice,
//     required this.createdDate,
//   });
//
//   factory Product.fromJson(Map<String, dynamic> json) {
//     return Product(
//       id: json['_id'],
//       productName: json['productName'],
//       productCode: json['productCode'],
//       img: json['img'],
//       unitPrice: json['unitPrice'],
//       qty: json['qty'],
//       totalPrice: json['totalPrice'],
//       createdDate: json['createdDate'],
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'productName': productName,
//       'productCode': productCode,
//       'img': img,
//       'unitPrice': unitPrice,
//       'qty': qty,
//       'totalPrice': totalPrice,
//       'createdDate': createdDate,
//     };
//   }
// }
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
      id: json['id'] as String?,
      productName: json['productName'] ?? '',
      productCode: json['productCode'] ?? '',
      img: json['img'] ?? '',
      unitPrice: json['unitPrice'] ?? '0',
      qty: json['qty'] ?? '0',
      totalPrice: json['totalPrice'] ?? '0.00',
      createdDate: json['createdDate'] ?? DateTime.now().toString(),
    );
  }

  // Convert Product instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productName': productName,
      'productCode': productCode,
      'img': img,
      'unitPrice': unitPrice,
      'qty': qty,
      'totalPrice': totalPrice,
      'createdDate': createdDate,
    };
  }
}

