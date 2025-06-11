import 'dart:io';
import 'package:flutter/material.dart';

class DisplayImagePage extends StatelessWidget {
  final String imagePath;
  final VoidCallback onAccept;
  final VoidCallback onReject;
  final ValueChanged<String> onResult;

  const DisplayImagePage({
    super.key,
    required this.imagePath,
    required this.onAccept,
    required this.onReject,
    required this.onResult,
  });

  @override
  Widget build(BuildContext context) {
    const barColor = Color.fromARGB(255, 77, 192, 163);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Review Image',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            letterSpacing: 1,
            color: Colors.white,
          ),
        ),
        backgroundColor: barColor,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: barColor, width: 2),
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    image: FileImage(File(imagePath)),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.check),
                  label: const Text('Accept', style: TextStyle(fontSize: 18)),
                  onPressed: onAccept,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: barColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.close),
                  label: const Text('Reject', style: TextStyle(fontSize: 18)),
                  onPressed: onReject,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

