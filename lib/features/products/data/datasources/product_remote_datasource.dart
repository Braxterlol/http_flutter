import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/error/exceptions.dart';
import '../models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getProducts();
  Future<ProductModel> addProduct(ProductModel product);
  Future<void> deleteProduct(int id);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final http.Client client;
  final String _baseUrl = 'https://dummyjson.com/products';

  ProductRemoteDataSourceImpl({required this.client});

  @override
  Future<List<ProductModel>> getProducts() async {
    final response = await client.get(Uri.parse('$_baseUrl?limit=10'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['products'] as List)
          .map((item) => ProductModel.fromJson(item))
          .toList();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<ProductModel> addProduct(ProductModel product) async {
    final response = await client.post(
      Uri.parse('$_baseUrl/add'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'title': product.title, 'description': product.description}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return ProductModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }

  @override
  Future<void> deleteProduct(int id) async {
    final response = await client.delete(Uri.parse('$_baseUrl/$id'));

    if (response.statusCode != 200) {
      throw ServerException();
    }
 
  }
}