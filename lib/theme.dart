// theme.dart
import 'package:flutter/material.dart';

// ---------------------------------------------------------------------
// 1. PALETA DE COLORES (según DESIGN.md)
// ---------------------------------------------------------------------
class AppColors {
  // Superficies y fondo
  static const Color background = Color(0xFF0f1418);
  static const Color surface = Color(0xFF0f1418);
  static const Color surfaceDim = Color(0xFF0f1418);
  static const Color surfaceBright = Color(0xFF343a3e);
  static const Color surfaceContainerLowest = Color(0xFF0a0f12);
  static const Color surfaceContainerLow = Color(0xFF171c20);
  static const Color surfaceContainer = Color(0xFF1b2024);
  static const Color surfaceContainerHigh = Color(0xFF252b2e);
  static const Color surfaceContainerHighest = Color(0xFF303539);
  static const Color onSurface = Color(0xFFdee3e8);
  static const Color onSurfaceVariant = Color(0xFFbdc8d1);
  static const Color inverseSurface = Color(0xFFdee3e8);
  static const Color inverseOnSurface = Color(0xFF2c3135);
  static const Color outline = Color(0xFF87929a);
  static const Color outlineVariant = Color(0xFF3e484f);
  static const Color surfaceTint = Color(0xFF7bd0ff);

  // Primarios
  static const Color primary = Color(0xFF8ed5ff);
  static const Color onPrimary = Color(0xFF00354a);
  static const Color primaryContainer = Color(0xFF38bdf8);
  static const Color onPrimaryContainer = Color(0xFF004965);
  static const Color inversePrimary = Color(0xFF00668a);
  static const Color primaryFixed = Color(0xFFc4e7ff);
  static const Color primaryFixedDim = Color(0xFF7bd0ff);
  static const Color onPrimaryFixed = Color(0xFF001e2c);
  static const Color onPrimaryFixedVariant = Color(0xFF004c69);

  // Secundarios
  static const Color secondary = Color(0xFFbec6e0);
  static const Color onSecondary = Color(0xFF283044);
  static const Color secondaryContainer = Color(0xFF3f465c);
  static const Color onSecondaryContainer = Color(0xFFadb4ce);
  static const Color secondaryFixed = Color(0xFFdae2fd);
  static const Color secondaryFixedDim = Color(0xFFbec6e0);
  static const Color onSecondaryFixed = Color(0xFF131b2e);
  static const Color onSecondaryFixedVariant = Color(0xFF3f465c);

  // Terciarios (éxito, blockchain)
  static const Color tertiary = Color(0xFF45e3ce);
  static const Color onTertiary = Color(0xFF003731);
  static const Color tertiaryContainer = Color(0xFF07c7b2);
  static const Color onTertiaryContainer = Color(0xFF004d44);
  static const Color tertiaryFixed = Color(0xFF62fae3);
  static const Color tertiaryFixedDim = Color(0xFF3cddc7);
  static const Color onTertiaryFixed = Color(0xFF00201c);
  static const Color onTertiaryFixedVariant = Color(0xFF005047);

  // Errores
  static const Color error = Color(0xFFffb4ab);
  static const Color onError = Color(0xFF690005);
  static const Color errorContainer = Color(0xFF93000a);
  static const Color onErrorContainer = Color(0xFFffdad6);

  // Neutrales adicionales (glows, etc)
  static const Color neonGlow = Color(0xFF38bdf8);
  static const Color neonAccentIndigo = Color(0xFF7c3aed); // para pips
}

// ---------------------------------------------------------------------
// 2. TIPOGRAFÍA (Space Grotesk, Inter, mono)
// ---------------------------------------------------------------------
class AppTypography {
  static const String spaceGrotesk = 'SpaceGrotesk';
  static const String inter = 'Inter';
  static const String mono = 'monospace';

  static TextStyle get h1 => const TextStyle(
        fontSize: 40,
        fontWeight: FontWeight.w700,
        height: 1.2,
        letterSpacing: -0.02,
        color: AppColors.onSurface,
      );

  static TextStyle get h2 => const TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        height: 1.2,
        color: AppColors.onSurface,
      );

  static TextStyle get h3 => const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w500,
        height: 1.3,
        color: AppColors.onSurface,
      );

   static TextStyle get h4 => const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        height: 1.4,
        color: AppColors.onSurface,
      );

  static TextStyle get bodyLg => const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w400,
        height: 1.6,
        color: AppColors.onSurface,
      );

  static TextStyle get bodyMd => const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: AppColors.onSurface,
        
      );

  static TextStyle get labelCaps => const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        height: 1.0,
        letterSpacing: 0.05,
        color: AppColors.onSurfaceVariant,
      );

  static TextStyle get monoData => const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.4,
        color: AppColors.onSurface,
      );
}

// ---------------------------------------------------------------------
// 3. RADIOS Y ESPACIOS (constantes)
// ---------------------------------------------------------------------
class AppRadii {
  static const double sm = 4.0;       // 0.25rem
  static const double md = 8.0;       // 0.5rem
  static const double lg = 12.0;      // 0.75rem
  static const double xl = 16.0;      // 1rem
  static const double xxl = 24.0;     // 1.5rem
  static const double full = 100.0;   // circular
}

class AppSpacing {
  static const double xs = 8.0;    // 0.5rem
  static const double sm = 12.0;   // 0.75rem
  static const double md = 16.0;   // 1rem
  static const double lg = 24.0;   // 1.5rem
  static const double xl = 32.0;   // 2rem
  static const double gutter = 16.0;
  static const double marginMobile = 16.0;
  static const double marginDesktop = 40.0;
  static const double base = 4.0;
}

// ---------------------------------------------------------------------
// 4. EXTENSIÓN DE TEMA PERSONALIZADA (Glassmorphism, burbujas, etc)
// ---------------------------------------------------------------------
class CustomDesignTokens extends ThemeExtension<CustomDesignTokens> {
  final BoxDecoration glassPanel;        // nivel 1: panel con blur
  final BoxDecoration glassCard;         // nivel 2: modal / popover
  final BoxDecoration messageBubbleUser;
  final BoxDecoration messageBubbleOther;
  final BoxShadow softNeonGlow;
  final BoxDecoration backgroundBoxDecoration;

  CustomDesignTokens({
    required this.glassPanel,
    required this.glassCard,
    required this.messageBubbleUser,
    required this.messageBubbleOther,
    required this.softNeonGlow,
    required this.backgroundBoxDecoration,
  });

  factory CustomDesignTokens.defaultLight() {
    // Para mantener coherencia, pero la app es sólo dark. Igual definimos.
    return CustomDesignTokens.defaultDark();
  }

  factory CustomDesignTokens.defaultDark() {
    // Glass panel nivel 1 (fondo semitransparente, blur)
    final glassPanelDecoration = BoxDecoration(
      color: AppColors.surfaceContainerHighest.withOpacity(0.8),
      borderRadius: BorderRadius.circular(AppRadii.lg),
      border: Border.all(
        color: AppColors.outlineVariant.withOpacity(0.5),
        width: 0.5,
      ),
    );
    // Glass card nivel 2 (más contraste, borde primario tenue)
    final glassCardDecoration = BoxDecoration(
      color: AppColors.surfaceContainerHigh.withOpacity(0.9),
      borderRadius: BorderRadius.circular(AppRadii.xl),
      border: Border.all(
        color: AppColors.primary.withOpacity(0.3),
        width: 1.0,
      ),
    );
    // Burbuja del usuario (primario)
    final userBubble = BoxDecoration(
      color: AppColors.primaryContainer,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(AppRadii.lg),
        topRight: Radius.circular(AppRadii.lg),
        bottomLeft: Radius.circular(AppRadii.sm),
        bottomRight: Radius.circular(AppRadii.lg),
      ),
    );
    // Burbuja del otro (superficie)
    final otherBubble = BoxDecoration(
      color: AppColors.surfaceContainerHighest,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(AppRadii.lg),
        topRight: Radius.circular(AppRadii.lg),
        bottomLeft: Radius.circular(AppRadii.lg),
        bottomRight: Radius.circular(AppRadii.sm),
      ),
    );
    // Sombra difuminada con tinte neon (para FAB)
    final neonShadow = BoxShadow(
      color: AppColors.neonGlow.withOpacity(0.15),
      blurRadius: 20,
      spreadRadius: 4,
      offset: Offset(0, 4),
    );
    // Fondo de la aplicación
    final backgroundBoxDecoration = BoxDecoration(
      gradient: const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF020617),
          Color(0xFF0F1418)
        ]
      )
    );

    return CustomDesignTokens(
      glassPanel: glassPanelDecoration,
      glassCard: glassCardDecoration,
      messageBubbleUser: userBubble,
      messageBubbleOther: otherBubble,
      softNeonGlow: neonShadow,
      backgroundBoxDecoration: backgroundBoxDecoration,
    );
  }

  @override
  ThemeExtension<CustomDesignTokens> copyWith({
    BoxDecoration? glassPanel,
    BoxDecoration? glassCard,
    BoxDecoration? messageBubbleUser,
    BoxDecoration? messageBubbleOther,
    BoxShadow? softNeonGlow,
  }) {
    return CustomDesignTokens(
      glassPanel: glassPanel ?? this.glassPanel,
      glassCard: glassCard ?? this.glassCard,
      messageBubbleUser: messageBubbleUser ?? this.messageBubbleUser,
      messageBubbleOther: messageBubbleOther ?? this.messageBubbleOther,
      softNeonGlow: softNeonGlow ?? this.softNeonGlow,
      backgroundBoxDecoration: backgroundBoxDecoration ?? this.backgroundBoxDecoration,
    );
  }

  @override
  ThemeExtension<CustomDesignTokens> lerp(
      covariant ThemeExtension<CustomDesignTokens>? other, double t) {
    if (other is! CustomDesignTokens) return this;
    return CustomDesignTokens(
      glassPanel: BoxDecoration.lerp(glassPanel, other.glassPanel, t)!,
      glassCard: BoxDecoration.lerp(glassCard, other.glassCard, t)!,
      messageBubbleUser:
          BoxDecoration.lerp(messageBubbleUser, other.messageBubbleUser, t)!,
      messageBubbleOther:
          BoxDecoration.lerp(messageBubbleOther, other.messageBubbleOther, t)!,
      softNeonGlow: BoxShadow.lerp(softNeonGlow, other.softNeonGlow, t)!,
      backgroundBoxDecoration: BoxDecoration.lerp(backgroundBoxDecoration, other.backgroundBoxDecoration, t)!,
    );
  }
}

// ---------------------------------------------------------------------
// 5. TEMA OSCURO PRINCIPAL (ThemeData)
// ---------------------------------------------------------------------
ThemeData appDarkTheme() {
  final colorScheme = const ColorScheme.dark(
    brightness: Brightness.dark,
    primary: AppColors.primary,
    onPrimary: AppColors.onPrimary,
    primaryContainer: AppColors.primaryContainer,
    onPrimaryContainer: AppColors.onPrimaryContainer,
    secondary: AppColors.secondary,
    onSecondary: AppColors.onSecondary,
    secondaryContainer: AppColors.secondaryContainer,
    onSecondaryContainer: AppColors.onSecondaryContainer,
    tertiary: AppColors.tertiary,
    onTertiary: AppColors.onTertiary,
    tertiaryContainer: AppColors.tertiaryContainer,
    onTertiaryContainer: AppColors.onTertiaryContainer,
    error: AppColors.error,
    onError: AppColors.onError,
    errorContainer: AppColors.errorContainer,
    onErrorContainer: AppColors.onErrorContainer,
    surface: AppColors.surface,
    onSurface: AppColors.onSurface,
    surfaceContainerHighest: AppColors.surfaceContainerHighest,
    outline: AppColors.outline,
    outlineVariant: AppColors.outlineVariant,
    inverseSurface: AppColors.inverseSurface,
    onInverseSurface: AppColors.inverseOnSurface,
  ).copyWith(
    surfaceTint: AppColors.surfaceTint,
    surfaceDim: AppColors.surfaceDim,
    surfaceBright: AppColors.surfaceBright,
    surfaceContainerLowest: AppColors.surfaceContainerLowest,
    surfaceContainerLow: AppColors.surfaceContainerLow,
    surfaceContainer: AppColors.surfaceContainer,
    surfaceContainerHigh: AppColors.surfaceContainerHigh,
  );

  // TextTheme basado en AppTypography
  final textTheme = TextTheme(
    displayLarge: AppTypography.h1,
    displayMedium: AppTypography.h2,
    displaySmall: AppTypography.h3,
    bodyLarge: AppTypography.bodyLg,
    bodyMedium: AppTypography.bodyMd,
    labelSmall: AppTypography.labelCaps,
    labelMedium: AppTypography.labelCaps,
    bodySmall: AppTypography.monoData,
  );

  // Estilo para botón primario con gradiente (sky blue -> tertiary)
  final elevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: AppColors.onPrimary,
      backgroundColor: Colors.transparent,
      elevation: 0,
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadii.md)),
      textStyle: AppTypography.labelCaps.copyWith(fontWeight: FontWeight.w700),
    ).copyWith(
      backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.transparent),
      overlayColor: MaterialStateProperty.resolveWith((states) => AppColors.primary.withOpacity(0.1)),
      shadowColor: MaterialStateProperty.all(Colors.transparent),
    ),
  );

  // Botón secundario "outline-glass"
  final outlinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: AppColors.primary,
      side: BorderSide(color: AppColors.primary, width: 1.0),
      backgroundColor: Colors.transparent,
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadii.md)),
      textStyle: AppTypography.labelCaps,
    ).copyWith(
      overlayColor: MaterialStateProperty.resolveWith((states) => AppColors.primary.withOpacity(0.05)),
    ),
  );

  // Tema para InputDecoration (campos oscuros, borde, glow en focus)
  final inputDecorationTheme = InputDecorationTheme(
    filled: true,
    fillColor: AppColors.surfaceContainerLowest,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadii.md),
      borderSide: BorderSide(color: AppColors.outlineVariant),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadii.md),
      borderSide: BorderSide(color: AppColors.outlineVariant),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadii.md),
      borderSide: BorderSide(color: AppColors.primary, width: 1.5),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadii.md),
      borderSide: BorderSide(color: AppColors.error, width: 1.5),
    ),
    labelStyle: AppTypography.labelCaps,
    hintStyle: AppTypography.bodyMd.copyWith(color: AppColors.onSurfaceVariant),
    contentPadding: EdgeInsets.all(AppSpacing.md),
  );

  // Tema para chips (estilo "pill", neon glow)
  final chipTheme = ChipThemeData(
    backgroundColor: AppColors.surfaceContainerHighest,
    disabledColor: AppColors.outlineVariant,
    selectedColor: AppColors.primaryContainer,
    secondarySelectedColor: AppColors.tertiaryContainer,
    padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
    labelStyle: AppTypography.labelCaps.copyWith(color: AppColors.onSurface),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadii.full)),
    side: BorderSide.none,
    elevation: 0,
    shadowColor: AppColors.neonGlow.withOpacity(0.2),
  );

  // FAB con sombra neon
  final floatingActionButtonTheme = FloatingActionButtonThemeData(
    backgroundColor: AppColors.primaryContainer,
    foregroundColor: AppColors.onPrimaryContainer,
    elevation: 0.0,
    highlightElevation: 0.0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadii.lg)),
    extendedTextStyle: AppTypography.labelCaps,
  );

  // Card theme: sin sombra pesada, borde sutil y fondo semitransparente
  final cardTheme = CardThemeData(
    color: AppColors.surfaceContainerHigh.withOpacity(0.9),
    elevation: 0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadii.lg)),
    margin: EdgeInsets.all(AppSpacing.sm),
    clipBehavior: Clip.antiAlias,
  );

  // Tema general para AppBar (sin sombra, integración con glassmorphism)
  final appBarTheme = AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
    scrolledUnderElevation: 0,
    centerTitle: false,
    titleTextStyle: AppTypography.h3.copyWith(fontSize: 22),
    iconTheme: IconThemeData(color: AppColors.onSurface),
  );

  final bottomSheetTheme = BottomSheetThemeData(
    backgroundColor: AppColors.surfaceContainerHighest,
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadii.xl)),
    ),
    clipBehavior: Clip.antiAlias,
  );

  final dialogTheme = DialogThemeData(
    backgroundColor: AppColors.surfaceContainerHighest,
    elevation: 0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadii.xl)),
  );

  // Construimos ThemeData final
  final theme = ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    colorScheme: colorScheme,
    textTheme: textTheme,
    primaryTextTheme: textTheme,
    appBarTheme: appBarTheme,
    elevatedButtonTheme: elevatedButtonTheme,
    outlinedButtonTheme: outlinedButtonTheme,
    inputDecorationTheme: inputDecorationTheme,
    chipTheme: chipTheme,
    cardTheme: cardTheme,
    floatingActionButtonTheme: floatingActionButtonTheme,
    bottomSheetTheme: bottomSheetTheme,
    dialogTheme: dialogTheme,
    scaffoldBackgroundColor: AppColors.background,
    dividerTheme: DividerThemeData(
      color: AppColors.outlineVariant,
      thickness: 0.5,
      space: 0,
    ),
    iconTheme: IconThemeData(color: AppColors.onSurfaceVariant, size: 20),
    fontFamily: AppTypography.inter, // fallback
  );

  // Agregamos la extensión personalizada (CustomDesignTokens)
  return theme.copyWith(
    extensions: [CustomDesignTokens.defaultDark()],
  );
}

// ---------------------------------------------------------------------
// 6. UTILIDADES PARA ACCEDER A LOS TOKENS PERSONALIZADOS FÁCILMENTE
// ---------------------------------------------------------------------
extension CustomThemeExtensions on BuildContext {
  CustomDesignTokens get customTokens =>
      Theme.of(this).extension<CustomDesignTokens>()!;
}