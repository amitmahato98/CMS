import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:math';

class RandomQRSection extends StatefulWidget {
  const RandomQRSection({Key? key}) : super(key: key);

  @override
  State<RandomQRSection> createState() => _RandomQRSectionState();
}

class _RandomQRSectionState extends State<RandomQRSection> {
  late String _randomData;

  @override
  void initState() {
    super.initState();
    _generateRandomQR();
  }

  void _generateRandomQR() {
    final rand = Random();
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    _randomData =
        List.generate(10, (index) => chars[rand.nextInt(chars.length)]).join();
  }

  void _regenerateQR() {
    setState(() {
      _generateRandomQR();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Random QR Code'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context), // ⬅️ Back function
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            QrImageView(
              data: _randomData,
              version: QrVersions.auto,
              size: 200.0,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _regenerateQR,
              child: Text('Generate New QR'),
            ),
            const SizedBox(height: 10),
            Text('QR Data: $_randomData'),
          ],
        ),
      ),
    );
  }
}
