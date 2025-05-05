import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F10),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F0F10),
        title: const Text(
          'Помощь и поддержка',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Быстрые ответы
          _buildSectionTitle('Быстрые ответы'),
          _buildHelpItem(
            icon: Icons.help_outline,
            title: 'Часто задаваемые вопросы',
            onTap: () => _openFAQ(context),
          ),
          _buildHelpItem(
            icon: Icons.video_library,
            title: 'Видеоинструкции',
            onTap: () => _openVideoTutorials(),
          ),

          // Контакты поддержки
          _buildSectionTitle('Свяжитесь с нами'),
          _buildHelpItem(
            icon: Icons.email,
            title: 'Написать в поддержку',
            subtitle: 'Обычный ответ в течение 24 часов',
            onTap: () => _contactSupport(),
          ),
          _buildHelpItem(
            icon: Icons.chat_bubble,
            title: 'Онлайн-чат',
            subtitle: 'Доступен с 9:00 до 21:00',
            onTap: () => _openLiveChat(context),
          ),
          _buildHelpItem(
            icon: Icons.phone,
            title: 'Телефон поддержки',
            subtitle: '+7 (123) 456-78-90',
            onTap: () => _callSupport(),
          ),

          // Сообщество
          _buildSectionTitle('Сообщество'),
          _buildHelpItem(
            icon: Icons.people,
            title: 'Форум пользователей',
            onTap: () => _openUserForum(),
          ),
          _buildHelpItem(
            icon: Icons.groups,
            title: 'Telegram-чат',
            onTap: () => _openTelegramGroup(),
          ),

          // Юридическая информация
          _buildSectionTitle('Юридическая информация'),
          _buildHelpItem(
            icon: Icons.description,
            title: 'Условия использования',
            onTap: () => _openTermsOfService(),
          ),
          _buildHelpItem(
            icon: Icons.security,
            title: 'Политика конфиденциальности',
            onTap: () => _openPrivacyPolicy(),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 8),
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

  Widget _buildHelpItem({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      color: const Color(0xFF1E1E1E),
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: Colors.white),
        title: Text(title, style: const TextStyle(color: Colors.white)),
        subtitle: subtitle != null
            ? Text(subtitle, style: const TextStyle(color: Colors.grey))
            : null,
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }

  // Методы для обработки нажатий
  void _openFAQ(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const FAQScreen()),
    );
  }

  Future<void> _contactSupport() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'support@keeppixel.com',
      queryParameters: {'subject': 'Помощь с приложением Blast'},
    );

    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri);
    } else {
      throw 'Не удалось открыть почтовый клиент';
    }
  }

  Future<void> _openLiveChat(BuildContext context) async {
    // Здесь должна быть интеграция с вашей системой поддержки
    // Например, Zendesk, Intercom и т.д.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Чат поддержки откроется в новом окне'),
      ),
    );
  }

  Future<void> _callSupport() async {
    const phoneNumber = 'tel:+71234567890';
    if (await canLaunchUrl(Uri.parse(phoneNumber))) {
      await launchUrl(Uri.parse(phoneNumber));
    } else {
      throw 'Не удалось совершить звонок';
    }
  }

  Future<void> _openVideoTutorials() async {
    const url = 'https://youtube.com/keeppixel';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Не удалось открыть YouTube';
    }
  }

  Future<void> _openUserForum() async {
    const url = 'https://community.keeppixel.com';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Не удалось открыть форум';
    }
  }

  Future<void> _openTelegramGroup() async {
    const url = 'https://t.me/keeppixel_support';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Не удалось открыть Telegram';
    }
  }

  Future<void> _openTermsOfService() async {
    const url = 'https://keeppixel.com/terms';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Не удалось открыть условия использования';
    }
  }

  Future<void> _openPrivacyPolicy() async {
    const url = 'https://keeppixel.com/privacy';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Не удалось открыть политику конфиденциальности';
    }
  }
}

// Экран с FAQ
class FAQScreen extends StatelessWidget {
  const FAQScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F10),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F0F10),
        title: const Text(
          'Часто задаваемые вопросы',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          FAQItem(
            question: 'Как восстановить доступ к аккаунту?',
            answer: 'Используйте функцию "Забыли пароль" на экране входа...',
          ),
          FAQItem(
            question: 'Как изменить качество музыки?',
            answer: 'Перейдите в Настройки → Качество музыки...',
          ),
          FAQItem(
            question: 'Почему не скачиваются треки?',
            answer: 'Проверьте подключение к интернету и доступное место...',
          ),
          FAQItem(
            question: 'Как отменить подписку?',
            answer: 'Перейдите в Платежи и подписки → Управление подпиской...',
          ),
        ],
      ),
    );
  }
}

class FAQItem extends StatefulWidget {
  final String question;
  final String answer;

  const FAQItem({
    super.key,
    required this.question,
    required this.answer,
  });

  @override
  State<FAQItem> createState() => _FAQItemState();
}

class _FAQItemState extends State<FAQItem> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF1E1E1E),
      margin: const EdgeInsets.only(bottom: 8),
      child: Column(
        children: [
          ListTile(
            title: Text(
              widget.question,
              style: const TextStyle(color: Colors.white),
            ),
            trailing: Icon(
              _isExpanded ? Icons.expand_less : Icons.expand_more,
              color: Colors.white,
            ),
            onTap: () => setState(() => _isExpanded = !_isExpanded),
          ),
          if (_isExpanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Text(
                widget.answer,
                style: const TextStyle(color: Colors.grey),
              ),
            ),
        ],
      ),
    );
  }
}