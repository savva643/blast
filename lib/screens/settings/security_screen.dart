import 'package:flutter/material.dart';

class SecurityScreen extends StatelessWidget {
  const SecurityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F10),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F0F10),
        title: const Text(
          'Безопасность',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSecurityOption(
            icon: Icons.lock,
            title: 'Изменить пароль',
            onTap: () {},
          ),
          _buildSecurityOption(
            icon: Icons.phone,
            title: 'Двухфакторная аутентификация',
            subtitle: 'Включено',
            onTap: () {},
          ),
          _buildSecurityOption(
            icon: Icons.email,
            title: 'Резервные email-адреса',
            subtitle: 'Добавлено 2 из 3',
            onTap: () {},
          ),
          _buildSecurityOption(
            icon: Icons.security,
            title: 'Активность аккаунта',
            subtitle: 'Последний вход: сегодня',
            onTap: () {},
          ),
          const SizedBox(height: 20),
          const Text(
            'Безопасность приложения',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white
            ),
          ),
          _buildSecurityOption(
            icon: Icons.fingerprint,
            title: 'Биометрическая аутентификация',
            subtitle: 'Отключено',
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityOption({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      color: const Color(0xFF1E1E1E),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon, color: Colors.white),
        title: Text(title, style: const TextStyle(color: Colors.white)),
        subtitle: subtitle != null
            ? Text(subtitle, style: const TextStyle(color: Colors.grey))
            : null,
        trailing: const Icon(Icons.chevron_right, color: Colors.white),
        onTap: onTap,
      ),
    );
  }
}