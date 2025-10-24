import 'package:shared_preferences/shared_preferences.dart';

class FavoritesService {
  static const String _favoritesKey = 'favorites_list';
  final SharedPreferences _prefs;

  FavoritesService(this._prefs);

  Future<Set<int>> getFavorites() async {
    final favoritesString = _prefs.getStringList(_favoritesKey) ?? [];
    return favoritesString.map((id) => int.parse(id)).toSet();
  }

  Future<bool> addToFavorites(int productId) async {
    final favorites = await getFavorites();
    favorites.add(productId);
    return _prefs.setStringList(
      _favoritesKey,
      favorites.map((id) => id.toString()).toList(),
    );
  }

  Future<bool> removeFromFavorites(int productId) async {
    final favorites = await getFavorites();
    favorites.remove(productId);
    return _prefs.setStringList(
      _favoritesKey,
      favorites.map((id) => id.toString()).toList(),
    );
  }

  Future<bool> isFavorite(int productId) async {
    final favorites = await getFavorites();
    return favorites.contains(productId);
  }

  Future<bool> toggleFavorite(int productId) async {
    final isFav = await isFavorite(productId);
    if (isFav) {
      return await removeFromFavorites(productId);
    } else {
      return await addToFavorites(productId);
    }
  }
}
