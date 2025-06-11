import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'intro_page.dart';
import 'language_page.dart';
import 'rate_page.dart';
import 'chatbot_page.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'dart:io';
import 'package:image/image.dart' as img;

class HomePage extends StatefulWidget {
  final VoidCallback toggleDarkMode;

  const HomePage({super.key, required this.toggleDarkMode});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Interpreter? _interpreter;
  String? _predictionResult;
  String? _imagePath;
  bool _isModelLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadModel();
  }

  Future<void> _loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset('assets/PN.tflite');
      setState(() {
        _isModelLoaded = true;
      });
      print('✅ Model loaded successfully');
    } catch (e) {
      print('❌ Failed to load model: $e');
    }
  }

  Future<void> _predictImage(String imagePath) async {
    if (!_isModelLoaded || _interpreter == null) return;

    try {
      final input = await _prepareImage(File(imagePath));
      var output = List.filled(1 * 1, 0.0).reshape([1, 1]);

      _interpreter!.run(input, output);

      double result = output[0][0];
      setState(() {
        _predictionResult = result > 0.5
            ? "❗ ${AppLocalizations.of(context)!.pneumonia_detected}"
            : "✅ ${AppLocalizations.of(context)!.no_pneumonia}";
      });
    } catch (e) {
      print('❌ Prediction error: $e');
    }
  }

  Future<List<List<List<List<double>>>>> _prepareImage(File imageFile) async {
    final bytes = imageFile.readAsBytesSync();
    final image = img.decodeImage(bytes);
    if (image == null) throw Exception('❌ Unable to decode image.');
    final fixedImage = img.bakeOrientation(image);
    final resized = img.copyResize(fixedImage, width: 224, height: 224);
    final imageList = List.generate(224, (y) {
      return List.generate(224, (x) {
        final pixel = resized.getPixel(x, y);
        final r = img.getRed(pixel) / 255.0;
        final g = img.getGreen(pixel) / 255.0;
        final b = img.getBlue(pixel) / 255.0;
        return [r, g, b];
      });
    });
    return [imageList];
  }

  void _resetImage() {
    setState(() {
      _imagePath = null;
      _predictionResult = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(t.app_title,
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 77, 192, 163),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const IntroPage())),
              child: const CircleAvatar(backgroundImage: AssetImage('assets/hhh.jpg')),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [Color(0xFF4DC0A3), Color(0xFF3EAA96)], begin: Alignment.topLeft, end: Alignment.bottomRight),
          ),
          child: Column(
            children: [
              const SizedBox(height: 60),
              const CircleAvatar(radius: 45, backgroundImage: AssetImage('assets/hhh.jpg')),
              const SizedBox(height: 12),
              Text(t.app_title, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 30),
              Expanded(
                child: ListView(
                  children: [
                    _styledDrawerItem(Icons.info, t.intro, const IntroPage()),
                    _styledDrawerItem(Icons.chat, t.chatbot, const ChatBotPage()),
                    _styledDrawerItem(Icons.language, t.language, const LanguagePage()),
                    _styledDrawerItem(Icons.star, t.rate, const RatePage()),
                    ListTile(
                      leading: const Icon(Icons.dark_mode, color: Colors.white),
                      title: Text(t.dark_mode_toggle, style: const TextStyle(color: Colors.white)),
                      onTap: widget.toggleDarkMode,
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 16),
                child: Text('Version 1.0.0', style: TextStyle(color: Colors.white70)),
              ),
            ],
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(isDarkMode ? "assets/homedd.jpg" : "assets/home1.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(t.welcome, style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 113, 113, 113))),
                const SizedBox(height: 10),
                Text(t.description, textAlign: TextAlign.center, style: const TextStyle(fontSize: 18, color: Color.fromARGB(179, 120, 119, 119))),
                const SizedBox(height: 70),
                GestureDetector(
                  onTap: () async {
                    final picker = ImagePicker();
                    final image = await picker.pickImage(source: ImageSource.camera);
                    if (image != null) {
                      setState(() {
                        _imagePath = image.path;
                        _predictionResult = null;
                      });
                    }
                  },
                  child: _buildImageBox(t),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () async {
                    final picker = ImagePicker();
                    final image = await picker.pickImage(source: ImageSource.gallery);
                    if (image != null) {
                      setState(() {
                        _imagePath = image.path;
                        _predictionResult = null;
                      });
                    }
                  },
                  icon: const Icon(Icons.upload_file),
                  label: Text(t.upload, style: const TextStyle(fontSize: 18)),
                  style: ElevatedButton.styleFrom(backgroundColor: const Color.fromRGBO(77, 192, 163, 1), foregroundColor: Colors.white),
                ),
                const SizedBox(height: 30),
                if (_imagePath != null)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () => _predictImage(_imagePath!),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(77, 192, 163, 1),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Text(t.check_result, style: const TextStyle(fontSize: 18)),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton.icon(
                        onPressed: _resetImage,
                        icon: const Icon(Icons.refresh),
                        label: Text(t.reset),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 30),
                if (_predictionResult != null)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _predictionResult!.contains("No") ? const Color.fromARGB(255, 212, 230, 214) : const Color.fromARGB(255, 231, 203, 207),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: _predictionResult!.contains("No") ? Colors.green : Colors.red,
                        width: 2,
                      ),
                    ),
                    child: Text(
                      _predictionResult!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: _predictionResult!.contains("No") ? Colors.green : Colors.red,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageBox(AppLocalizations t) {
    return Container(
      width: 160,
      height: 175,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        border: Border.all(color: Colors.teal, width: 2),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [BoxShadow(color: Colors.teal.withOpacity(0.2), blurRadius: 12, offset: const Offset(0, 6))],
      ),
      child: _imagePath == null
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.qr_code_scanner, size: 70, color: Color.fromARGB(255, 182, 33, 80)),
                const SizedBox(height: 10),
                Text(t.scan, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey)),
              ],
            )
          : ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.file(File(_imagePath!), fit: BoxFit.cover),
            ),
    );
  }

  Widget _styledDrawerItem(IconData icon, String title, Widget page) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: const TextStyle(fontSize: 18, color: Colors.white)),
      onTap: () {
        Navigator.pop(context);
        Future.delayed(const Duration(milliseconds: 300), () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => page));
        });
      },
    );
  }

  @override
  void dispose() {
    _interpreter?.close();
    super.dispose();
  }
}
