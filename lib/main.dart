import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/network/http_client.dart';
import 'core/utils/app_theme.dart';
import 'features/products/presentation/pages/products_page.dart';
import 'features/products/presentation/providers/products_provider.dart';
import 'injection.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

// Convierte MyApp en un StatefulWidget
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void dispose() {
    // Llama al dispose de tu HttpClient aquí
    di.sl<HttpClient>().dispose();
    print("HttpClient disposed!"); // Para confirmar en la consola
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => di.sl<ProductsProvider>(),
      child: MaterialApp(
        title: 'Product Manager',
        theme: AppTheme.lightTheme,
        home: const ProductsPage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}