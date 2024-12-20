import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'api_service.dart';
import 'models/transaction.dart';
import 'models/user.dart';
import 'profile.dart';

class QRScanPage extends StatefulWidget {
  const QRScanPage({super.key});

  @override
  State<QRScanPage> createState() => _QRScanPageState();
}

class _QRScanPageState extends State<QRScanPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;

  final TextEditingController storeIdController = TextEditingController();
  final TextEditingController serialNumberController = TextEditingController();
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  Transaction? transaction;
  bool isLoading = false;

  final TextEditingController itemNameController = TextEditingController();
  String scannedBarcode = "Belum ada hasil scan";
  String apiMessage = "";
  bool isScanning = false;

  bool isItemFound = false;
  User? user;

  @override
  void initState() {
    super.initState();
    getUserFromPreferences();
  }

  Future<void> getUserFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString('user');

    if (userData != null) {
      final userJson = jsonDecode(userData);
      setState(() {
        user = User.fromJson(userJson);
      });
    } else {
      setState(() {
        user = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
                      top: 6,
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
                          'Barcode Scan',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (transaction != null)
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black12)],
              ),
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "Product Name",
                      border: OutlineInputBorder(),
                    ),
                    initialValue: transaction!.product_name,
                    enabled: false,
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "Serial Number",
                      border: OutlineInputBorder(),
                    ),
                    initialValue: transaction!.serial_number,
                    enabled: false,
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "Price",
                      border: OutlineInputBorder(),
                    ),
                    initialValue: transaction!.price.toString(),
                    enabled: false,
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "Stock",
                      border: OutlineInputBorder(),
                    ),
                    initialValue: transaction!.stock.toString(),
                    enabled: false,
                  ),
                ],
              ),
            ),
          Expanded(
            child: isScanning
                ? Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'Pastikan data sudah benar sebelum memindai QR',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        child: QRView(
                          key: qrKey,
                          onQRViewCreated: _onQRViewCreated,
                        ),
                      ),
                    ],
                  )
                : transaction == null
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                'Masukkan Nama Barang:',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8),
                              TextField(
                                controller: itemNameController,
                                decoration: InputDecoration(
                                  labelText: "Nama Barang",
                                  border: OutlineInputBorder(),
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    itemNameController.text = value;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      )
                    : Text(''),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: itemNameController.text.isNotEmpty && !isScanning
                      ? () {
                          setState(() {
                            isScanning = true;
                          });
                        }
                      : null,
                  icon: Icon(
                    Icons.qr_code_scanner,
                    color: Colors.white,
                    size: 24.0,
                  ),
                  label: Text(
                    "Scan",
                    style: TextStyle(color: Colors.white, fontSize: 20.0),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF00B2E9),
                    disabledBackgroundColor: Color.fromARGB(255, 135, 211, 235),
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  ),
                ),
                SizedBox(
                  width: 10.0,
                ),
                ElevatedButton(
                  onPressed: isItemFound ? () => _submitData() : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF00B2E9),
                    disabledBackgroundColor: Color.fromARGB(255, 135, 211, 235),
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  ),
                  child: isLoading
                      ? SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          "Submit",
                          style: TextStyle(color: Colors.white, fontSize: 20.0),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      setState(() {
        scannedBarcode = scanData.code ?? "Scan gagal!";
        controller.pauseCamera();
        isScanning = false;
      });

      await _callScanApi();
    });
  }

  Future<void> _callScanApi() async {
    final qrCode = scannedBarcode;
    final itemName = itemNameController.text.trim();
    final prefs = await SharedPreferences.getInstance();
    final rawToken = prefs.getString('token') ?? '';
    final token = rawToken.replaceAll('"', '');
    var urls = '${ApiService.baseUrl}/scan-item';
    final url = Uri.parse(urls);

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "name": itemName,
          "qrcode": qrCode,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final jsondata = data['data'];
        int? itemId = int.tryParse(data['data']['id'].toString());

        setState(() {
          apiMessage = "Barang ditemukan: ${data['data']['name']}";
          isItemFound = true;
          transaction = Transaction.fromJson(data['data']);
          transaction?.product_name = jsondata['name'];
          transaction?.item_id = itemId;
          transaction?.store_id = user?.store.id;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Scan berhasil, data ditemukan")),
        );
      } else {
        final error = jsonDecode(response.body);
        setState(() {
          apiMessage = "Error: ${error['message']}";
          isItemFound = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${error['message']}")),
        );
      }
    } catch (e) {
      setState(() {
        apiMessage = "Gagal menghubungi server: $e";
        isItemFound = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal mengirim data: $e")),
      );
    }
  }

  Future<void> _submitData() async {
    final itemName = itemNameController.text.trim();
    final qrCode = scannedBarcode;

    setState(() {
      isLoading = true;
    });

    if (itemName.isEmpty || qrCode == "Belum ada hasil scan") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Nama Barang dan QR Code harus diisi")),
      );
      return;
    }
    var data = {
      "item_id": transaction?.item_id,
      "store_id": transaction?.store_id,
      "product_name": transaction?.product_name,
      "serial_number": transaction?.serial_number
    };
    final prefs = await SharedPreferences.getInstance();
    final rawToken = prefs.getString('token') ?? '';
    final token = rawToken.replaceAll('"', '');
    var urls = '${ApiService.baseUrl}/transactions';
    final url = Uri.parse(urls);

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          "Content-Type": "application/json",
        },
        body: jsonEncode(data),
      );
      final responseData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        setState(() {
          apiMessage = "Transaksi berhasil!";
          isLoading = false;
        });
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(responseData['message'] ?? 'Transaksi berhasil!')),
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfilePage(),
          ),
        );
      } else {
        if (!mounted) return;
        final error = jsonDecode(response.body);
        setState(() {
          apiMessage = "Error: ${error['message']}";
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${error['message']}")),
        );
      }
    } catch (e) {
      setState(() {
        apiMessage = "Gagal mengirim data: $e";
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal mengirim data: $e")),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
