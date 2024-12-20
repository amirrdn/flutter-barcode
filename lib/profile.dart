import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Login.dart';
import 'changepasswrod.dart';
import 'qrcode.dart';
import 'toko.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? user;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString('user');
    if (userData != null) {
      setState(() {
        user = jsonDecode(userData);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                height: 120,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF0072FF), Color(0xFF2D7EB0)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: EdgeInsets.only(top: 20.0),
                  child: Center(
                    child: Text(
                      'My Profile',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.grey[200],
            child: Center(
              child: Text(
                (user?['name'] != null && user!['name'].toString().length >= 2
                    ? user!['name'].toString().toUpperCase().substring(0, 2)
                    : 'U'),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 12.0,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 3,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Informasi Akun",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 10),
                    DetailRow(
                      title: 'Nama',
                      value: user?['name'] ?? '-',
                    ),
                    SizedBox(height: 8),
                    DetailRow(
                      title: 'Email',
                      value: user?['email'] ?? '-',
                    ),
                    SizedBox(height: 8),
                    DetailRow(
                      title: 'Nomor Telepon',
                      value: user?['phone_number'] ?? '-',
                    ),
                  ],
                ),
              ),
            ),
          ),
          Divider(color: Colors.white),
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  leading: Icon(Icons.store, color: Colors.blue),
                  title: Text('Informasi Toko'),
                  trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => InformasiToko()),
                    );
                  },
                ),
                Divider(color: Colors.grey.shade300),
                ListTile(
                  leading: Icon(Icons.lock, color: Colors.blue),
                  title: Text('Change Password'),
                  trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChangePasswordPage()),
                    );
                  },
                ),
                Divider(color: Colors.grey.shade300),
                ListTile(
                  leading: Icon(Icons.logout, color: Colors.red),
                  title: Text('Logout'),
                  trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey),
                  onTap: () {
                    _logout();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(Icons.home, color: Colors.grey),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.shopping_bag, color: Colors.grey),
              onPressed: () {},
            ),
            SizedBox(width: 40),
            IconButton(
              icon: Icon(Icons.phone, color: Colors.grey),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.store, color: Colors.grey),
              onPressed: () {},
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        child: Icon(Icons.qr_code_scanner, color: Colors.white),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => QRScanPage()),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user');
    await prefs.remove('token');

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }
}

class DetailRow extends StatelessWidget {
  final String title;
  final String value;

  const DetailRow({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$title:',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
            ),
          ),
        ),
      ],
    );
  }
}
