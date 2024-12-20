// ignore_for_file: non_constant_identifier_names

class Transaction {
  int? id;
  String? serial_number;
  int? store_id;
  int? item_id;
  String? product_name;
  String? description;
  double? price;
  int? stock;

  Transaction(
      {this.id,
      this.serial_number,
      this.store_id,
      this.item_id,
      this.product_name,
      this.description,
      this.price,
      this.stock});

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
        id: json['id'],
        serial_number: json['serial_number'],
        store_id: json['store_id'],
        product_name: json['product_name'],
        description: json['description'],
        price: json['price'] != null ? double.parse(json['price']) : 0.0,
        stock: json['stock']);
  }
  Map<String, dynamic> toJson() => {
        "id": id,
        "serial_number": serial_number,
        "store_id": store_id,
        "item_id": item_id,
        "product_name": product_name,
        'description': description,
        "price": price,
        "stock": stock
      };

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map['id'] = id;
    map['serial_number'] = serial_number;
    map['store_id'] = store_id;
    map['item_id'] = item_id;
    map['product_name'] = product_name;
    map['description'] = description;
    map['price'] = price;
    map['stock'] = stock;
    return map;
  }
}
