import 'package:flutter/material.dart';
import 'package:projek_akhir_tpm/models/data_hp.dart';
import 'package:projek_akhir_tpm/screens/bottomnavbar.dart';
import 'package:projek_akhir_tpm/screens/brands.dart';
import 'package:projek_akhir_tpm/screens/detail_hp.dart';
import 'package:projek_akhir_tpm/screens/favorites.dart';
import 'package:projek_akhir_tpm/screens/user.dart';
import 'package:projek_akhir_tpm/services/api_data_source.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
        // flexibleSpace: Center(
        //   child: Image.asset(
        //     "assets/logo.png",
        //     fit: BoxFit.contain,
        //     height: 40, // Sesuaikan dengan tinggi yang diinginkan
        //   ),
        // ),
      ),
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
          future: ApiDataSource.instance.loadHP(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasError) {
              return _buildErrorSection();
            }
            if (snapshot.hasData) {
              DataHP dataHP = DataHP.fromJson(snapshot.data);
              return _buildSuccessSection(dataHP);
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

  Widget _buildSuccessSection(DataHP data) {
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
