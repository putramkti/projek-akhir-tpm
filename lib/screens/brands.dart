import 'package:flutter/material.dart';
import 'package:projek_akhir_tpm/models/data_brands.dart';
import 'package:projek_akhir_tpm/screens/brands.dart';
import 'package:projek_akhir_tpm/screens/detail_brand.dart';
import 'package:projek_akhir_tpm/screens/detail_hp.dart';
import 'package:projek_akhir_tpm/screens/favorites.dart';
import 'package:projek_akhir_tpm/screens/home.dart';
import 'package:projek_akhir_tpm/services/api_data_source.dart';

class BrandsPage extends StatefulWidget {
  const BrandsPage({super.key});

  @override
  State<BrandsPage> createState() => _BrandsPageState();
}

class _BrandsPageState extends State<BrandsPage> {
  int _selectedIndex = 0;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Brands")),
      body: Container(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: _buildListPhoneBody(),
        ),
      ),
    );
  }

  Widget _buildListPhoneBody() {
    return Container(
      child: FutureBuilder(
          future: ApiDataSource.instance.loadBrands(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasError) {
              return _buildErrorSection();
            }
            if (snapshot.hasData) {
              DataBrands dataBrands = DataBrands.fromJson(snapshot.data);
              return _buildSuccessSection(dataBrands);
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

  Widget _buildSuccessSection(DataBrands data) {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        return _buildItemPhone(data.data![index]);
      },
      itemCount: data.data!.length,
    );
  }

  Widget _buildItemPhone(Data data) {
    // String imageUrl = hp.image!.replaceFirst('http://', 'https://');
    return InkWell(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DetailBrandPage(
                    slugBrand: data.brandSlug!,
                  ))),
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(4.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${data.brandName}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                '${data.deviceCount.toString()} devices',
                // style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
