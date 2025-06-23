import 'package:rotiku/models/roti_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RotiService {
  final CollectionReference rotiRef = FirebaseFirestore.instance.collection(
    'roti',
  );

  Future<void> createRoti(RotiModel roti) async {
    try {
      final docRef = rotiRef.add(roti.toJson());
      final docSnapshot = await docRef;
      roti.id = docSnapshot.id;
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<List<RotiModel>> getRoti() async {
    try {
      final snapshot = await rotiRef.get();
      if (snapshot.docs.isEmpty) {
        print("Data roti tidak ditemukan.");
      }
      return snapshot.docs.map((doc) {
        return RotiModel.fromFirestore(doc);
      }).toList();
    } catch (e) {
      print("Error: $e");
      return [];
    }
  }

  Future<RotiModel?> getRotiById(String id) async {
    final doc = await rotiRef.doc(id).get();
    if (doc.exists) {
      return RotiModel.fromFirestore(doc);
    }
    return null;
  }

  Future<List<RotiModel>> getRotiByKategori(String kategori) async {
    try {
      final snapshot =
          await rotiRef.where('kategori', isEqualTo: kategori).get();
      if (snapshot.docs.isEmpty) {
        print("Data roti dengan kategori $kategori tidak ditemukan.");
      }
      return snapshot.docs.map((doc) {
        return RotiModel.fromFirestore(doc);
      }).toList();
    } catch (e) {
      print("Error: $e");
      return [];
    }
  }

  Future<void> updateRoti(RotiModel roti) async {
    if (roti.id == null) return;
    await rotiRef.doc(roti.id).update(roti.toJson());
  }

  Future<void> deleteRoti(String id) async {
    await rotiRef.doc(id).delete();
  }
}
