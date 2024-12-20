// ignore_for_file: non_constant_identifier_names

class MFiles {
  int? id;
  int? store_id;
  String? file_path;
  String? file_name;
  String? description;

  MFiles(
      {this.id,
      this.store_id,
      this.file_path,
      this.file_name,
      this.description});

  factory MFiles.fromJson(Map<String, dynamic> json) {
    return MFiles(
        id: json['id'],
        store_id: json['store_id'],
        file_path: json['file_path'],
        file_name: json['file_name'],
        description: json['desription']);
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "store_id": store_id,
      "file_path": file_path,
      "file_name": file_name,
      "description": description
    };
  }
}
