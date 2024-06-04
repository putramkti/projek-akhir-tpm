import 'package:flutter/material.dart';
import 'package:projek_akhir_tpm/models/data_detail_brands.dart';
import 'package:projek_akhir_tpm/screens/brands.dart';
import 'package:projek_akhir_tpm/screens/detail_hp.dart';
import 'package:projek_akhir_tpm/screens/favorites.dart';
import 'package:projek_akhir_tpm/screens/home.dart';
import 'package:projek_akhir_tpm/services/api_data_source.dart';

class DetailBrandPage extends StatefulWidget {
  final String slugBrand;
  const DetailBrandPage({super.key, required this.slugBrand});

  @override
  State<DetailBrandPage> createState() =>
      _DetailBrandPageState(slugBrand: slugBrand);
}

class _DetailBrandPageState extends State<DetailBrandPage> {
  final String slugBrand;
  _DetailBrandPageState({required this.slugBrand});

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
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(builder: (context) => ProfilePage()),
      // );
      // break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("List Phone")),
      body: Container(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: _buildListPhoneBody(),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.grey),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.branding_watermark, color: Colors.blue),
            label: 'Brands',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark, color: Colors.grey),
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

  Widget _buildListPhoneBody() {
    return Container(
      child: FutureBuilder(
          future: ApiDataSource.instance.loaddetailBrand(slugBrand),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasError) {
              return _buildErrorSection();
            }
            if (snapshot.hasData) {
              DataDetailBrand dataDetailBrand =
                  DataDetailBrand.fromJson(snapshot.data);
              return _buildSuccessSection(dataDetailBrand);
            }
            return _buildLoadingSection();
          }),
    );
  }

  Widget _buildErrorSection() {
    return Text("Error");
  }

  Widget _buildLoadingSection() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildSuccessSection(DataDetailBrand data) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10.0,
        crossAxisSpacing: 10.0,
      ),
      itemCount: data.data!.phones!.length,
      itemBuilder: (BuildContext context, int index) {
        return _buildItemPhone(data.data!.phones![index]);
      },
    );
  }

  Widget _buildItemPhone(Phone hp) {
    // String imageUrl = hp.image!.replaceFirst('http://', 'https://');
    return InkWell(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DetailHpPage(slug: hp.slug!))),
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(4.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(
                hp.image!,
                width: 90,
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          hp.phoneName!,
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                          maxLines: 2, // Batasi maksimal 2 baris
                          overflow: TextOverflow
                              .ellipsis, // Tampilkan elipsis jika teks terlalu panjang
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
