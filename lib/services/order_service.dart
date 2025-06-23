import 'package:rotiku/models/order_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderService {
  final CollectionReference orderRef = FirebaseFirestore.instance.collection(
    'order',
  );

  Future<void> createOrder(OrderModel order) async {
    try {
      final docRef = orderRef.add(order.toJson());
      final docSnapshot = await docRef;
      order.id = docSnapshot.id;
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<List<OrderModel>> getOrder() async {
    try {
      final snapshot = await orderRef.get();
      if (snapshot.docs.isEmpty) {
        print("Data order tidak ditemukan.");
      }
      return snapshot.docs.map((doc) {
        return OrderModel.fromFirestore(doc);
      }).toList();
    } catch (e) {
      print("Error: $e");
      return [];
    }
  }

  Future<OrderModel?> getOrderById(String id) async {
    final doc = await orderRef.doc(id).get();
    if (doc.exists) {
      return OrderModel.fromFirestore(doc);
    }
    return null;
  }

  Future<void> updateOrder(OrderModel order) async {
    if (order.id == null) return;
    await orderRef.doc(order.id).update(order.toJson());
  }
  
  
}


