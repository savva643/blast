import 'package:flutter/material.dart';

class MainSettingsScreen extends StatelessWidget {
  const MainSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F10),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F0F10),
        title: const Text(
          'Основные настройки',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Оформление
          _buildSettingItem(
            icon: Icons.palette,
            title: "Оформление",
            onTap: () => _openThemeSettings(context),
          ),

          // Эквалайзер
          _buildSettingItem(
            icon: Icons.graphic_eq,
            title: "Эквалайзер",
            onTap: () => _showComingSoon(context, "Эквалайзер"),
          ),

          // Качество музыки
          _buildSettingItem(
            icon: Icons.music_note,
            title: "Качество музыки",
            onTap: () => _showComingSoon(context, "Качество музыки"),
          ),

          // Настройка скачивания
          _buildSettingItem(
            icon: Icons.download,
            title: "Настройка скачивания треков",
            onTap: () => _showComingSoon(context, "Настройки скачивания"),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      color: const Color(0xFF1E1E1E),
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: Colors.white),
        title: Text(title, style: const TextStyle(color: Colors.white)),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }

  void _openThemeSettings(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ThemeSettingsScreen()),
    );
  }

  void _showComingSoon(BuildContext context, String featureName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: Text(
          '$featureName скоро будет доступен',
          style: const TextStyle(color: Colors.white),
        ),
        content: Text(
          'Мы работаем над добавлением $featureName в следующем обновлении.',
          style: const TextStyle(color: Colors.grey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK', style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
    );
  }
}

// Экран выбора темы
class ThemeSettingsScreen extends StatefulWidget {
  const ThemeSettingsScreen({super.key});

  @override
  State<ThemeSettingsScreen> createState() => _ThemeSettingsScreenState();
}

class _ThemeSettingsScreenState extends State<ThemeSettingsScreen> {
  String _selectedTheme = 'Тёмная'; // По умолчанию

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F10),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F0F10),
        title: const Text(
          'Оформление',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildThemeOption(
              title: "Тёмная",
              isSelected: _selectedTheme == 'Тёмная',
              onTap: () => _setTheme('Тёмная'),
            ),
            _buildThemeOption(
              title: "Светлая",
              isSelected: _selectedTheme == 'Светлая',
              onTap: () => _setTheme('Светлая'),
            ),
            _buildThemeOption(
              title: "Системная",
              isSelected: _selectedTheme == 'Системная',
              onTap: () => _setTheme('Системная'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeOption({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Card(
      color: const Color(0xFF1E1E1E),
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.blue : Colors.white,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        trailing: isSelected
            ? const Icon(Icons.check, color: Colors.blue)
            : null,
        onTap: onTap,
      ),
    );
  }

  void _setTheme(String theme) {
    setState(() {
      _selectedTheme = theme;
    });
    // Здесь можно добавить логику сохранения темы и применения
  }
}