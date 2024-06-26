import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:projek_akhir_tpm/models/data_detail_hp.dart';
import 'package:projek_akhir_tpm/models/favorit_hp.dart';
import 'package:projek_akhir_tpm/services/api_data_source.dart';
import 'package:projek_akhir_tpm/services/favorit_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailHpPage extends StatefulWidget {
  final String slug;
  const DetailHpPage({required this.slug});

  @override
  State<DetailHpPage> createState() => _DetailHpPageState(slug: slug);
}

class _DetailHpPageState extends State<DetailHpPage> {
  final String slug;
  final _favoriteService = FavoriteService();
  late Future<List<FavoritHp>> _favoritesFuture;
  late String _userEmail;

  _DetailHpPageState({required this.slug}) {
    _favoritesFuture = _favoriteService.getFavorites();
  }

  Future<void> _toggleFavorite() async {
    final favorites = await _favoritesFuture;
    if (favorites == null) {
      await _favoriteService.addToFavorites(_userEmail, slug);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Added to favorites')),
      );
    }
    final isFavorite = favorites.any(
            (favorite) => favorite.slug == slug && favorite.email == _userEmail);

    if (isFavorite) {
      // Remove from favorites
      final indexToRemove = favorites.indexWhere(
              (favorite) => favorite.slug == slug && favorite.email == _userEmail);
      await _favoriteService.removeFromFavorites(indexToRemove);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Removed from favorites')),
      );
    } else {
      // Add to favorites
      await _favoriteService.addToFavorites(_userEmail, slug);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Added to favorites')),
      );
    }

    setState(() {
      _favoritesFuture = _favoriteService.getFavorites();
    });
  }

  Future<void> _removeFavorite(String slug) async {
    final favorites = await _favoritesFuture;
    final indexToRemove = favorites.indexWhere(
            (favorite) => favorite.slug == slug && favorite.email == _userEmail);
    if (indexToRemove != -1) {
      await _favoriteService.removeFromFavorites(indexToRemove);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Removed from favorites')),
      );
      setState(() {
        _favoritesFuture = _favoriteService.getFavorites();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getUserEmail();
  }

  Future<void> _getUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _userEmail = prefs.getString('email') ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detail Page"),
        actions: [
          IconButton(
            onPressed: _toggleFavorite,
            icon: FutureBuilder<List<FavoritHp>>(
              future: _favoritesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Icon(Icons.favorite_border);
                } else if (snapshot.data != null) {
                  final isFavorite = snapshot.data!.any((favorite) =>
                  favorite.slug == slug && favorite.email == _userEmail);
                  return Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : null,
                  );
                } else {
                  // Jika snapshot.data bernilai null, tampilkan ikon default
                  return Icon(Icons.favorite_border);
                }
              },
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: _buildListPhoneBody(),
      ),
    );
  }

  Widget _buildListPhoneBody() {
    return FutureBuilder(
        future: ApiDataSource.instance.loadDetailHP(slug),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasError) {
            return _buildErrorSection();
          }
          if (snapshot.hasData) {
            DataDetailHP dataDetailHP = DataDetailHP.fromJson(snapshot.data);
            return _buildSuccessSection(dataDetailHP);
          }
          return _buildLoadingSection();
        });
  }

  Widget _buildErrorSection() {
    return Text("Error");
  }

  Widget _buildLoadingSection() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildSpecificationSection(String title, List<Specification> specifications) {
    final specification = specifications.firstWhere((spec) => spec.title == title, orElse: () => Specification(title: '', specs: []));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
            ),
          ),
        ),
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              for (final spec in specification.specs ?? [])
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    if (spec.key != null)
                      Text(
                        spec.key!,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    SizedBox(height: 4.0),
                    if (spec.val != null)
                      ...spec.val!.map((value) => Text(value ?? "")).toList(),
                    SizedBox(height: 8.0),
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSuccessSection(DataDetailHP datahp) {
    Data dataHP = datahp.data!;
    final List<String> listImg = dataHP.phoneImages ?? [];

    final CarouselOptions options = CarouselOptions(
      aspectRatio: 16 / 9,
      viewportFraction: 0.9,
      autoPlay: true,
      autoPlayInterval: Duration(seconds: 2),
      autoPlayAnimationDuration: Duration(milliseconds: 800),
      autoPlayCurve: Curves.fastOutSlowIn,
      enlargeCenterPage: true,
      enableInfiniteScroll: false,
    );

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CarouselSlider(
            options: options,
            items: listImg.map((item) => Image.network(item)).toList(),
          ),
          SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${dataHP.brand!} ${dataHP.phoneName!}",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                Text(
                  "Release Date : ${dataHP.releaseDate}",
                ),
                Text(
                  "Operating System : ${dataHP.os}",
                ),
                Text(
                  "Storage : ${dataHP.storage}",
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(
                          "assets/ic_kamera.png",
                          width: 50,
                        ),
                        SizedBox(height: 15.0),
                        _buildSpecificationSection(
                            "Main Camera", dataHP.specifications ?? []),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(
                          "assets/ic_kamera_depan.png",
                          width: 50,
                        ),
                        SizedBox(height: 15.0),
                        _buildSpecificationSection(
                            "Selfie camera", dataHP.specifications ?? []),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(
                          "assets/ic_layar.png",
                          width: 50,
                        ),
                        SizedBox(height: 15.0),
                        _buildSpecificationSection(
                            "Display", dataHP.specifications ?? []),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(
                          "assets/ic_prossecor.png",
                          width: 50,
                        ),
                        SizedBox(height: 15.0),
                        _buildSpecificationSection(
                            "Platform", dataHP.specifications ?? []),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
