import 'base_network.dart';

class ApiDataSource {
  static ApiDataSource instance = ApiDataSource();

  Future<Map<String, dynamic>> loadHP() {
    return BaseNetwork.get('latest');
  }

  Future<Map<String, dynamic>> loadHPByInterest() {
    return BaseNetwork.get('top-by-interest');
  }

  Future<Map<String, dynamic>> loadHPByFans() {
    return BaseNetwork.get('top-by-fans');
  }

  Future<Map<String, dynamic>> searchHP(String hp) {
    return BaseNetwork.get('top-by-fans/${hp}');
  }

  Future<Map<String, dynamic>> loadDetailHP(String slugHP) {
    return BaseNetwork.get(slugHP);
  }

  Future<Map<String, dynamic>> loadBrands() {
    return BaseNetwork.get('brands');
  }

  Future<Map<String, dynamic>> loaddetailBrand(String slugBrand) {
    return BaseNetwork.get('brands/${slugBrand}');
  }
}
