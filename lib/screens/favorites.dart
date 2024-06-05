import 'package:flutter/material.dart';
import 'package:projek_akhir_tpm/models/data_detail_hp.dart';
import 'package:projek_akhir_tpm/models/favorit_hp.dart';
import 'package:projek_akhir_tpm/screens/detail_hp.dart';
import 'package:projek_akhir_tpm/services/api_data_source.dart';
import 'package:projek_akhir_tpm/services/favorit_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  final _favoriteService = FavoriteService();
  late String _userEmail;

  @override
  void initState() {
    super.initState();
    _getFavorites();
  }

  Future<List<FavoritHp>> _getFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _userEmail = prefs.getString('email') ?? '';
    return _favoriteService.getFavoritesByEmail(_userEmail);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Favorites")),
      body: _buildFavoritesList(),
    );
  }

  Widget _buildFavoritesList() {
    return FutureBuilder<List<FavoritHp>>(
      future: _getFavorites(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text("Error fetching favorites"));
        } else if (snapshot.data == null || snapshot.data!.isEmpty) {
          return const Center(child: Text("No favorites yet"));
        } else {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: _buildFavoriteItem(snapshot.data![index], index),
              );
            },
          );
        }
      },
    );
  }

  Widget _buildFavoriteItem(FavoritHp favorite, int index) {
    return FutureBuilder<DataDetailHP>(
      future: _fetchDetailHp(favorite.slug),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const ListTile(
            title: Text('Loading...'),
          );
        } else if (snapshot.hasError) {
          return ListTile(
            title: Text('Error loading detail'),
            subtitle: Text('Slug: ${favorite.slug}'),
          );
        } else if (snapshot.hasData) {
          DataDetailHP dataDetailHP = snapshot.data!;
          Data data = dataDetailHP.data!;
          return ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
            leading: Image.network(data.thumbnail ?? ''),
            title: Text(data.phoneName ?? ''),
            trailing: IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                _removeFavorite(index);
              },
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailHpPage(slug: favorite.slug),
                ),
              );
            },
          );
        } else {
          return const ListTile(
            title: Text('No data'),
          );
        }
      },
    );
  }

  Future<DataDetailHP> _fetchDetailHp(String slug) async {
    final result = await ApiDataSource.instance.loadDetailHP(slug);
    return DataDetailHP.fromJson(result);
  }

  void _removeFavorite(int index) {
    _favoriteService.removeFromFavorites(index);
    setState(() {});
  }
}
