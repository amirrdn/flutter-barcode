import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login.dart';
import 'profile.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();

  var isLoggedIn =
      (prefs.getString('token') == null) ? false : prefs.getString('token');

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Sekai Mobile App',
    home: isLoggedIn == false ? const LoginPage() : const ProfilePage(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sekai Mobile App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: LoginPage(),
    );
  }
}

class WebAdminPage extends StatelessWidget {
  const WebAdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Laporan Data Scan Barang')),
      body: DataTable(
        columns: [
          DataColumn(label: Text('Nama Toko')),
          DataColumn(label: Text('Nama Barang')),
          DataColumn(label: Text('Serial Number')),
        ],
        rows: [
          DataRow(cells: [
            DataCell(Text('Toko ABC')),
            DataCell(Text('Barang 123')),
            DataCell(Text('SN123456')),
          ]),
          DataRow(cells: [
            DataCell(Text('Toko XYZ')),
            DataCell(Text('Barang 456')),
            DataCell(Text('SN789012')),
          ]),
        ],
      ),
    );
  }
}
