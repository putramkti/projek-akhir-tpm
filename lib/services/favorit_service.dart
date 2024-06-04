import 'package:hive/hive.dart';
import 'package:projek_akhir_tpm/models/favorit_hp.dart';

class FavoriteService {
  static const _boxName = 'favoriteBox';

  Future<Box<FavoritHp>> _openBox() async {
    return await Hive.openBox<FavoritHp>(_boxName);
  }

  Future<void> addToFavorites(String email, String slug) async {
    final box = await _openBox();
    await box.add(FavoritHp(email, slug));
  }

  Future<void> removeFromFavorites(int index) async {
    final box = await _openBox();
    await box.deleteAt(index);
  }

  Future<List<FavoritHp>> getFavorites() async {
    final box = await _openBox();
    return box.values.toList();
  }
}
