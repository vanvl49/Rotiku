import 'package:flutter/material.dart';
import 'package:rotiku/models/order_model.dart';
import 'package:rotiku/services/order_service.dart';
import 'package:rotiku/models/roti_model.dart';
import 'package:geolocator/geolocator.dart';

class OrderPage extends StatefulWidget {
  final RotiModel roti;
  const OrderPage({super.key, required this.roti});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  final _formKey = GlobalKey<FormState>();
  final OrderService _orderService = OrderService();

  TextEditingController namaController = TextEditingController();
  TextEditingController noTelpController = TextEditingController();
  TextEditingController jumlahController = TextEditingController();

  double? latitude;
  double? longitude;
  bool isLoadingLocation = false;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      isLoadingLocation = true;
    });
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          isLoadingLocation = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Izin lokasi diperlukan untuk melanjutkan'),
          ),
        );
        return;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      setState(() {
        isLoadingLocation = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Izin lokasi ditolak secara permanen')),
      );
      return;
    }
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    setState(() {
      latitude = position.latitude;
      longitude = position.longitude;
      isLoadingLocation = false;
    });
  }

  Future<void> _submitOrder() async {
    if (!_formKey.currentState!.validate() ||
        latitude == null ||
        longitude == null)
      return;

    int jumlah = int.tryParse(jumlahController.text) ?? 1;
    int harga = (widget.roti.harga ?? 0) * jumlah;

    OrderModel order = OrderModel(
      roti_id: widget.roti.id,
      jumlah: jumlah,
      total_harga: harga,
      nama: namaController.text,
      no_telepon: noTelpController.text,
      latitude: latitude,
      longitude: longitude,
    );

    await _orderService.createOrder(order);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Order berhasil dibuat!')));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Order Roti',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 214, 133, 99),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text(
                widget.roti.nama ?? '-',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text('Harga: Rp${widget.roti.harga ?? 0}'),
              const SizedBox(height: 20),
              TextFormField(
                controller: namaController,
                decoration: const InputDecoration(
                  labelText: 'Nama Pemesan',
                  border: OutlineInputBorder(),
                ),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Nama wajib diisi'
                            : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: noTelpController,
                decoration: const InputDecoration(
                  labelText: 'No Telepon',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'No telepon wajib diisi'
                            : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: jumlahController,
                decoration: const InputDecoration(
                  labelText: 'Jumlah Roti',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'Jumlah wajib diisi';
                  if (int.tryParse(value) == null || int.parse(value) < 1)
                    return 'Jumlah minimal 1';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              isLoadingLocation
                  ? const Center(child: CircularProgressIndicator())
                  : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Lokasi:'),
                      Text(
                        latitude != null && longitude != null
                            ? 'Lat: $latitude, Long: $longitude'
                            : 'Lokasi belum diambil',
                      ),
                      TextButton(
                        onPressed: _getCurrentLocation,
                        child: const Text('Ambil Lokasi Sekarang'),
                      ),
                    ],
                  ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed:
                    (latitude != null &&
                            longitude != null &&
                            !isLoadingLocation)
                        ? _submitOrder
                        : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const  Color.fromARGB(255, 214, 133, 99),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Pesan Sekarang',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
