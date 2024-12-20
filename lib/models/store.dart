import 'package:sakaiapp/models/filesmode.dart';

import 'storetype.dart';

class Store {
  final int id;
  final int userId;
  final String storeName;
  final int typeId;
  final String idCardNumber;
  final String owner;
  final String address;
  final String postalCode;
  final String locationStore;
  final String phoneNumber;
  final String city;
  final DateTime createdAt;
  final DateTime updatedAt;
  final StoreType type;
  final List<MFiles> files;

  Store(
      {required this.id,
      required this.userId,
      required this.storeName,
      required this.typeId,
      required this.idCardNumber,
      required this.owner,
      required this.address,
      required this.postalCode,
      required this.locationStore,
      required this.phoneNumber,
      required this.city,
      required this.createdAt,
      required this.updatedAt,
      required this.type,
      required this.files});

  factory Store.fromJson(Map<String, dynamic> json) {
    return Store(
      id: json['id'],
      userId: json['user_id'],
      storeName: json['store_name'],
      typeId: json['type_id'],
      idCardNumber: json['id_card_number'],
      owner: json['owner'],
      address: json['address'],
      postalCode: json['postal_code'],
      locationStore: json['location_store'],
      phoneNumber: json['phone_number'],
      city: json['city'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      type: StoreType.fromJson(json['type']),
      files: (json['files'] as List<dynamic>?)
              ?.map((file) => MFiles.fromJson(file))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'store_name': storeName,
      'type_id': typeId,
      'id_card_number': idCardNumber,
      'owner': owner,
      'address': address,
      'postal_code': postalCode,
      'location_store': locationStore,
      'phone_number': phoneNumber,
      'city': city,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'type': type.toJson(),
      'files': files.map((file) => file.toJson()).toList(),
    };
  }
}
