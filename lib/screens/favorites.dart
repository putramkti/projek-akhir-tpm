import 'package:flutter/material.dart';
import 'package:projek_akhir_tpm/models/data_detail_hp.dart';
import 'package:projek_akhir_tpm/models/favorit_hp.dart';
import 'package:projek_akhir_tpm/screens/brands.dart';
import 'package:projek_akhir_tpm/screens/detail_hp.dart';
import 'package:projek_akhir_tpm/screens/home.dart';
import 'package:projek_akhir_tpm/screens/user.dart';
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

  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => BrandsPage()),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => FavoritesPage()),
        );
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => UserPage()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Favorites")),
      body: _buildFavoritesList(),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.grey),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.branding_watermark, color: Colors.grey),
            label: 'Brands',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark, color: Colors.blue),
            label: 'Bookmarks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, color: Colors.grey),
            label: 'Profile',
          ),
        ],
        showUnselectedLabels: true,
        showSelectedLabels: true,
        onTap: _onItemTapped,
      ),
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
              return _buildFavoriteItem(snapshot.data![index]);
            },
          );
        }
      },
    );
  }

  Widget _buildFavoriteItem(FavoritHp favorite) {
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
          // Tampilkan hanya gambar HP dan namanya saja
          return ListTile(
            leading: Image.network(data.thumbnail ?? ''),
            title: Text(data.phoneName ?? ''),
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
}
