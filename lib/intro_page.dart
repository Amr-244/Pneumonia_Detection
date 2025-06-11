import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  Widget _buildSectionCard({required String title, required List<Widget> content, IconData? icon}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (icon != null) Icon(icon, color: Colors.teal),
                if (icon != null) const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...content,
          ],
        ),
      ),
    );
  }

  Widget _buildBullet({required IconData icon, required String text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.teal),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text, style: const TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(t.about_app)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildSectionCard(
              icon: Icons.info_outline,
              title: t.why_app_matters,
              content: [Text(t.why_app_text, style: const TextStyle(fontSize: 16))],
            ),
            _buildSectionCard(
              icon: Icons.star_border,
              title: t.key_features,
              content: [
                _buildBullet(icon: Icons.image_search, text: t.feature_ai_detection),
                _buildBullet(icon: Icons.chat, text: t.feature_chatbot),
                _buildBullet(icon: Icons.language, text: t.feature_multilingual),
                _buildBullet(icon: Icons.dark_mode, text: t.feature_dark_mode),
                _buildBullet(icon: Icons.menu_book, text: t.feature_education),
              ],
            ),
            _buildSectionCard(
              icon: Icons.coronavirus,
              title: t.what_is_pneumonia,
              content: [
                Text(t.pneumonia_description, style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 8),
                Text(t.common_symptoms, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                children: [
                  _buildBullet(icon: Icons.sick, text: t.symptom_cough),
                  _buildBullet(icon: Icons.thermostat, text: t.symptom_fever),
                  _buildBullet(icon: Icons.air, text: t.symptom_breath),
                  _buildBullet(icon: Icons.warning, text: t.symptom_fatigue),
                ],
              ),
            ),
            _buildSectionCard(
              icon: Icons.health_and_safety_outlined,
              title: t.how_to_prevent,
              content: [
                _buildBullet(icon: Icons.vaccines, text: t.prevent_vaccine),
                _buildBullet(icon: Icons.clean_hands, text: t.prevent_hygiene),
                _buildBullet(icon: Icons.smoke_free, text: t.prevent_smoke),
                _buildBullet(icon: Icons.emoji_food_beverage, text: t.prevent_nutrition),
                _buildBullet(icon: Icons.local_hospital, text: t.prevent_early_care),
              ],
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                t.early_diagnosis,
                style: const TextStyle(fontSize: 18, fontStyle: FontStyle.italic, color: Colors.teal),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
