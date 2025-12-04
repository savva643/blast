import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class LanguageRegionScreen extends StatefulWidget {
  const LanguageRegionScreen({super.key});

  @override
  State<LanguageRegionScreen> createState() => _LanguageRegionScreenState();
}

class _LanguageRegionScreenState extends State<LanguageRegionScreen> {
  // Доступные языки
  final List<Map<String, String>> _languages = [
    {'code': 'en', 'name': 'English', 'native': 'English'},
    {'code': 'ru', 'name': 'Russian', 'native': 'Русский'},
    {'code': 'es', 'name': 'Spanish', 'native': 'Español'},
    {'code': 'de', 'name': 'German', 'native': 'Deutsch'},
    {'code': 'fr', 'name': 'French', 'native': 'Français'},
    {'code': 'zh', 'name': 'Chinese', 'native': '中文'},
  ];

  @override
  Widget build(BuildContext context) {
    final currentLocale = context.locale;

    return Scaffold(
      backgroundColor: const Color(0xFF0F0F10),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F0F10),
        title: Text(
          'language_region.title'.tr(),
          style: const TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Выбор языка
          _buildSectionTitle('language_region.language'.tr()),
          ..._languages.map((lang) => _buildLanguageTile(
            lang: lang,
            isSelected: currentLocale.languageCode == lang['code'],
          )),

          const SizedBox(height: 24),

          // Региональные настройки
          _buildSectionTitle('language_region.region'.tr()),
         
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.grey,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildLanguageTile({
    required Map<String, String> lang,
    required bool isSelected,
  }) {
    return Card(
      color: const Color(0xFF1E1E1E),
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Text(
          _getFlagEmoji(lang['code']!),
          style: const TextStyle(fontSize: 24),
        ),
        title: Text(
          lang['native']!,
          style: TextStyle(
            color: isSelected ? Colors.blue : Colors.white,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        subtitle: Text(
          lang['name']!,
          style: const TextStyle(color: Colors.grey),
        ),
        trailing: isSelected
            ? const Icon(Icons.check, color: Colors.blue)
            : null,
        onTap: () => _changeLanguage(lang['code']!),
      ),
    );
  }

  Widget _buildRegionSetting({
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    return Card(
      color: const Color(0xFF1E1E1E),
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text(title, style: const TextStyle(color: Colors.white)),
        subtitle: Text(value, style: const TextStyle(color: Colors.grey)),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }

  void _changeLanguage(String languageCode) async {
    if (context.locale.languageCode != languageCode) {
      await context.setLocale(Locale(languageCode));
      setState(() {});
    }
  }



  String _getFlagEmoji(String countryCode) {
    final flagOffset = 0x1F1E6;
    final asciiOffset = 0x41;

    final firstChar = countryCode.toUpperCase().codeUnitAt(0) - asciiOffset;
    final secondChar = countryCode.toUpperCase().codeUnitAt(1) - asciiOffset;

    return String.fromCharCode(flagOffset + firstChar) +
        String.fromCharCode(flagOffset + secondChar);
  }
}