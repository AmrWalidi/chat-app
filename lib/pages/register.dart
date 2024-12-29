import 'package:chat_app/services/auth/auth_service.dart';
import 'package:chat_app/components/my_button.dart';
import 'package:chat_app/components/my_text_field.dart';
import 'package:flutter/material.dart';

class Register extends StatelessWidget {
  Register({super.key, required this.navigateToLoginPage});

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final void Function()? navigateToLoginPage;

  void register(BuildContext context) async {
    final authService = AuthService();

    if (_confirmPasswordController.text == _passwordController.text) {
      try {
        authService.signUpWithEmailPassword(
            _emailController.text, _passwordController.text);
      } catch (e) {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text(e.toString()),
                ));
      }
    } else {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text("Şifre eşleşmiyor"),
              ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.message,
              size: 60,
              color: Colors.green.shade500,
            ),
            const SizedBox(height: 50),
            Text("Bir hesap oluşturalım size!",
                style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 25),
            MyTextField(
                hinText: "E-posta",
                obscureText: false,
                controller: _emailController),
            const SizedBox(height: 10),
            MyTextField(
                hinText: "Şifre",
                obscureText: true,
                controller: _passwordController),
            const SizedBox(height: 10),
            MyTextField(
                hinText: "Tekrar Şifre",
                obscureText: true,
                controller: _confirmPasswordController),
            const SizedBox(height: 25),
            MyButton(text: "kayıt ol", onTap: () => register(context)),
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Zaten bir hesabınız var mı? ",
                  style: TextStyle(color: Colors.grey.shade500),
                ),
                GestureDetector(
                  onTap: navigateToLoginPage,
                  child: Text(
                    "Hemen giriş yap",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade500),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
