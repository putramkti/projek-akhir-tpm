import 'package:hive/hive.dart';

part 'favorit_hp.g.dart';

@HiveType(typeId: 1)
class FavoritHp extends HiveObject {
  @HiveField(0)
  String email;

  @HiveField(1)
  String slug;

  FavoritHp(this.email, this.slug);
}
