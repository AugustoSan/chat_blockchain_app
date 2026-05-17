import 'package:chat_blockchain_app/providers/auth_provider.dart';
import 'package:chat_blockchain_app/services/wallet_service.dart';
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
          appBar: AppBar(title: Text('Login con Wallet')),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Introduce tu clave privada (hex) para conectarte'),
                // TextField(
                //   controller: _controller,
                //   decoration: InputDecoration(labelText: 'Clave privada (hex)'),
                //   obscureText: true,
                // ),
                _WalletProviderCard(
                  name: "Crear Wallet",
                  color: Colors.blue,
                  icon: Icons.add,
                  onPressed: _crearWallet,
                ),
                SizedBox(height: 20),
                _loading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _crearWallet,
                        child: Text('Conectar'),
                      ),
              ],
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
