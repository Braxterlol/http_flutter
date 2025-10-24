import '../../domain/entities/product_entity.dart';

class ProductModel extends ProductEntity {
  const ProductModel({
    required int id,
    required String title,
    required String description,
    required double price,
    required String thumbnail,
  }) : super(
            id: id,
            title: title,
            description: description,
            price: price,
            thumbnail: thumbnail);

factory ProductModel.fromJson(Map<String, dynamic> json) {
  return ProductModel(
    id: json['id'],
    title: json['title'] ?? 'No Title', 
    description: json['description'] ?? '', 
    
    price: (json['price'] as num?)?.toDouble() ?? 0.0,
    
    thumbnail: json['thumbnail'] ?? 'https://i.dummyjson.com/data/products/1/thumbnail.jpg',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'thumbnail': thumbnail,
    };
  }
}