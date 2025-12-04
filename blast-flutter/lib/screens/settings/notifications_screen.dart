import 'package:flutter/material.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool _generalNotifications = true;
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;
  bool _newReleases = true;
  bool _recommendations = true;
  bool _specialOffers = false;
  String _notificationSound = 'По умолчанию';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F10),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F0F10),
        title: const Text(
          'Уведомления',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Основные настройки
          _buildSectionTitle('Основные настройки'),
          _buildNotificationSwitch(
            title: 'Уведомления',
            value: _generalNotifications,
            onChanged: (val) => setState(() => _generalNotifications = val),
          ),
          _buildNotificationSwitch(
            title: 'Звук',
            value: _soundEnabled,
            onChanged: (val) => setState(() => _soundEnabled = val),
          ),
          _buildNotificationSwitch(
            title: 'Вибрация',
            value: _vibrationEnabled,
            onChanged: (val) => setState(() => _vibrationEnabled = val),
          ),

          // Выбор звука уведомления
          if (_soundEnabled) ...[
            const SizedBox(height: 8),
            _buildSoundSelector(),
          ],

          // Типы уведомлений
          _buildSectionTitle('Типы уведомлений'),
          _buildNotificationSwitch(
            title: 'Новые релизы',
            subtitle: 'Уведомлять о новых треках и альбомах',
            value: _newReleases,
            onChanged: (val) => setState(() => _newReleases = val),
          ),
          _buildNotificationSwitch(
            title: 'Рекомендации',
            subtitle: 'Персональные рекомендации музыки',
            value: _recommendations,
            onChanged: (val) => setState(() => _recommendations = val),
          ),
          _buildNotificationSwitch(
            title: 'Специальные предложения',
            subtitle: 'Акции и премиум подписки',
            value: _specialOffers,
            onChanged: (val) => setState(() => _specialOffers = val),
          ),

          // Тестовое уведомление
          const SizedBox(height: 24),
          Center(
            child: ElevatedButton(
              onPressed: _sendTestNotification,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Text(
                'Отправить тестовое уведомление',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
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

  Widget _buildNotificationSwitch({
    required String title,
    String? subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Card(
      color: const Color(0xFF1E1E1E),
      margin: const EdgeInsets.only(bottom: 8),
      child: SwitchListTile(
        title: Text(title, style: const TextStyle(color: Colors.white)),
        subtitle: subtitle != null
            ? Text(subtitle, style: const TextStyle(color: Colors.grey))
            : null,
        value: value,
        onChanged: onChanged,
        activeColor: Colors.blue,
      ),
    );
  }

  Widget _buildSoundSelector() {
    return Card(
      color: const Color(0xFF1E1E1E),
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: const Text(
          'Звук уведомления',
          style: TextStyle(color: Colors.white),
        ),
        subtitle: Text(
          _notificationSound,
          style: const TextStyle(color: Colors.grey),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        onTap: () => _showSoundSelectionDialog(),
      ),
    );
  }

  void _showSoundSelectionDialog() {
    final sounds = ['По умолчанию', 'Короткий', 'Мелодичный', 'Вибрация', 'Без звука'];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text(
          'Выберите звук',
          style: TextStyle(color: Colors.white),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: sounds.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(
                  sounds[index],
                  style: TextStyle(
                    color: _notificationSound == sounds[index]
                        ? Colors.blue
                        : Colors.white,
                  ),
                ),
                onTap: () {
                  setState(() => _notificationSound = sounds[index]);
                  Navigator.pop(context);
                },
              );
            },
          ),
        ),
      ),
    );
  }

  void _sendTestNotification() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Тестовое уведомление отправлено'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );

    // Здесь можно добавить реальную отправку тестового уведомления
    // через Firebase Messaging или другой сервис
  }
}