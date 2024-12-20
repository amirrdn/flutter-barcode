import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'package:sakaiapp/api_service.dart';
import 'package:sakaiapp/login.dart';

class RegisterStore extends StatefulWidget {
  const RegisterStore({super.key});

  @override
  State<RegisterStore> createState() => _RegisterStoreState();
}

class _RegisterStoreState extends State<RegisterStore>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late TextEditingController storeNameController;
  late TextEditingController storeTypeController;
  late TextEditingController idCardNumberController;
  late TextEditingController ownerController;
  late TextEditingController addressController;
  late TextEditingController postalCodeController;
  late TextEditingController locationStoreController;
  late TextEditingController phoneNumberController;
  late TextEditingController emailController;
  final _formKey = GlobalKey<FormState>();

  List<File> _selectedImages = [];
  List<Map<String, dynamic>> _storeTypes = [];
  String? _selectedStoreTypeId;
  bool _isLoading = false;
  List<TextEditingController> _imageDescriptions = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    storeNameController = TextEditingController();
    storeTypeController = TextEditingController();
    idCardNumberController = TextEditingController();
    ownerController = TextEditingController();
    addressController = TextEditingController();
    postalCodeController = TextEditingController();
    locationStoreController = TextEditingController();
    phoneNumberController = TextEditingController();
    emailController = TextEditingController();
    _fetchStoreTypes();
  }

  Future<void> _fetchStoreTypes() async {
    var url = '${ApiService.baseUrl}/type-store';
    final uri = Uri.parse(url);
    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        if (!mounted) return;
        setState(() {
          _storeTypes = data
              .map((type) => {'id': type['id'], 'name': type['name']})
              .toList();
        });
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text("Failed to load store types: ${response.statusCode}")),
        );
      }
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching store types: $error")),
      );
    }
  }

  Future<void> _pickImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile>? pickedFiles = await picker.pickMultiImage();

    if (pickedFiles != null) {
      setState(() {
        _selectedImages = pickedFiles.map((file) => File(file.path)).toList();
        _imageDescriptions = List.generate(
          _selectedImages.length,
          (index) => TextEditingController(),
        );
      });
    }
  }

  Future<void> _submitData() async {
    if (_formKey.currentState?.validate() ?? false) {
      var url = '${ApiService.baseUrl}/register';
      final uri = Uri.parse(url);
      final request = http.MultipartRequest("POST", uri);

      request.fields['store_name'] = storeNameController.text;
      request.fields['type_id'] = _selectedStoreTypeId ?? '';
      request.fields['id_card_number'] = idCardNumberController.text;
      request.fields['owner'] = ownerController.text;
      request.fields['address'] = addressController.text;
      request.fields['postal_code'] = postalCodeController.text;
      request.fields['location_store'] = locationStoreController.text;
      request.fields['phone_number'] = phoneNumberController.text;
      request.fields['email'] = emailController.text;

      for (int i = 0; i < _selectedImages.length; i++) {
        final image = _selectedImages[i];
        final description = _imageDescriptions[i].text;
        final fileName = image.path.split('/').last;
        final mimeType = lookupMimeType(image.path);

        final file = await http.MultipartFile.fromPath(
          'files[$i]',
          image.path,
          filename: fileName,
          contentType: MediaType.parse(mimeType ?? 'application/octet-stream'),
        );
        request.files.add(file);

        request.fields['descriptions[$i]'] = description;
      }

      setState(() {
        _isLoading = true;
      });

      try {
        final response = await request.send();

        if (response.statusCode == 200) {
          final responseBody = await response.stream.bytesToString();
          jsonDecode(responseBody);

          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Data berhasil disimpan!")),
          );
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LoginPage(),
            ),
          );
        } else {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text("Gagal menyimpan data: ${response.statusCode}")),
          );
        }
      } catch (error) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Terjadi kesalahan: $error")),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lengkapi data")),
      );
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
    postalCodeController.dispose();
    locationStoreController.dispose();
    phoneNumberController.dispose();
    emailController.dispose();
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
                          'Register Store',
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
                    Form(
                        key: _formKey,
                        child: Column(children: [
                          TextFormField(
                            controller: storeNameController,
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
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Isi nama toko!';
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          DropdownButtonFormField<String>(
                              value: _selectedStoreTypeId,
                              items: _storeTypes.map((type) {
                                return DropdownMenuItem(
                                  value: type['id'].toString(),
                                  child: Text(type['name']),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedStoreTypeId = value;
                                });
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Pilih tipe toko!';
                                }
                                return null;
                              },
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
                              )),
                          SizedBox(
                            height: 20.0,
                          ),
                          TextFormField(
                            controller: idCardNumberController,
                            decoration: InputDecoration(
                              labelText: 'No. KTP',
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
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Isi no. KTP';
                              }
                              if (value.length != 16) {
                                return 'Nomor KTP harus 16 digit';
                              }
                              if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                                return 'Nomor KTP hanya boleh berisi angka';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.number,
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          TextFormField(
                            controller: ownerController,
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
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Isi nama pemilik!';
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          TextField(
                              controller: addressController,
                              decoration: InputDecoration(
                                labelText: 'Alamat',
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
                              )),
                          SizedBox(
                            height: 20.0,
                          ),
                          TextField(
                              controller: postalCodeController,
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
                                ),
                              )),
                          SizedBox(
                            height: 20.0,
                          ),
                          TextFormField(
                            controller: locationStoreController,
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
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Isi lokasi toko';
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          TextFormField(
                            controller: emailController,
                            decoration: InputDecoration(
                              labelText: 'Email',
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
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Email tidak boleh kosong';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.emailAddress,
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          TextFormField(
                            controller: phoneNumberController,
                            decoration: InputDecoration(
                              labelText: 'No. HP',
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
                            ),
                            keyboardType: TextInputType.phone,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Nomor Handphone tidak boleh kosong';
                              }
                              if (value.length < 10 || value.length > 13) {
                                return 'Nomor telepon harus antara 10 hingga 13 digit';
                              }
                              return null;
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 12.0),
                            child: Text(
                              'Password default adalah no HP, bisa digunakan setelah akun disetujui.',
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                        ]))
                  ],
                ),
                Column(
                  children: [
                    Padding(
                        padding: EdgeInsets.all(19),
                        child: ElevatedButton.icon(
                          onPressed: _pickImages,
                          icon: Icon(Icons.add_a_photo),
                          label: Text("Upload Gambar"),
                        )),
                    SizedBox(height: 20),
                    if (_selectedImages.isNotEmpty)
                      Expanded(
                        child: ListView.builder(
                          itemCount: _selectedImages.length,
                          itemBuilder: (context, index) {
                            return Card(
                              margin: EdgeInsets.symmetric(vertical: 8),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Image.file(
                                      _selectedImages[index],
                                      fit: BoxFit.cover,
                                      height: 150,
                                      width: double.infinity,
                                    ),
                                    SizedBox(height: 8),
                                    TextField(
                                      controller: _imageDescriptions[index],
                                      decoration: InputDecoration(
                                        labelText: "Keterangan Foto",
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(9.0),
              child: _isLoading
                  ? CircularProgressIndicator()
                  : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _submitData,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF00B2E9),
                          disabledBackgroundColor:
                              Color.fromARGB(255, 135, 211, 235),
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          "Kirim Data",
                          style: TextStyle(fontSize: 20.0, color: Colors.white),
                        ),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
