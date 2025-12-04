import 'package:flutter/material.dart';

class PaymentsAndSubscriptionsScreen extends StatelessWidget {
  const PaymentsAndSubscriptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F10),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F0F10),
        title: const Text(
          'Подписки Necsoura',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            Center(
              child: Image.asset(
                'assets/images/keeppixel_logo.png', // Добавьте свое изображение
                width: 200,
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Премиум возможности\nскоро будут доступны!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Мы готовим для вас эксклюзивные подписки с:',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            _buildFeatureItem('Увеличенное облачное хранилище'),
            _buildFeatureItem('Премиум поддержка 24/7'),
            _buildFeatureItem('Ранний доступ к новым функциям'),
            _buildFeatureItem('Кастомные темы и иконки'),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.blue, size: 20),
          const SizedBox(width: 12),
          Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}