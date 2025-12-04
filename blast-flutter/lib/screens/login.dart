import 'package:blast/screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../api/api_service.dart';
import '../widgets/two_factor_dialog.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback resetap;
  final bool? onBack; // Added back callback

  LoginScreen({
    Key? key,
    required this.resetap,
    this.onBack, // Optional back callback
  }) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _rememberMe = false;
  bool _showQrCode = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> login() async {
    final status = await apiService.toLogin(
      _emailController.text,
      _passwordController.text,
      _rememberMe,
    );

    await _handleAuthStatus(status, _rememberMe);
  }

  final ApiService apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F10),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Desktop/tablet layout for width > 800
          if (constraints.maxWidth > 800) {
            return _buildDesktopLayout(constraints);
          }
          // Mobile layout
          else {
            return _buildMobileLayout(constraints);
          }
        },
      ),
    );
  }

  Widget _buildDesktopLayout(BoxConstraints constraints) {
    return Row(
      children: [
        // Left side - Branding
        Expanded(
          flex: 5,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF6C63FF).withOpacity(0.8),
                  const Color(0xFF3F3D9D),
                ],
              ),
            ),
            child: Stack(
              children: [
                // Back button for desktop
                if (widget.onBack != null)
                  Positioned(
                    top: 20,
                    left: 20,
                    child: _buildBackButton(),
                  ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                    // Necsoura Logo
                      Image.asset(
                        'assets/images/keeppixel_logo.png',
                        height: 120,
                      ),
                      const SizedBox(height: 24),

                      // Necsoura Text
                      const Text(
                        'Necsoura',
                        style: TextStyle(
                          fontSize: 42,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Tagline
                      const Text(
                        'Единый аккаунт для всей экосистемы Necsoura',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      const SizedBox(height: 60),

                      // App logos showcase - only icons, no text
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildAppLogoIconOnly('assets/images/blast_log.png', true),
                          _buildAppLogoIconOnly('assets/images/kompot_logo.png', true),
                          _buildAppLogoIconOnly('assets/images/keeppixel_logo.png', false),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Right side - Login Form
        Expanded(
          flex: 4,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back button for desktop (alternative position)
                  if (widget.onBack != null && false) // Set to true if you want it here instead
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: _buildBackButton(color: Colors.white),
                      ),
                    ),

                  // Current app indicator with "Login to [AppName]" format
                  Container(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Войти в',
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFFFFFFF),
                              fontFamily: 'Montserrat'
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'blast!',
                          style: const TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFFFFFFFF),
                              fontFamily: 'Montserrat'
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Toggle between QR and Form login
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            setState(() {
                              _showQrCode = false;
                            });
                          },
                          icon: const Icon(
                            Icons.login,
                            color: Colors.white,
                          ),
                          label: const Text('Пароль', style: TextStyle(color: Colors.white),),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: !_showQrCode
                                ? const Color(0xFF6C63FF)
                                : Colors.grey.shade800,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8),
                                bottomLeft: Radius.circular(8),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            setState(() {
                              _showQrCode = true;
                            });
                          },
                          icon: const Icon(
                            Icons.qr_code,
                            color: Colors.white,
                          ),
                          label: const Text('QR-код', style: TextStyle(color: Colors.white),),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _showQrCode
                                ? const Color(0xFF6C63FF)
                                : Colors.grey.shade800,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(8),
                                bottomRight: Radius.circular(8),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),

                  // Show either QR code or login form
                  _showQrCode ? _buildQrCodeLogin() : _buildLoginForm(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(BoxConstraints constraints) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Back button for mobile
            if (widget.onBack != null)
              Padding(
                padding: const EdgeInsets.only(top: 16, bottom: 8),
                child: _buildBackButton(color: Colors.white),
              ),

            const SizedBox(height: 16),

            // Necsoura Logo
            Center(
              child: Image.asset(
                'assets/images/keeppixel_logo.png',
                height: 80,
              ),
            ),
            const SizedBox(height: 16),

            // Necsoura Text
            const Center(
              child: Text(
                'Necsoura',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // App indicator with "Login to [AppName]" format
            Center(
              child: Container(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'Войти в',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFFFFFFF),
                        fontFamily: 'Montserrat'
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'blast!',
                      style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFFFFFFFF),
                          fontFamily: 'Montserrat'
                      ),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Toggle between QR and Form login
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _showQrCode = false;
                      });
                    },
                    icon: const Icon(
                      Icons.login,
                      color: Colors.white,
                    ),
                    label: const Text('Пароль', style: TextStyle(color: Colors.white),),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: !_showQrCode
                          ? const Color(0xFF6C63FF)
                          : Colors.grey.shade800,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8),
                          bottomLeft: Radius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _showQrCode = true;
                      });
                    },
                    icon: const Icon(
                      Icons.qr_code,
                      color: Colors.white,
                    ),
                    label: const Text('QR-код', style: TextStyle(color: Colors.white),),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _showQrCode
                          ? const Color(0xFF6C63FF)
                          : Colors.grey.shade800,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(8),
                          bottomRight: Radius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Login Form or QR Code
            Card(
              color: const Color(0xFF191818),
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: _showQrCode ? _buildQrCodeLogin() : _buildLoginForm(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Back button widget
  Widget _buildBackButton({Color color = Colors.white}) {
    return InkWell(
      onTap: (){Navigator.pop(context);},
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.arrow_back_ios_new,
              color: color,
              size: 18,
            ),
            const SizedBox(width: 4),
            Text(
              'Назад',
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQrCodeLogin() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(width: double.infinity), // For alignment

        // QR Code
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: QrImageView(
            data: 'https://keeppixel.com/login?app=blast&token=sample-token-123',
            version: QrVersions.auto,
            size: 200,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            embeddedImage: AssetImage('assets/images/keeppixel_logo.png'),
            embeddedImageStyle: QrEmbeddedImageStyle(
              size: const Size(52, 40),
            ),
          ),
        ),
        const SizedBox(height: 24),

        // Instructions
        Text(
          'Отсканируй через приложение Necsoura ID',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.white.withOpacity(0.9),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Откройте приложение Necsoura ID на своем телефоне, перейдите в раздел «Сканировать QR-код» и наведите камеру на этот код, чтобы выполнить безопасный вход.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: Colors.white.withOpacity(0.7),
          ),
        ),
        const SizedBox(height: 24),

        // Refresh button
        TextButton.icon(
          onPressed: () {
            // Refresh QR code logic
          },
          icon: const Icon(
            Icons.refresh,
            color: Color(0xFF6C63FF),
          ),
          label: const Text(
            'Обновить QR-код',
            style: TextStyle(
              color: Color(0xFF6C63FF),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Email Field
          TextFormField(
            controller: _emailController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: 'Логин',
              labelStyle: TextStyle(
                color: Colors.white.withOpacity(0.7),
              ),
              prefixIcon: const Icon(
                Icons.person_outline,
                color: Colors.white70,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white.withOpacity(0.1),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Пожайлуйста введите логин';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Password Field
          TextFormField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: 'Пароль',
              labelStyle: TextStyle(
                color: Colors.white.withOpacity(0.7),
              ),
              prefixIcon: const Icon(
                Icons.lock_outline,
                color: Colors.white70,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: Colors.white70,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white.withOpacity(0.1),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Пожайлуйста введите пароль';
              }
              return null;
            },
          ),

          // Remember Me & Forgot Password
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Checkbox(
                    value: _rememberMe,
                    onChanged: (value) {
                      setState(() {
                        _rememberMe = value ?? false;
                      });
                    },
                    fillColor: MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                        if (states.contains(MaterialState.selected)) {
                          return const Color(0xFF6C63FF);
                        }
                        return Colors.white.withOpacity(0.2);
                      },
                    ),
                  ),
                  Text(
                    'Запомнить меня',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {
                  // Handle forgot password
                },
                child: const Text(
                  'Забыли пароль?',
                  style: TextStyle(
                    color: Color(0xFF6C63FF),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Login Button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  login();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6C63FF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Войти',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Or continue with
          Row(
            children: [
              Expanded(
                child: Divider(
                  color: Colors.white.withOpacity(0.3),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Войти через',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
              ),
              Expanded(
                child: Divider(
                  color: Colors.white.withOpacity(0.3),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Social Login Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildSocialButton(
                icon: FontAwesomeIcons.google,
                color: Colors.red,
                onPressed: () {
                  // Handle Google login
                  signInWithGoogle();
                },
              ),
              _buildSocialButton(
                icon: FontAwesomeIcons.yandex,
                color: Colors.red,
                onPressed: () {
                  // Handle Yandex login
                },
              ),
              _buildSocialButton(
                icon: FontAwesomeIcons.vk,
                color: Colors.blue,
                onPressed: () {
                  // Handle VK login
                },
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Register
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Нету аккаутна?',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
              TextButton(
                onPressed: () {
                  // Handle register
                  Navigator.push(context, MaterialPageRoute(builder: (context) =>  AuthScreen(resetap: widget.resetap, onBack: true,)));
                },
                child: const Text(
                  'Зарегистрироваться',
                  style: TextStyle(
                    color: Color(0xFF6C63FF),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }


  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
    serverClientId: '188082421087-lqou46rteh0l1so3jed7unno9qblckfj.apps.googleusercontent.com', // Твой Client ID
  );

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final String? idToken = googleAuth.idToken;  // Это ключевой токен для проверки на сервере

      if (idToken == null) {
        throw Exception('Google ID Token is null');
      }

      final success = await apiService.loginWithGoogle(idToken, isRemember: true);
      if (success) {
        widget.resetap();
      } else {
        _showMessage('Google вход отклонён');
      }
    } catch (error) {
      print('Error: $error');
      _showMessage('Не удалось выполнить вход через Google');
    }
  }

  Future<void> _handleAuthStatus(AuthStatus status, bool rememberMe) async {
    switch (status) {
      case AuthStatus.success:
        widget.resetap();
        break;
      case AuthStatus.requiresTwoFactor:
        await showTwoFactorDialog(
          context: context,
          apiService: apiService,
          rememberMe: rememberMe,
          onSuccess: widget.resetap,
        );
        break;
      case AuthStatus.failure:
        _showMessage('Неверный логин или пароль');
        break;
    }
  }

  void _showMessage(String text) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  Widget _buildSocialButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: FaIcon(
            icon,
            color: color,
            size: 24,
          ),
        ),
      ),
    );
  }

  // New method for app logos without text labels
  Widget _buildAppLogoIconOnly(String assetPath, bool dark) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          color: dark ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child:
          Image.asset(
            assetPath,
            height: 45,
            width: 45,
          ),
        ),
      ),
    );
  }
}

