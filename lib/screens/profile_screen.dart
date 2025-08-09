import 'package:blast/screens/settings/connected_devices_screen.dart';
import 'package:blast/screens/settings/help_screen.dart';
import 'package:blast/screens/settings/lang_screen.dart';
import 'package:blast/screens/settings/main_settings.dart';
import 'package:blast/screens/settings/notifications_screen.dart';
import 'package:blast/screens/settings/payments_and_subscriptions_screen.dart';
import 'package:blast/screens/settings/security_screen.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/api_service.dart';
import '../providers/list_manager_provider.dart';

class ProfileScreen extends StatefulWidget {
  final VoidCallback reseti;

  const ProfileScreen({Key? key, required this.reseti}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ApiService apiService = ApiService();
  String imgprofile = "";
  String nameprofile = "";
  String emailprofile = "";
  bool useri = false;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    var usera = await apiService.getUser();
    if (mounted) {
      setState(() {
        if(usera['status'] != 'false') {
          useri = true;
          imgprofile = usera["img_kompot"] ?? "";
          nameprofile = usera["name_kompot"] ?? "";
          emailprofile = usera["email"] ?? "";
        } else {
          useri = false;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F10),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: size.width <= 800 ? IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ) : Container(),
        title: const Text(
          "Профиль",
          style: TextStyle(
            fontSize: 24,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
      body: LayoutBuilder(

        builder: (context, constraints) {
          if (constraints.maxWidth > 800) {
            return _buildDesktopLayout();
          } else {
            return _buildMobileLayout();
          }
        },
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      children: [
        // Left side - Profile info
        Expanded(
          flex: 2,
          child: _buildProfileInfo(),
        ),
        // Right side - Menu options
        Expanded(
          flex: 3,
          child: SingleChildScrollView(
    child: _buildMenuOptions()),
        ),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return SingleChildScrollView(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom + 60), // 60 - примерная высота bottom menu
      child: Column(
        children: [
          _buildProfileInfo(),
          const SizedBox(height: 24),
          _buildMenuOptions(),
        ],
      ),
    );
  }

  Widget _buildProfileInfo() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFF6C63FF),
                width: 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: ClipOval(
              child: imgprofile.isNotEmpty
                  ? CachedNetworkImage(
                imageUrl: imgprofile,
                fit: BoxFit.cover,
                placeholder: (context, url) => const CircularProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(
                  Icons.person,
                  size: 60,
                  color: Colors.white,
                ),
              )
                  : const Icon(
                Icons.person,
                size: 60,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            nameprofile,
            style: const TextStyle(
              fontSize: 24,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            emailprofile,
            style: const TextStyle(
              fontSize: 16,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // Edit profile action
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6C63FF),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text(
              'Редактировать профиль',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuOptions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildSectionTitle("Keep Pixel Аккаунт"),
          _buildOptionItem(
            icon: Icons.account_circle,
            title: "Мой профиль",
            onTap: () {},red: false,
          ),
          _buildOptionItem(
            icon: Icons.security,
            title: "Безопасность",
            onTap: () {Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SecurityScreen()),
            );},red: false,
          ),
          _buildOptionItem(
            icon: Icons.payment,
            title: "Платежи и подписки",
            onTap: () {Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const PaymentsAndSubscriptionsScreen()),
            );},red: false,
          ),
          _buildOptionItem(
            icon: Icons.devices,
            title: "Подключенные устройства",
            onTap: () {Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ConnectedDevicesScreen()),
            );},red: false,
          ),

          const SizedBox(height: 24),
          _buildSectionTitle("Настройки приложения"),
          _buildOptionItem(
            icon: Icons.settings,
            title: "Основные настройки",
            onTap: () {Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MainSettingsScreen()),
            );},red: false,
          ),
          _buildOptionItem(
            icon: Icons.notifications,
            title: "Уведомления",
            onTap: () {Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const NotificationsScreen()),
            );},red: false,
          ),
          _buildOptionItem(
            icon: Icons.language,
            title: "Язык и регион",
            onTap: () {Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LanguageRegionScreen()),
            );},red: false,
          ),
          _buildOptionItem(
            icon: Icons.help_center,
            title: "Помощь и поддержка",
            onTap: () {Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HelpSupportScreen()),
            );}, red: false,
          ),

          const SizedBox(height: 24),
          _buildOptionItem(
            icon: Icons.logout,
            title: "Выйти из аккаунта",
            onTap: () async {
              final SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.remove("token");
              await prefs.remove('logout_on_restart'); // Удаляем флаг
              final listManager = Provider.of<ListManagerProvider>(context, listen: false);
              await listManager.clearAllLists();
              widget.reseti();
            }, red: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 8, top: 16),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildOptionItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required bool red,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: const Color(0xFF1E1E1E),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: red ? Colors.red : Colors.white),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: red ? Colors.red : Colors.white,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}