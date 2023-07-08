import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sending and Receiving Data From Firebase'),
      ),
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Judul',
              ),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Yang Mau Diketik',
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: fetchDataFromFirebase,
              child: const Text('Ambil Data'),
            ),
            ElevatedButton(
              onPressed: sendDataToFirebase,
              style: ElevatedButton.styleFrom(
                primary: Colors.green,
              ),
              child: const Text('Kirim Data'),
            ),
          ],
        ),
      ),
    );
  }

  void fetchDataFromFirebase() async {
    final url = Uri.parse('https://uasmade2-default-rtdb.asia-southeast1.firebasedatabase.app//rtdb.json');
    final response = await http.get(url);

    if (response.statusCode == 200) {
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
          content: const Text('Failed to fetch data from Firebase.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  void sendDataToFirebase() async {
    final url = Uri.parse('https://uasmade2-default-rtdb.asia-southeast1.firebasedatabase.app//rtdb.json');
    final newData = {
      'judul': _nameController.text,
      'yang diketik': _descriptionController.text,
    };
    final response = await http.post(
      url,
      body: jsonEncode(newData),
    );

    if (response.statusCode == 200) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Success'),
          content: const Text('Data terkirim.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _nameController.clear();
                _descriptionController.clear();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Failed to send data to Firebase.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
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
        title: const Text('Data Screen'),
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
