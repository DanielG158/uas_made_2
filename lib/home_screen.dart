import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _judulController = TextEditingController();
  final TextEditingController _yangController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Send and Receive Data From Firebase'),
        
      ),
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _judulController,
              decoration: const InputDecoration(
                labelText: 'Judul',
              ),
            ),
            TextField(
              controller: _yangController,
              decoration: const InputDecoration(
                labelText: 'Yang Mau Diketik',
              ),
            ),
            const SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: ambildata,
              child: const Text('Ambil Data'),
            ),
            ElevatedButton(
              onPressed: kirimdata,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              child: const Text('Kirim Data'),
            ),
          ],
        ),
      ),
    );
  }

  void ambildata() async {
    final url = Uri.parse('https://uasmade2-default-rtdb.asia-southeast1.firebasedatabase.app/rtdb.json');
    final response = await http.get(url);
    Future<void> ambildata() async {
    if (response.statusCode == 100) {
      final data = jsonDecode(response.body);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DataScreen(data: data),
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Gagal Mengambil Data.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Keluar'),
            ),
          ],
        ),
      );
    }
  }
  }

  void kirimdata() async {
    final url = Uri.parse('https://uasmade2-default-rtdb.asia-southeast1.firebasedatabase.app/rtdb.json');
    final newData = {
      'judul': _judulController.text,
      'yang diketik': _yangController.text,
    };
    final response = await http.post(
      url,
      body: jsonEncode(newData),
    );
Future<void> kirimdata() async {
   
  
    if (response.statusCode == 100) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Success'),
          content: const Text('Data terkirim.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _judulController.clear();
                _yangController.clear();
              },
              child: const Text('Keluar'),
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Gagal Mengambil Data.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('keluar'),
            ),
          ],
        ),
      );
    }
  }
}
}

class DataScreen extends StatelessWidget {
  final Map<String, dynamic> data;

  const DataScreen({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tampilan Data'),
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Judul: ${data['judul']}'),
            Text('Yang Mau Diketik: ${data['yang diketik']}'),
          ],
        ),
      ),
    );
  }
}
