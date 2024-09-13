import 'package:json_annotation/json_annotation.dart';

part 'product.g.dart';

@JsonSerializable(includeIfNull: false)
class Product {
  Product({
    this.productId,
    this.categoryId,
    this.categoryName,
    this.sku,
    this.name,
    this.description,
    this.weight,
    this.width,
    this.length,
    this.height,
    this.image,
    this.harga,
    this.id,
  });

  @JsonKey(includeToJson: false)
  final int? productId;

  @JsonKey(name: 'CategoryId')
  int? categoryId;

  @JsonKey(name: 'categoryName')
  String? categoryName;
  String? sku;
  String? name;
  String? description;
  int? weight;
  int? width;
  int? length;
  int? height;
  String? image;
  int? harga;

  @JsonKey(name: '_id', includeToJson: false)
  final String? id;

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);

  Map<String, dynamic> toJson() => _$ProductToJson(this);
}
