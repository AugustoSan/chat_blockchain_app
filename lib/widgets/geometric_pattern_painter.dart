// CustomPainter para el patrón de puntos geométricos
import 'package:flutter/material.dart';

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