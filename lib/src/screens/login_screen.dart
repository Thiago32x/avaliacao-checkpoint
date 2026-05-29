import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../service/login_service.dart';
import '../service/cart_service.dart';
import 'initial_screen.dart';

class LoginScreen extends StatefulWidget {
  final bool isFromCheckout;
  const LoginScreen({super.key, this.isFromCheckout = false});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final LoginService _loginService = LoginService();
  final CartService _cartService = CartService();
  
  bool _isPasswordVisible = false;
  bool _isLoading = false;
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  void _checkLoginStatus() async {
    String? token = await _loginService.getToken();
    if (token != null) {
      setState(() {
        _isLoggedIn = true;
      });
    }
  }

  void _navigateToHome() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const InitialScreen()),
      (route) => false,
    );
  }

  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final success = await _loginService.login(
        _usernameController.text.trim(),
        _passwordController.text,
      );

      setState(() => _isLoading = false);

      if (success) {
        if (widget.isFromCheckout) {
          _cartService.clearCart();
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Compra finalizada com sucesso!'),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 3),
              ),
            );
          }
        }
        if (mounted) _navigateToHome();
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Falha no login. Verifique suas credenciais.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black, size: 30),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: _isLoggedIn ? _buildLoggedInUI() : _buildLoginForm(),
        ),
      ),
    );
  }

  Widget _buildLoggedInUI() {
    return Column(
      children: [
        Image.asset('assets/images/logo_usedev.png', height: 80),
        const SizedBox(height: 40),
        Icon(Icons.check_circle_outline, size: 80, color: Colors.green[400]),
        const SizedBox(height: 20),
        Text(
          'Você já está logado!',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            fontFamily: GoogleFonts.orbitron().fontFamily,
          ),
        ),
        const SizedBox(height: 40),
        _buildButton('IR PARA A TELA PRINCIPAL', _navigateToHome),
        TextButton(
          onPressed: () async {
            await _loginService.logout();
            setState(() => _isLoggedIn = false);
          },
          child: const Text('Entrar com outra conta', style: TextStyle(color: Colors.grey)),
        )
      ],
    );
  }

  Widget _buildLoginForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Image.asset('assets/images/logo_usedev.png', height: 80),
          const SizedBox(height: 20),
          if (widget.isFromCheckout)
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Text(
                'Confirme seu login para finalizar a compra',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.bold,
                  fontFamily: GoogleFonts.orbitron().fontFamily,
                ),
              ),
            ),
          const SizedBox(height: 30),
          TextFormField(
            controller: _usernameController,
            autocorrect: false,
            enableSuggestions: false,
            decoration: _inputDecoration('Username', Icons.person_outline),
            validator: (v) => v!.isEmpty ? 'Insira o username' : null,
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _passwordController,
            obscureText: !_isPasswordVisible,
            autocorrect: false,
            enableSuggestions: false,
            decoration: _inputDecoration('Senha', Icons.lock_outline, isPassword: true),
            validator: (v) => v!.isEmpty ? 'Insira a senha' : null,
          ),
          const SizedBox(height: 40),
          _buildButton(widget.isFromCheckout ? 'ENTRAR E FINALIZAR' : 'ENTRAR', _handleLogin),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon, {bool isPassword = false}) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(fontFamily: GoogleFonts.orbitron().fontFamily),
      prefixIcon: Icon(icon),
      suffixIcon: isPassword
          ? IconButton(
              icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off),
              onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
            )
          : null,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
    );
  }

  Widget _buildButton(String text, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onPressed: _isLoading ? null : onPressed,
        child: _isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : Text(
                text,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: GoogleFonts.orbitron().fontFamily,
                ),
              ),
      ),
    );
  }
}
