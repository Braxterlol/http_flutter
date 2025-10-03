import 'package:get_it/get_it.dart';
import 'core/network/http_client.dart'; 
import 'features/products/data/datasources/product_remote_datasource.dart';
import 'features/products/data/repositories/product_repository_impl.dart';
import 'features/products/domain/repositories/product_repository.dart';
import 'features/products/domain/usecases/add_product.dart';
import 'features/products/domain/usecases/delete_product.dart';
import 'features/products/domain/usecases/get_products.dart';
import 'features/products/presentation/providers/products_provider.dart'; 

final sl = GetIt.instance;

Future<void> init() async {

  sl.registerFactory(() => ProductsProvider(
        getProductsUseCase: sl(),
        addProductUseCase: sl(),
        deleteProductUseCase: sl(),
      ));

  // Use Cases
  sl.registerLazySingleton(() => GetProducts(sl()));
  sl.registerLazySingleton(() => AddProduct(sl()));
  sl.registerLazySingleton(() => DeleteProduct(sl()));

  // Repository
  sl.registerLazySingleton<ProductRepository>(
      () => ProductRepositoryImpl(remoteDataSource: sl()));

  // Data Sources
  sl.registerLazySingleton<ProductRemoteDataSource>(
      () => ProductRemoteDataSourceImpl(client: sl<HttpClient>().client));
  // --- Core ---
  // (Aquí registraríamos NetworkInfo, etc. si lo tuviéramos)

  // --- External ---
sl.registerLazySingleton(() => HttpClient());
}