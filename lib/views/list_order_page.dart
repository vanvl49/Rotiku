import 'package:flutter/material.dart';
import 'package:rotiku/models/order_model.dart';
import 'package:rotiku/services/order_service.dart';
import 'package:rotiku/services/roti_service.dart';
import 'package:rotiku/models/roti_model.dart';
import 'package:rotiku/views/detail_order.dart';
import 'package:intl/intl.dart';

class ListOrder extends StatefulWidget {
  const ListOrder({super.key});

  @override
  State<ListOrder> createState() => _ListOrderState();
}

class _ListOrderState extends State<ListOrder> {
  final OrderService orderService = OrderService();
  final RotiService rotiService = RotiService();

  Future<List<Map<String, dynamic>>> fetchOrdersWithRoti() async {
    List<OrderModel> orderList = await orderService.getOrder();
    List<Map<String, dynamic>> detailedList = [];

    for (var order in orderList) {
      RotiModel? roti = await rotiService.getRotiById(order.roti_id ?? "");
      detailedList.add({'order': order, 'roti': roti});
    }
    return detailedList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 214, 133, 99),
        title: const Text(
          'Daftar Order',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchOrdersWithRoti(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Tidak ada data order."));
          }

          final dataList = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: dataList.length,
            itemBuilder: (context, index) {
              final item = dataList[index];
              final order = item['order'] as OrderModel;
              final roti = item['roti'] as RotiModel?;

              return Card(
                elevation: 3,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Customer: ${order.nama ?? '-'}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Roti: ${roti?.nama ?? '-'}',
                        style: const TextStyle(fontSize: 15),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Jumlah: ${order.jumlah ?? 0}',
                        style: const TextStyle(fontSize: 15),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Harga: Rp${NumberFormat("#,##0", "id_ID").format(order.total_harga ?? 0)}',
                        style: const TextStyle(
                          fontSize: 15,
                          color: Color.fromARGB(255, 214, 133, 99),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) => DetailOrder(orderId: order.id ?? ''),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(
                              255,
                              214,
                              133,
                              99,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Detail',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
