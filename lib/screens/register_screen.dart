import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../api/api_service.dart';

class AuthScreen extends StatefulWidget {
  final VoidCallback resetap;
  final bool? onBack;

  AuthScreen({
    Key? key,
    required this.resetap,
    this.onBack,
  }) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> with TickerProviderStateMixin {
  // Animation controller
  late AnimationController _animationController;
  late Animation<double> _animation;

  // Form state
  final _loginFormKey = GlobalKey<FormState>();
  final _registerFormKey = GlobalKey<FormState>();

  // Login controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Register controllers
  final _loginController = TextEditingController();
  final _nickController = TextEditingController();
  final _registerEmailController = TextEditingController();
  final _registerPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Form state
  bool _obscurePassword = true;
  bool _obscureRegisterPassword = true;
  bool _obscureConfirmPassword = true;
  bool _rememberMe = false;
  bool _registerRememberMe = false; // Added remember me for registration
  bool _agreeToTerms = false;
  bool _showQrCode = false;

  // Toggle between login and register
  bool _showLogin = true;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _loginController.dispose();
    _nickController.dispose();
    _registerEmailController.dispose();
    _registerPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _toggleAuthMode() {
    setState(() {
      _showLogin = !_showLogin;
      if (_showLogin) {
        _animationController.reverse();
      } else {
        _animationController.forward();
      }
    });
  }

  Future<void> login() async {
    bool loga = await apiService.toLogin(_emailController.text, _passwordController.text, _rememberMe);
    if (loga) {
      widget.resetap();
    } else {
      // Handle login failure
    }
  }

  Future<void> register() async {
    bool registered = await apiService.toRegister(
        _loginController.text,
        _nickController.text,
        _registerEmailController.text,
        _registerPasswordController.text,
        _registerRememberMe // Pass the remember me value
    );

    if (registered) {
      widget.resetap();
    } else {
      // Handle registration failure
    }
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
                      // Keep Pixel Logo
                      Image.asset(
                        'assets/images/keeppixel_logo.png',
                        height: 120,
                      ),
                      const SizedBox(height: 24),

                      // Keep Pixel Text
                      const Text(
                        'Keep Pixel',
                        style: TextStyle(
                          fontSize: 42,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Tagline
                      Text(
                        _showLogin
                            ? 'Один аккаунт для всех сервисов Keep Pixel'
                            : 'Создайте аккаунт для всех сервисов',
                        style: const TextStyle(
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

        // Right side - Auth Form
        Expanded(
          flex: 4,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Current app indicator with "Login/Register to [AppName]" format
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: Container(
                      key: ValueKey<bool>(_showLogin),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _showLogin ? 'Войти в' : 'Регистрация в',
                            style: const TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFFFFFFFF),
                                fontFamily: 'Montserrat'
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'blast!',
                            style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFFFFFFFF),
                                fontFamily: 'Montserrat'
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Toggle between QR and Form login (only for login mode)
                  AnimatedSizeAndFade(
                    show: _showLogin,
                    child: Row(
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
                            label: const Text('Пароль', style: TextStyle(color: Colors.white)),
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
                            label: const Text('QR-код', style: TextStyle(color: Colors.white)),
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
                  ),
                  const SizedBox(height: 30),

                  // Show either QR code, login form, or register form
                  Container(
                    constraints: const BoxConstraints(minHeight: 600), // Provide minimum height to prevent layout shifts
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 400),
                      switchInCurve: Curves.easeOutQuint,
                      switchOutCurve: Curves.easeInQuint,
                      transitionBuilder: (Widget child, Animation<double> animation) {
                        final inAnimation = Tween<Offset>(
                          begin: const Offset(0.05, 0),
                          end: Offset.zero,
                        ).animate(animation);

                        final outAnimation = Tween<Offset>(
                          begin: const Offset(-0.05, 0),
                          end: Offset.zero,
                        ).animate(animation);

                        if (child.key == ValueKey('login') || child.key == ValueKey('qrcode')) {
                          // Login form slides in from left
                          return ClipRect(
                            child: FadeTransition(
                              opacity: animation,
                              child: SlideTransition(
                                position: inAnimation,
                                child: child,
                              ),
                            ),
                          );
                        } else {
                          // Register form slides in from right
                          return ClipRect(
                            child: FadeTransition(
                              opacity: animation,
                              child: SlideTransition(
                                position: outAnimation,
                                child: child,
                              ),
                            ),
                          );
                        }
                      },
                      layoutBuilder: (Widget? currentChild, List<Widget> previousChildren) {
                        return Stack(
                          alignment: Alignment.topCenter,
                          children: <Widget>[
                            ...previousChildren,
                            if (currentChild != null) currentChild,
                          ],
                        );
                      },
                      child: _showLogin
                          ? (_showQrCode ? _buildQrCodeLogin() : _buildLoginForm())
                          : _buildRegistrationForm(),
                    ),
                  ),
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

            // Keep Pixel Logo
            Center(
              child: Image.asset(
                'assets/images/keeppixel_logo.png',
                height: 80,
              ),
            ),
            const SizedBox(height: 16),

            // Keep Pixel Text
            const Center(
              child: Text(
                'Keep Pixel',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // App indicator with "Login/Register to [AppName]" format
            Center(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Container(
                  key: ValueKey<bool>(_showLogin),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        _showLogin ? 'Войти в' : 'Регистрация в',
                        style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFFFFFFF),
                            fontFamily: 'Montserrat'
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'blast!',
                        style: TextStyle(
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
            ),
            const SizedBox(height: 24),

            // Toggle between QR and Form login (only for login mode)
            AnimatedSizeAndFade(
              show: _showLogin,
              child: Row(
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
                      label: const Text('Пароль', style: TextStyle(color: Colors.white)),
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
                      label: const Text('QR-код', style: TextStyle(color: Colors.white)),
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
            ),
            const SizedBox(height: 24),

            // Auth Form Card
            Card(
              color: const Color(0xFF191818),
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Container(
                  constraints: const BoxConstraints(minHeight: 500), // Provide minimum height for mobile
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    switchInCurve: Curves.easeOutQuint,
                    switchOutCurve: Curves.easeInQuint,
                    transitionBuilder: (Widget child, Animation<double> animation) {
                      final inAnimation = Tween<Offset>(
                        begin: const Offset(0.05, 0),
                        end: Offset.zero,
                      ).animate(animation);

                      final outAnimation = Tween<Offset>(
                        begin: const Offset(-0.05, 0),
                        end: Offset.zero,
                      ).animate(animation);

                      if (child.key == ValueKey('login') || child.key == ValueKey('qrcode')) {
                        // Login form slides in from left
                        return ClipRect(
                          child: FadeTransition(
                            opacity: animation,
                            child: SlideTransition(
                              position: inAnimation,
                              child: child,
                            ),
                          ),
                        );
                      } else {
                        // Register form slides in from right
                        return ClipRect(
                            child: FadeTransition(
                            opacity: animation,
                            child: SlideTransition(
                            position: outAnimation,
                            child: child,
                        ),
                      ));
                    }
                    },
                    layoutBuilder: (Widget? currentChild, List<Widget> previousChildren) {
                      return Stack(
                        alignment: Alignment.topCenter,
                        children: <Widget>[
                          ...previousChildren,
                          if (currentChild != null) currentChild,
                        ],
                      );
                    },
                    child: _showLogin
                        ? (_showQrCode ? _buildQrCodeLogin() : _buildLoginForm())
                        : _buildRegistrationForm(),
                  ),
                ),
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
      onTap: () {
        Navigator.pop(context);
      },
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
      key: const ValueKey('qrcode'),
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
          'Отсканируй с помощью Keep Pixel приложение',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.white.withOpacity(0.9),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Откройте приложение Keep Pixel на своем телефоне, перейдите в раздел «Сканировать QR-код» и наведите камеру на этот код, чтобы выполнить безопасный вход.',
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
      key: _loginFormKey,
      child: Column(
        key: const ValueKey('login'),
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
                if (_loginFormKey.currentState!.validate()) {
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
                onPressed: _toggleAuthMode,
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

  Widget _buildRegistrationForm() {
    return Form(
      key: _registerFormKey,
      child: Column(
        key: const ValueKey('register'),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Login Field
          TextFormField(
            controller: _loginController,
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
              hintText: 'Ваше приватное имя пользователя',
              hintStyle: TextStyle(
                color: Colors.white.withOpacity(0.3),
                fontSize: 12,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Пожалуйста, введите логин';
              }
              if (value.length < 3) {
                return 'Логин должен содержать не менее 3 символов';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Nick Field
          TextFormField(
            controller: _nickController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: 'Отображаемое имя',
              labelStyle: TextStyle(
                color: Colors.white.withOpacity(0.7),
              ),
              prefixIcon: const Icon(
                Icons.badge_outlined,
                color: Colors.white70,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white.withOpacity(0.1),
              hintText: 'Ваше публичное имя',
              hintStyle: TextStyle(
                color: Colors.white.withOpacity(0.3),
                fontSize: 12,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Пожалуйста, введите отображаемое имя';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Email Field
          TextFormField(
            controller: _registerEmailController,
            keyboardType: TextInputType.emailAddress,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: 'Email',
              labelStyle: TextStyle(
                color: Colors.white.withOpacity(0.7),
              ),
              prefixIcon: const Icon(
                Icons.email_outlined,
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
                return 'Пожалуйста, введите ваш email';
              }
              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                return 'Пожалуйста, введите корректный email';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Password Field
          TextFormField(
            controller: _registerPasswordController,
            obscureText: _obscureRegisterPassword,
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
                  _obscureRegisterPassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: Colors.white70,
                ),
                onPressed: () {
                  setState(() {
                    _obscureRegisterPassword = !_obscureRegisterPassword;
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
                return 'Пожалуйста, введите пароль';
              }
              if (value.length < 6) {
                return 'Пароль должен содержать не менее 6 символов';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Confirm Password Field
          TextFormField(
            controller: _confirmPasswordController,
            obscureText: _obscureConfirmPassword,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: 'Подтвердите пароль',
              labelStyle: TextStyle(
                color: Colors.white.withOpacity(0.7),
              ),
              prefixIcon: const Icon(
                Icons.lock_outline,
                color: Colors.white70,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureConfirmPassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: Colors.white70,
                ),
                onPressed: () {
                  setState(() {
                    _obscureConfirmPassword = !_obscureConfirmPassword;
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
                return 'Пожалуйста, подтвердите пароль';
              }
              if (value != _registerPasswordController.text) {
                return 'Пароли не совпадают';
              }
              return null;
            },
          ),

          // Terms and Conditions
          Row(
            children: [
              Checkbox(
                value: _agreeToTerms,
                onChanged: (value) {
                  setState(() {
                    _agreeToTerms = value ?? false;
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
              Expanded(
                child: Text(
                  'Я согласен с Условиями использования и Политикой конфиденциальности',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Remember Me for registration
          Row(
            children: [
              Checkbox(
                value: _registerRememberMe,
                onChanged: (value) {
                  setState(() {
                    _registerRememberMe = value ?? false;
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
          const SizedBox(height: 24),

          // Register Button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _agreeToTerms ? () {
                if (_registerFormKey.currentState!.validate()) {
                  register();
                }
              } : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6C63FF),
                disabledBackgroundColor: Colors.grey.shade700,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Создать аккаунт',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
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
                  'Или продолжить с',
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
                  // Handle Google registration
                },
              ),
              _buildSocialButton(
                icon: FontAwesomeIcons.yandex,
                color: Colors.red,
                onPressed: () {
                  // Handle Yandex registration
                },
              ),
              _buildSocialButton(
                icon: FontAwesomeIcons.vk,
                color: Colors.blue,
                onPressed: () {
                  // Handle VK registration
                },
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Login Instead
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Уже есть аккаунт?',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
              TextButton(
                onPressed: _toggleAuthMode,
                child: const Text(
                  'Войти',
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

// Update the AnimatedSizeAndFade widget to not use the parent's vsync
class AnimatedSizeAndFade extends StatefulWidget {
  final Widget child;
  final bool show;
  final Duration duration;

  const AnimatedSizeAndFade({
    Key? key,
    required this.child,
    required this.show,
    this.duration = const Duration(milliseconds: 300),
  }) : super(key: key);

  @override
  State<AnimatedSizeAndFade> createState() => _AnimatedSizeAndFadeState();
}

class _AnimatedSizeAndFadeState extends State<AnimatedSizeAndFade> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
      value: widget.show ? 1.0 : 0.0,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void didUpdateWidget(AnimatedSizeAndFade oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.show != oldWidget.show) {
      if (widget.show) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: _animation,
      axisAlignment: -1.0,
      child: FadeTransition(
        opacity: _animation,
        child: widget.child,
      ),
    );
  }
}

