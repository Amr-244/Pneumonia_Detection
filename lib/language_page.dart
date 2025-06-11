import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'main.dart'; // مهم علشان MyApp.setLocale
import 'package:shared_preferences/shared_preferences.dart';

class LanguagePage extends StatefulWidget {
  const LanguagePage({super.key});

  @override
  State<LanguagePage> createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  String _selected = 'en';

  final Map<String, IconData> _languageIcons = {
    'en': Icons.language,
    'ar': Icons.language_outlined,
  };

  final Map<String, String> _displayNames = {
    'en': 'English',
    'ar': 'العربية',
  };

  @override
  void initState() {
    super.initState();
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final lang = prefs.getString('lang') ?? 'en';
    setState(() {
      _selected = lang;
    });
  }

  Future<void> _saveLanguage(String langCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lang', langCode);
    MyApp.setLocale(context, Locale(langCode));
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(t.language),
        backgroundColor: const Color.fromARGB(255, 77, 192, 177),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          children: [
            Text(
              t.select_language,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ..._displayNames.entries.map((entry) {
              final code = entry.key;
              final label = entry.value;
              final isSelected = _selected == code;

              return GestureDetector(
                onTap: () {
                  setState(() => _selected = code);
                },
                child: Card(
                  color: isSelected ? const Color.fromARGB(255, 233, 255, 249) : Colors.white,
                  elevation: isSelected ? 6 : 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(
                      color: isSelected ? Colors.teal : Colors.grey[300]!,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: ListTile(
                    leading: Icon(
                      _languageIcons[code],
                      color: isSelected ? Colors.teal[700] : Colors.grey[700],
                    ),
                    title: Text(
                      label,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected ? Colors.teal[900] : Colors.black87,
                      ),
                    ),
                    trailing: isSelected
                        ? const Icon(Icons.check_circle, color: Colors.teal)
                        : null,
                  ),
                ),
              );
            }),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: () {
                _saveLanguage(_selected);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(t.language_saved)),
                );
              },
              icon: const Icon(Icons.save),
              label: Text(t.save_language),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 77, 192, 177),
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
