import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  String? id;
  String? roti_id;
  int? jumlah;
  int? total_harga;
  String? nama;
  String? no_telepon;
  double? latitude;
  double? longitude;

  OrderModel({
    this.id,
    this.roti_id,
    this.jumlah,
    this.total_harga,
    this.nama,
    this.no_telepon,
    this.latitude,
    this.longitude,
  });

  factory OrderModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return OrderModel(
      id: doc.id,
      roti_id: data['roti_id'] ?? 'no roti_id',
      jumlah: int.tryParse(data['jumlah'].toString()) ?? 0,
      total_harga: int.tryParse(data['total_harga'].toString()) ?? 0,
      nama: data['nama'] ?? 'no name',
      no_telepon: data['no_telepon'] ?? '00000',
      latitude: double.tryParse(data['latitude'].toString()) ?? 0.0,
      longitude: double.tryParse(data['longitude'].toString()) ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'roti_id': roti_id,
      'jumlah': jumlah,
      'total_harga': total_harga,
      'nama': nama,
      'no_telepon': no_telepon,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}