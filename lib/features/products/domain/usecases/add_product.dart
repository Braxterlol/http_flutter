import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/product_entity.dart';
import '../repositories/product_repository.dart';

class AddProduct {
  final ProductRepository repository;

  AddProduct(this.repository);

  Future<Either<Failure, ProductEntity>> call(ProductEntity product) async {
    return await repository.addProduct(product);
  }
}