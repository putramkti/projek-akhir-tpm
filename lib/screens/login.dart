import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:projek_akhir_tpm/models/user.dart';
import 'package:projek_akhir_tpm/screens/home.dart';
import 'package:projek_akhir_tpm/screens/register.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _emailError;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLogin = prefs.getBool("isLogin") ?? false;
    if (isLogin) {
      String? email = prefs.getString("email");
      // Baca data user dari Hive jika diperlukan
      var box = await Hive.openBox<User>('userBox');
      var user = box.values.firstWhereOrNull((user) => user.email == email);
      if (user != null) {
        // Arahkan ke halaman beranda jika pengguna sudah login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                "assets/logo.png",
                height: 200,
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  errorText: _emailError,
                  contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32.0)),
                ),
                onChanged: (_) {
                  setState(() {
                    _emailError = null; // Reset pesan kesalahan email
                  });
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Email tidak boleh kosong';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32.0)),
                ),
                obscureText: true,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Password tidak boleh kosong';
                  }
                  return null;
                },
              ),
              SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    // Validasi berhasil, lanjutkan proses login
                    String email = _emailController.text;
                    String password = _passwordController.text;

                    // Baca data user dari Hive
                    var box = await Hive.openBox<User>('userBox');
                    var userr = box.values;
                    var user =
                        userr.firstWhereOrNull((user) => user.email == email);

                    if (user != null && user.password == password) {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.setBool("isLogin", true);
                      prefs.setString("email", email);

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => HomePage()),
                      );

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Login berhasil')),
                      );
                    } else {
                      // Password salah atau email tidak terdaftar
                      setState(() {
                        _emailError = 'Email atau password salah';
                      });
                    }
                  }
                },
                child: Text('Login'),
              ),
              SizedBox(
                  height:
                      16.0), // Tambahkan jarak antara tombol Login dan teks atau tombol Register
              TextButton(
                onPressed: () {
                  // Navigasi ke halaman registrasi
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterPage()),
                  );
                },
                child: Text('Belum punya akun? Daftar disini'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
