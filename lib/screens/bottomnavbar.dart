import 'package:flutter/material.dart';
import 'package:projek_akhir_tpm/screens/brands.dart';
import 'package:projek_akhir_tpm/screens/favorites.dart';
import 'package:projek_akhir_tpm/screens/home.dart';
import 'package:projek_akhir_tpm/screens/user.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectIndex = 0;

  void _navigatorBottomNavBar(int index) {
    setState(() {
      _selectIndex = index;
    });
  }

  final List<Widget> _children = [
    HomePage(),
    BrandsPage(),
    FavoritesPage(),
    UserPage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_selectIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectIndex,
        onTap: _navigatorBottomNavBar,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Brands'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorit'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
        ],
      ),
    );
  }
}
