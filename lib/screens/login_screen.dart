import 'package:chat_blockchain_app/providers/auth_provider.dart';
import 'package:chat_blockchain_app/services/wallet_service.dart';
import 'package:chat_blockchain_app/theme.dart';
import 'package:chat_blockchain_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:chat_blockchain_app/providers/chat_provider.dart';
import 'package:chat_blockchain_app/screens/contacts_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // final _controller = TextEditingController();
  bool _loading = false;
  final walletService = WalletService();

  // Future<void> _login() async {
  //   setState(() => _loading = true);
  //   try {
  //     final provider = Provider.of<AuthProvider>(context, listen: false);
  //     // await provider.authenticate(_controller.text.trim());
  //     Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => ContactsScreen()));
  //   } catch (e) {
  //     print('Login error: $e');
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
  //   } finally {
  //     setState(() => _loading = false);
  //   }
  // }

  Future<void> _crearWallet() async {
    setState(() => _loading = true);
    try {
      final provider = Provider.of<AuthProvider>(context, listen: false);
      final address = await walletService.createNewWallet();
      await provider.loginWithWalletService(address);

    } catch (e) {
      print('Login error: $e');
      setState(() {
        _loading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<String?> showPrivateKeyDialog(BuildContext context) {
    final controller = TextEditingController();
    return showDialog<String>(
      context: context,
      barrierDismissible: false, // obliga a usar botones
      builder: (context) => AlertDialog(
        // Fondo glassmorphism (nivel 2)
        backgroundColor: Colors.transparent,
        elevation: 0,
        contentPadding: EdgeInsets.zero,
        content: Container(
          width: MediaQuery.of(context).size.width * 0.85,
          constraints: BoxConstraints(maxWidth: 400),
          decoration: context.customTokens.glassCard,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header: título e ícono
              Padding(
                padding: EdgeInsets.all(AppSpacing.lg),
                child: Row(
                  children: [
                    Icon(Icons.vpn_key_rounded, color: AppColors.primary),
                    SizedBox(width: AppSpacing.sm),
                    Text(
                      'Ingresar llave privada',
                      style: AppTypography.h3.copyWith(fontSize: 20),
                    ),
                  ],
                ),
              ),
              Divider(height: 1, color: AppColors.outlineVariant),
              // Campo de texto (con máscara opcional)
              Padding(
                padding: EdgeInsets.all(AppSpacing.lg),
                child: TextField(
                  controller: controller,
                  obscureText: true,
                  style: AppTypography.monoData,
                  decoration: InputDecoration(
                    labelText: 'Llave privada',
                    prefixIcon: Icon(Icons.lock_outline),
                  ),
                  autofocus: true,
                ),
              ),
              // Botones de acción
              Padding(
                padding: EdgeInsets.all(AppSpacing.lg),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Cancelar'),
                    ),
                    SizedBox(width: AppSpacing.md),
                    ElevatedButton(
                      onPressed: () {
                        final key = controller.text.trim();
                        if (key.isNotEmpty) {
                          Navigator.pop(context, key);
                        } else {
                          // Mostrar snackbar o error visual
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('La llave no puede estar vacía')),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryContainer,
                      ),
                      child: Text('Conectar'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        // Si ya hay sesión activa, redirige después del build
        if (authProvider.isLoggedIn) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => ContactsScreen()),
              );
            }
          });
        }

        return Scaffold(
          backgroundColor: Colors.transparent,
          appBar: HeaderAppBar(
            leading: Icon(
              Icons.security,
              color: const Color(0xFF8ED5FF),
              size: 28,
            ),
            title: 'Web3Message', 
            actions: [
              IconButton(
                icon: const Icon(Icons.help_outline, color: AppColors.onSurfaceVariant),
                onPressed: () {},
                splashRadius: 24,
              ),
            ],
          ),
          body: Container(
            decoration: CustomDesignTokens.defaultDark().backgroundBoxDecoration,
            child: CardWidget(
              child: Container(
                margin: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
                width: double.infinity,
                height: double.infinity,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      Text('Bienvenido a Web3Message'),
                      SizedBox(height: 10),
                      Text('Envia mensajes de forma segura, con identidad blockchain'),
                      SizedBox(height: 20),
                      _WalletProviderCard(
                        name: "Crear Wallet",
                        color: Colors.blue,
                        icon: Icons.vpn_key,
                        onPressed: _crearWallet,
                      ),
                      SizedBox(height: 20),
                      ElevatedButtonCustom(
                        onPressed: () async {
                          final String? privateKey = await showPrivateKeyDialog(context);
                          if (privateKey != null && privateKey.isNotEmpty) {
                            // Aquí procesas la llave (validar formato, conectar wallet, etc.)
                            print('Llave ingresada: $privateKey');
                            // Ejemplo: navegar a la pantalla principal
                            // Navigator.pushReplacement(context, MaterialPageRoute(...));
                          }
                        }, 
                        child: Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.account_balance_wallet),
                              SizedBox(width: 10),
                              Text('Ingresar tu llave privada'),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      GlassCardWidget(
                        child: Row(
                          children: [
                            SizedBox(width: 10,),
                            Icon(Icons.security, color: AppColors.primary, size: 30.0,),
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Encriptación End-to-End', style: AppTypography.h4),
                                    Text('Tus mensajes están encriptados antes de salir de tu dispositivo.', style: AppTypography.bodyMd, textAlign: TextAlign.justify,),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      GlassCardWidget(
                        child: Row(
                          children: [
                            SizedBox(width: 10,),
                            Icon(Icons.storage, color: AppColors.primary, size: 30.0,),
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Almacenamiento local seguro', style: AppTypography.h4),
                                    Text('Los datos nuca se almacenaran en nuestros servidores.', style: AppTypography.bodyMd, textAlign: TextAlign.justify,),
                                  ],
                                ),
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
          ),
        );
      },
    );
  }
}

class _WalletProviderCard extends StatelessWidget {
  final String name;
  final Color color;
  final IconData icon;
  final VoidCallback? onPressed;

  const _WalletProviderCard({
    required this.name,
    required this.color,
    required this.icon,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: 120,
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
