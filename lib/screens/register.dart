import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:projek_akhir_tpm/models/user.dart';

import 'login.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _emailError;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nama',
                  contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32.0)),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Nama tidak boleh kosong';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
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
                  if (!value.contains("@")) {
                    return 'Email tidak valid';
                  }
                  if (_emailError != null) {
                    return _emailError;
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
                    // Validasi berhasil, lanjutkan proses register
                    String name = _nameController.text;
                    String email = _emailController.text;
                    String password = _passwordController.text;

                    // Simpan data user ke Hive
                    var user =
                        User(name: name, email: email, password: password);
                    var box = await Hive.openBox<User>('userBox');

                    var existingUsers = box.values.toList();
                    print('Isi UserBox: ${box.values.toList()}');
                    var existingUser = existingUsers
                        .firstWhereOrNull((user) => user.email == email);
                    if (existingUser != null) {
                      setState(() {
                        _emailError = 'Email sudah terdaftar';
                      });
                      return; // Hentikan proses registrasi
                    }

                    await box.add(user);

                    // Tampilkan pesan sukses
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Registrasi berhasil')),
                    );

                    // Kosongkan field setelah registrasi berhasil
                    _nameController.clear();
                    _emailController.clear();
                    _passwordController.clear();

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  }
                },
                child: Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
