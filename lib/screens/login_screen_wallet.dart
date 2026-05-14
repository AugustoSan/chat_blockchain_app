// lib/screens/login_screen.dart
import 'dart:ui';
import 'package:chat_blockchain_app/providers/reown_provider.dart';
import 'package:chat_blockchain_app/screens/contacts_screen.dart';
// import 'package:chat_blockchain_app/services/wallet_connect_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reown_appkit/reown_appkit.dart';

class LoginScreenWallet extends StatefulWidget {
  const LoginScreenWallet({super.key});

  @override
  State<LoginScreenWallet> createState() => _LoginScreenWalletState();
}

class _LoginScreenWalletState extends State<LoginScreenWallet> {

  ReownProvider? _reownProvider; // Referencia local

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      // 2. Asignamos a la variable nullable primero
      _reownProvider = Provider.of<ReownProvider>(context, listen: false);
      
      // 3. Agregamos el listener usando el operador ?.
      _reownProvider?.addListener(_handleNavigation);

      // 4. Llamamos a init (ya no necesitamos pasar context si el provider lo maneja)
      _init();
    });
  }
  void _init() async {
    // Verificamos si es nulo antes de usarlo
    if (_reownProvider != null && _reownProvider!.appKitModal == null) {
      await _reownProvider!.initAppKitModal(context);
    }

    if (mounted) {
      setState(() {});
    }
  }

  void _handleNavigation() {
    // 5. Verificamos conexión de forma segura
    if (_reownProvider?.appKitModal?.isConnected ?? false) {
      if (mounted) {
        // Removemos el listener antes de navegar
        _reownProvider?.removeListener(_handleNavigation);
        
        Navigator.pushReplacement(
          context, 
          MaterialPageRoute(builder: (_) => ContactsScreen())
        );
      }
    }
  }

  @override
  void dispose() {
    // 6. Limpieza segura: si es nulo, no hace nada; si existe, quita el listener
    _reownProvider?.removeListener(_handleNavigation);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appKitModal = _reownProvider?.appKitModal;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF020617), // Fondo base
              Color(0xFF0F1418),
            ],
          ),
        ),
        child: Stack(
          children: [
            // Patrón geométrico de fondo (puntos)
            Positioned.fill(
              child: CustomPaint(
                painter: GeometricPatternPainter(),
              ),
            ),
            // Efectos de desenfoque/bloom en las esquinas
            Positioned(
              top: MediaQuery.of(context).size.height * 0.2,
              left: -100,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  color: const Color(0xFF8ED5FF).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(150),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF8ED5FF).withOpacity(0.3),
                      blurRadius: 120,
                      spreadRadius: 50,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: MediaQuery.of(context).size.height * 0.2,
              right: -100,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  color: const Color(0xFF45E3CE).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(150),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF45E3CE).withOpacity(0.2),
                      blurRadius: 120,
                      spreadRadius: 50,
                    ),
                  ],
                ),
              ),
            ),
            // Barra superior (AppBar personalizada)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      Icon(
                        Icons.security,
                        color: const Color(0xFF8ED5FF),
                        size: 28,
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'CipherChat',
                        style: TextStyle(
                          fontFamily: 'SpaceGrotesk',
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.5,
                          color: Color(0xFF8ED5FF),
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.help_outline, color: Color(0xFFBDC8D1)),
                        onPressed: () {},
                        splashRadius: 24,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Contenido principal centrado
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 80),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Panel Glassmórfico
                    Container(
                      constraints: const BoxConstraints(maxWidth: 450),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E293B).withOpacity(0.8),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: const Color(0xFF38BDF8).withOpacity(0.1),
                          width: 1,
                        ),
                      ),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                        child: Padding(
                          padding: const EdgeInsets.all(32),
                          child: Column(
                            children: [
                              // Badge de seguridad
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF38BDF8).withOpacity(0.05),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: const Color(0xFF38BDF8).withOpacity(0.2),
                                    width: 1,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.vpn_key,
                                  color: Color(0xFF8ED5FF),
                                  size: 48,
                                ),
                              ),
                              const SizedBox(height: 24),
                              const Text(
                                'Welcome Back',
                                style: TextStyle(
                                  fontFamily: 'SpaceGrotesk',
                                  fontSize: 32,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFFDEE3E8),
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Connect your secure wallet to access your encrypted conversations and assets.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 16,
                                  color: Color(0xFFBDC8D1),
                                ),
                              ),
                              const SizedBox(height: 32),
                              // Botón principal Connect Wallet
                              ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  padding: const EdgeInsets.symmetric(vertical: 18),
                                  minimumSize: const Size(double.infinity, 56),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ).copyWith(
                                  foregroundColor: MaterialStateProperty.all(
                                    const Color(0xFF00354A),
                                  ),
                                  textStyle: MaterialStateProperty.all(
                                    const TextStyle(
                                      fontFamily: 'SpaceGrotesk',
                                      fontSize: 24,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                child: Ink(
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [Color(0xFF8ED5FF), Color(0xFF45E3CE)],
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: const Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.account_balance_wallet),
                                        SizedBox(width: 8),
                                        Text('Connect Wallet'),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 32),
                              // Grid de wallets
                              appKitModal != null ? AppKitModalConnectButton(appKit: appKitModal, size: BaseButtonSize.big,) : Text('Cargando...'),
                              SizedBox(width: 16),
                              appKitModal != null ? Visibility(
                                visible: appKitModal.isConnected,
                                child: AppKitModalAccountButton(appKitModal: appKitModal),
                              )
                              : Text('Cargando...'),
                              const SizedBox(height: 40),
                              // Tarjetas de características de seguridad
                              const _SecurityFeatureCard(
                                icon: Icons.change_circle,
                                title: 'End-to-End Encryption',
                                description: 'Your messages are encrypted before they leave your device.',
                              ),
                              const SizedBox(height: 12),
                              const _SecurityFeatureCard(
                                icon: Icons.storage,
                                title: 'Secure Local Storage',
                                description: 'Private keys and data are never stored on our servers.',
                              ),
                              const SizedBox(height: 24),
                              // Estado de red
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF1E293B).withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(40),
                                  border: Border.all(color: const Color(0xFF334155)),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFF45E3CE),
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Color(0xFF45E3CE),
                                            blurRadius: 8,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    const Text(
                                      'NETWORK PROTOCOL: MAINNET-ALPHA',
                                      style: TextStyle(
                                        fontFamily: 'monospace',
                                        fontSize: 10,
                                        letterSpacing: 1.2,
                                        color: Color(0xFF94A3B8),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Footer de enlaces
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _FooterLink(label: 'Privacy Policy'),
                        SizedBox(width: 24),
                        _FooterLink(label: 'Terms of Service'),
                        SizedBox(width: 24),
                        _FooterLink(label: 'Security Audit'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Componente para cada proveedor de wallet
class _WalletProviderCard extends StatelessWidget {
  final String name;
  final Color color;
  final IconData icon;

  const _WalletProviderCard({
    required this.name,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF1B2024),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF3E484F)),
        ),
        child: Column(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 12),
            Text(
              name,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.6,
                color: Color(0xFFBDC8D1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Componente para tarjetas de características
class _SecurityFeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _SecurityFeatureCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF171C20).withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF38BDF8).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: const Color(0xFF8ED5FF), size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.6,
                    color: Color(0xFFDEE3E8),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 11,
                    color: Color(0xFFBDC8D1),
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Componente para enlaces del footer
class _FooterLink extends StatelessWidget {
  final String label;

  const _FooterLink({required this.label});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {},
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.6,
          color: Color(0xFF64748B),
        ),
      ),
    );
  }
}

// CustomPainter para el patrón de puntos geométricos
class GeometricPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF38BDF8).withOpacity(0.05)
      ..style = PaintingStyle.fill;
    const spacing = 40.0;
    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), 1, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Theme global opcional (para usar en main.dart)
ThemeData cipherChatTheme() {
  return ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    scaffoldBackgroundColor: Colors.transparent,
    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xFF8ED5FF),
      onPrimary: Color(0xFF00354A),
      primaryContainer: Color(0xFF38BDF8),
      onPrimaryContainer: Color(0xFF004965),
      secondary: Color(0xFFBEC6E0),
      onSecondary: Color(0xFF283044),
      secondaryContainer: Color(0xFF3F465C),
      onSecondaryContainer: Color(0xFFADB4CE),
      tertiary: Color(0xFF45E3CE),
      onTertiary: Color(0xFF003731),
      tertiaryContainer: Color(0xFF07C7B2),
      onTertiaryContainer: Color(0xFF004D44),
      error: Color(0xFFFFB4AB),
      onError: Color(0xFF690005),
      errorContainer: Color(0xFF93000A),
      onErrorContainer: Color(0xFFFFDAD6),
      surface: Color(0xFF0F1418),
      onSurface: Color(0xFFDEE3E8),
      surfaceVariant: Color(0xFF303539),
      onSurfaceVariant: Color(0xFFBDC8D1),
      outline: Color(0xFF87929A),
      outlineVariant: Color(0xFF3E484F),
      inverseSurface: Color(0xFFDEE3E8),
      onInverseSurface: Color(0xFF2C3135),
      inversePrimary: Color(0xFF00668A),
    ),
    fontFamily: 'Inter',
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontFamily: 'SpaceGrotesk', fontSize: 40, fontWeight: FontWeight.w700, letterSpacing: -0.8),
      displayMedium: TextStyle(fontFamily: 'SpaceGrotesk', fontSize: 32, fontWeight: FontWeight.w600),
      displaySmall: TextStyle(fontFamily: 'SpaceGrotesk', fontSize: 24, fontWeight: FontWeight.w500),
      bodyLarge: TextStyle(fontSize: 18, height: 1.6),
      bodyMedium: TextStyle(fontSize: 16, height: 1.5),
      labelLarge: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 0.6),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: const Color(0xFF8ED5FF),
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
      ),
    ),
  );
}