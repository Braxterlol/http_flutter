import 'package:flutter/material.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/usecases/get_products.dart';
import '../../domain/usecases/add_product.dart';
import '../../domain/usecases/delete_product.dart';
import '../../../../core/services/favorites_service.dart';


class ProductsProvider extends ChangeNotifier {
  final GetProducts getProductsUseCase;
  final AddProduct addProductUseCase;
  final DeleteProduct deleteProductUseCase;
  final FavoritesService favoritesService;

  ProductsProvider({
    required this.getProductsUseCase,
    required this.addProductUseCase,
    required this.deleteProductUseCase,
    required this.favoritesService,
  });

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<ProductEntity> _products = [];
  List<ProductEntity> get products => _products;

  String? _error;
  String? get error => _error;

  Future<void> fetchProducts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await getProductsUseCase();
    result.fold(
      (failure) {
        _error = 'Error al cargar los productos: ${failure.message}';
      },
      (productsList) async {
        final favorites = await favoritesService.getFavorites();
        _products = productsList.map((product) {
          return product.copyWith(isFavorite: favorites.contains(product.id));
        }).toList();
      },
    );

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> createProduct(String title, String description) async {
    final result = await addProductUseCase(ProductEntity(id: 0, title: title, description: description, price: 99.99, thumbnail: ''));
    
    bool success = false;
    result.fold(
      (failure) {
        _error = 'Error al crear el producto: ${failure.message}';
        success = false;
      },
      (newProduct) {
        _products.insert(0, newProduct);
        success = true;
      },
    );
    notifyListeners();
    return success;
  }

  Future<void> removeProduct(int productId) async {
    final result = await deleteProductUseCase(productId);
    result.fold(
        (failure) {
            _error = 'Error al eliminar el producto: ${failure.message}';
        }, 
        (_) {
            _products.removeWhere((p) => p.id == productId);
        }
    );
    notifyListeners();
  }

  Future<void> toggleFavorite(int productId) async {
    final productIndex = _products.indexWhere((p) => p.id == productId);
    if (productIndex != -1) {
      final product = _products[productIndex];
      _products[productIndex] = product.copyWith(isFavorite: !product.isFavorite);
      notifyListeners();

      await favoritesService.toggleFavorite(productId);
    }
  }

  List<ProductEntity> get favoriteProducts {
    return _products.where((product) => product.isFavorite).toList();
  }
}