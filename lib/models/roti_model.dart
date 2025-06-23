import 'package:cloud_firestore/cloud_firestore.dart';

class RotiModel {
  String? id;
  String? nama;
  String? kategori;
  String? deskripsi;
  int? harga;

  RotiModel({this.id, this.kategori, this.deskripsi, this.nama, this.harga});

  factory RotiModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return RotiModel(
      id: doc.id,
      nama: data['nama'] ?? 'no name',
      kategori: data['kategori'] ?? 'no kategori',
      deskripsi: data['deskripsi'] ?? 'no deskripsi',
      harga: int.tryParse(data['harga'].toString()) ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'kategori': kategori,
      'deskripsi': deskripsi,
      'harga': harga,
    };
  }
}
