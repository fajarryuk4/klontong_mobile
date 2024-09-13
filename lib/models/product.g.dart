// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Product _$ProductFromJson(Map<String, dynamic> json) => Product(
      productId: (json['product_id'] as num?)?.toInt(),
      categoryId: (json['CategoryId'] as num?)?.toInt(),
      categoryName: json['categoryName'] as String?,
      sku: json['sku'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      weight: (json['weight'] as num?)?.toInt(),
      width: (json['width'] as num?)?.toInt(),
      length: (json['length'] as num?)?.toInt(),
      height: (json['height'] as num?)?.toInt(),
      image: json['image'] as String?,
      harga: (json['harga'] as num?)?.toInt(),
      id: json['_id'] as String?,
    );

Map<String, dynamic> _$ProductToJson(Product instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('CategoryId', instance.categoryId);
  writeNotNull('categoryName', instance.categoryName);
  writeNotNull('sku', instance.sku);
  writeNotNull('name', instance.name);
  writeNotNull('description', instance.description);
  writeNotNull('weight', instance.weight);
  writeNotNull('width', instance.width);
  writeNotNull('length', instance.length);
  writeNotNull('height', instance.height);
  writeNotNull('image', instance.image);
  writeNotNull('harga', instance.harga);
  return val;
}
