import 'package:flutter/material.dart';
import 'package:rotiku/models/order_model.dart';
import 'package:rotiku/services/order_service.dart';
import 'package:rotiku/services/roti_service.dart';
import 'package:rotiku/models/roti_model.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:intl/intl.dart';

class DetailOrder extends StatefulWidget {
  final String orderId;
  const DetailOrder({super.key, required this.orderId});

  @override
  State<DetailOrder> createState() => _DetailOrderState();
}

class _DetailOrderState extends State<DetailOrder> {
  OrderModel? order;
  RotiModel? roti;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchOrderDetail();
  }

  Future<void> fetchOrderDetail() async {
    final orderService = OrderService();
    final rotiService = RotiService();
    final fetchedOrder = await orderService.getOrderById(widget.orderId);
    RotiModel? fetchedRoti;
    if (fetchedOrder != null) {
      fetchedRoti = await rotiService.getRotiById(fetchedOrder.roti_id ?? "");
    }
    setState(() {
      order = fetchedOrder;
      roti = fetchedRoti;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Order', style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        )),
        backgroundColor: const  Color.fromARGB(255, 214, 133, 99),
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : order == null
              ? const Center(child: Text('Order tidak ditemukan'))
              : ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  Text(
                    'Nama Roti: ${roti?.nama ?? "-"}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Harga Roti: Rp${NumberFormat("#,##0", "id_ID").format(roti?.harga ?? 0)}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const Divider(height: 32),
                  Text(
                    'Nama Pemesan: ${order?.nama ?? "-"}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'No Telepon: ${order?.no_telepon ?? "-"}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Jumlah Roti: ${order?.jumlah ?? 0}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Total Harga: Rp${NumberFormat("#,##0", "id_ID").format(order?.total_harga ?? 0)}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Latitude: ${order?.latitude ?? "-"}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Longitude: ${order?.longitude ?? "-"}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 24),
                  if (order?.latitude != null && order?.longitude != null)
                    SizedBox(
                      height: 250,
                      child: FlutterMap(
                        mapController: MapController(),
                        options: MapOptions(
                          initialCenter: LatLng(
                            order!.latitude!,
                            order!.longitude!,
                          ),
                          initialZoom: 16,
                        ),
                        children: [
                          TileLayer(
                            urlTemplate:
                                'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                            userAgentPackageName: 'com.example.rotiku',
                          ),
                          MarkerLayer(
                            markers: [
                              Marker(
                                width: 40,
                                height: 40,
                                point: LatLng(
                                  order!.latitude!,
                                  order!.longitude!,
                                ),
                                child: const Icon(
                                  Icons.location_on,
                                  color: Colors.red,
                                  size: 40,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                ],
              ),
    );
  }
}
