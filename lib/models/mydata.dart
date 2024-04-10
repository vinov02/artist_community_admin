
import 'dart:convert';

Product productFromJson(String str) => Product.fromJson(json.decode(str));

String productToJson(Product data) => json.encode(data.toJson());

class Product {
  String message;
  List<ProductElement> product;

  Product({
    required this.message,
    required this.product,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    message: json["message"],
    product: List<ProductElement>.from(json["product"].map((x) => ProductElement.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "product": List<dynamic>.from(product.map((x) => x.toJson())),
  };
}

class ProductElement {
  int id;
  String name;
  String image;
  DateTime createdAt;
  DateTime updatedAt;

  ProductElement({
    required this.id,
    required this.name,
    required this.image,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProductElement.fromJson(Map<String, dynamic> json) => ProductElement(
    id: json["id"],
    name: json["name"],
    image: json["image"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "image": image,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
