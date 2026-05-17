// CustomPainter para el patrón de puntos geométricos
import 'dart:ui';

import 'package:chat_blockchain_app/theme.dart';
import 'package:flutter/material.dart';

class HeaderAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  /// Subtítulo opcional (por ejemplo, estado de conexión o dirección wallet)
  final String? subtitle;

  /// Widgets a la izquierda (normalmente el botón de navegación)
  final Widget? leading;

  /// Lista de acciones a la derecha (iconos de settings, wallet, etc.)
  final List<Widget>? actions;

  /// Si es `true`, muestra el indicador de seguridad debajo del título.
  /// Por defecto: true en pantallas de chat, false en otras vistas.
  final bool showSecurityIndicator;

  /// Nivel de seguridad / sincronización para mostrar en el indicador.
  /// Ejemplos: '🟢 Encriptado AES-256', '🟡 Sincronizando', '🔴 Sin conexión'.
  final String securityStatus;

  /// Color del indicador (opcional, se calcula automáticamente según el estado
  /// si no se provee).
  final Color? securityColor;

  /// Altura total del AppBar (incluyendo el indicador si se muestra).
  @override
  final Size preferredSize;

  HeaderAppBar({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.actions,
    this.showSecurityIndicator = false,
    this.securityStatus = '🟢 Cifrado activo',
    this.securityColor,
  }) : preferredSize = Size.fromHeight(
    showSecurityIndicator ? kToolbarHeight + 32.0 : kToolbarHeight,
  );

  @override
  Widget build(BuildContext context) {

    // Determinar color del indicador si no se especifica
    Color indicatorColor = securityColor ?? _getSecurityColor(securityStatus);

    return AppBar(
      backgroundColor: Color(0xFF020617),
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleSpacing: 0, // Lo controlamos manualmente para mejor integración
      leading: leading,
      actions: actions,
      flexibleSpace: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            decoration: BoxDecoration(
              // Usamos el color del panel glass (nivel 1) con opacidad
              color: AppColors.surfaceContainerHighest.withOpacity(0.8),
              border: Border(
                bottom: BorderSide(
                  color: AppColors.outlineVariant.withOpacity(0.5),
                  width: 0.5,
                ),
              ),
            ),
          ),
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
          color: AppColors.primary,
        ),
      ),
      // Si se requiere el indicador de seguridad, lo agregamos debajo del título
      bottom: showSecurityIndicator
        ? PreferredSize(
            preferredSize: Size.fromHeight(32.0),
            child: _SecurityIndicator(
              status: securityStatus,
              color: indicatorColor,
            ),
          )
        : null,
    );
  }

  /// Lógica simple para asignar colores según el texto de estado.
  Color _getSecurityColor(String status) {
    if (status.contains('Cifrado') || status.contains('Encriptado')) {
      return AppColors.tertiary; // Verde/teal para seguro
    } else if (status.contains('Sincronizando') || status.contains('Conectando')) {
      return AppColors.primary; // Azul para proceso
    } else if (status.contains('Sin conexión') || status.contains('Error')) {
      return AppColors.error; // Rojo para peligro
    } else {
      return AppColors.neonAccentIndigo; // Neutro
    }
  }
}

// Widget interno para el indicador de seguridad persistente
class _SecurityIndicator extends StatelessWidget {
  final String status;
  final Color color;

  const _SecurityIndicator({required this.status, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
      decoration: BoxDecoration(
        // Fondo sutilmente más oscuro para diferenciar del AppBar
        color: AppColors.surfaceContainerLow.withOpacity(0.9),
        border: Border(
          bottom: BorderSide(
            color: AppColors.outlineVariant.withOpacity(0.3),
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          // Pequeña luz LED animada (opcional)
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.6),
                  blurRadius: 4,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
          SizedBox(width: AppSpacing.sm),
          // Texto del estado
          Expanded(
            child: Text(
              status,
              style: AppTypography.labelCaps.copyWith(
                fontSize: 11,
                letterSpacing: 0.3,
                color: AppColors.onSurfaceVariant,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // Posible ícono de blockchain (opcional)
          Icon(
            Icons.link_rounded,
            size: 14,
            color: AppColors.onSurfaceVariant,
          ),
        ],
      ),
    );
  }
}