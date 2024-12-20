import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api_service.dart';
import 'models/filesmode.dart';

class InformasiToko extends StatefulWidget {
  const InformasiToko({super.key});

  @override
  State<InformasiToko> createState() => _InformasiTokoState();
}

class _InformasiTokoState extends State<InformasiToko>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Map<String, dynamic>? user;
  late TextEditingController storeNameController;
  late TextEditingController storeTypeController;
  late TextEditingController idCardNumberController;
  late TextEditingController ownerController;
  late TextEditingController addressController;
  late TextEditingController postallCodeController;
  late TextEditingController locationStoreController;
  late TextEditingController phoneNumberController;
  List<dynamic> files = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    storeNameController = TextEditingController();
    storeTypeController = TextEditingController();
    idCardNumberController = TextEditingController();
    ownerController = TextEditingController();
    addressController = TextEditingController();
    postallCodeController = TextEditingController();
    locationStoreController = TextEditingController();
    phoneNumberController = TextEditingController();

    _loadUser();
  }

  Future<void> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString('user');
    if (userData != null) {
      setState(() {
        user = jsonDecode(userData);
        storeNameController.text = user?['store']?['store_name'] ?? '';
        storeTypeController.text = user?['store']?['type']?['name'] ?? '';
        idCardNumberController.text = user?['store']?['id_card_number'] ?? '';
        ownerController.text = user?['store']?['owner'] ?? '';
        addressController.text = user?['store']?['address'] ?? '';
        postallCodeController.text = user?['store']?['postal_code'] ?? '';
        locationStoreController.text = user?['store']?['location_store'] ?? '';
        phoneNumberController.text = user?['store']?['phone_number'] ?? '';
        final storeJson = user?['store'];
        final filesJson = storeJson?['files'];
        if (filesJson != null) {
          files = (filesJson as List<dynamic>)
              .map((file) => MFiles.fromJson(file))
              .toList();
        }
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    storeNameController.dispose();
    storeTypeController.dispose();
    idCardNumberController.dispose();
    ownerController.dispose();
    addressController.dispose();
    postallCodeController.dispose();
    locationStoreController.dispose();
    phoneNumberController.dispose();
    super.dispose();
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
                child: Stack(
                  children: [
                    Positioned(
                      left: 0,
                      top: 6.0,
                      child: IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    Padding(
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
                    )
                  ],
                ),
              ),
            ],
          ),
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              indicatorColor: Color(0xFF0072FF),
              labelColor: Color(0xFF0072FF),
              unselectedLabelColor: Colors.grey,
              tabs: [
                Tab(text: 'Informasi Toko'),
                Tab(text: 'Foto Toko'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                ListView(
                  padding: EdgeInsets.all(16),
                  children: [
                    Container(
                        height: 60,
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.only(
                            top: 20.0, left: 0.0, right: 0.0, bottom: 30.0),
                        child: TextFormField(
                            controller: storeNameController,
                            readOnly: true,
                            decoration: InputDecoration(
                              labelText: 'Nama Toko',
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Colors.black26,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Colors.black26,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ))),
                    Container(
                        height: 60,
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.only(
                            top: 0.0, left: 0.0, right: 0.0, bottom: 30.0),
                        child: TextFormField(
                            controller: storeTypeController,
                            readOnly: true,
                            decoration: InputDecoration(
                              labelText: 'Jenis Toko',
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Colors.black26,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Colors.black26,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ))),
                    Container(
                        height: 60,
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.only(
                            top: 0.0, left: 0.0, right: 0.0, bottom: 30.0),
                        child: TextFormField(
                            controller: idCardNumberController,
                            readOnly: true,
                            decoration: InputDecoration(
                                labelText: 'No KTP',
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Colors.black26,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Colors.black26,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                )))),
                    Container(
                        height: 60,
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.only(
                            top: 0.0, left: 0.0, right: 0.0, bottom: 30.0),
                        child: TextFormField(
                            controller: ownerController,
                            readOnly: true,
                            decoration: InputDecoration(
                                labelText: 'Nama Pemilik',
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Colors.black26,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Colors.black26,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                )))),
                    Container(
                      height: 60,
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.only(
                          top: 0.0, left: 0.0, right: 0.0, bottom: 30.0),
                      child: TextFormField(
                          controller: addressController,
                          readOnly: true,
                          decoration: InputDecoration(
                            hintText: 'Masukan Alamat Toko',
                            labelText: 'Alamat Toko',
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.black26,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          )),
                    ),
                    Container(
                        height: 60,
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.only(
                            top: 0.0, left: 0.0, right: 0.0, bottom: 30.0),
                        child: TextFormField(
                            controller: postallCodeController,
                            readOnly: true,
                            decoration: InputDecoration(
                                labelText: 'Kode Pos',
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Colors.black26,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Colors.black26,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                )))),
                    Container(
                        height: 60,
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.only(
                            top: 0.0, left: 0.0, right: 0.0, bottom: 30.0),
                        child: TextFormField(
                            controller: locationStoreController,
                            readOnly: true,
                            decoration: InputDecoration(
                                labelText: 'Lokasi Toko',
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Colors.black26,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Colors.black26,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                )))),
                    Container(
                        height: 60,
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.only(
                            top: 0.0, left: 0.0, right: 0.0, bottom: 30.0),
                        child: TextFormField(
                            controller: phoneNumberController,
                            readOnly: true,
                            decoration: InputDecoration(
                                labelText: 'No Telepon',
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Colors.black26,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Colors.black26,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                )))),
                  ],
                ),
                ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: files.length,
                  itemBuilder: (context, index) {
                    final file = files[index];
                    var urlimg = '${ApiService.baseUrlImg}/${file.file_path}';
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        leading: Image.network(
                          urlimg,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Icon(Icons.broken_image),
                        ),
                        title: Text(file.file_name ?? 'Unknown File',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(file.description ?? '-'),
                      ),
                    );
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
