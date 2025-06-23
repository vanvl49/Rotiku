import 'package:flutter/material.dart';
import 'package:rotiku/models/roti_model.dart';
import 'package:rotiku/services/roti_service.dart';
import 'package:intl/intl.dart';
import 'package:rotiku/views/order_page.dart';

class ListRoti extends StatefulWidget {
  const ListRoti({super.key});

  @override
  State<ListRoti> createState() => _ListRotiState();
}

class _ListRotiState extends State<ListRoti> {
  final RotiService _rotiService = RotiService();
  List<RotiModel> rotiList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchRoti();
  }

  Future<void> fetchRoti() async {
    rotiList = await _rotiService.getRoti();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 214, 133, 99),
        title: const Text(
          'Daftar Roti Rotiku',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : rotiList.isEmpty
              ? const Center(child: Text('Tidak ada roti yang tersedia.'))
              : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: rotiList.length,
                itemBuilder: (context, index) {
                  final roti = rotiList[index];
                  return Card(
                    elevation: 3,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            roti.nama ?? "Tanpa Nama",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            roti.kategori ?? "Tanpa Kategori",
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            roti.deskripsi ?? "-",
                            style: const TextStyle(fontSize: 15),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Rp${NumberFormat("#,##0", "id_ID").format(roti.harga ?? 0)}',
                            style: const TextStyle(
                              color: Color.fromARGB(255, 214, 133, 99),
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                onPressed: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => OrderPage(roti: roti),
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
                                  'Order',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
