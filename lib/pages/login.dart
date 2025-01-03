import 'package:chat_app/services/auth/auth_service.dart';
import 'package:chat_app/components/my_button.dart';
import 'package:chat_app/components/my_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class Login extends StatelessWidget {
  Login({super.key, required this.navigateToRegisterPage});

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final void Function()? navigateToRegisterPage;

  void login(BuildContext context) async {
    final authService = AuthService();

    try {
      authService.signInWithEmailPassword(
          _emailController.text, _passwordController.text);
    } catch (e) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text(e.toString()),
              ));
    }
  }

  void googleSignIn() async {
    final authService = AuthService();
    authService.signInWithGoogle();
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
            Text("Hoş geldiniz, sohbete başlayalım!",
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
            const SizedBox(height: 25),
            MyButton(text: "Giriş yap", onTap: () => login(context)),
            const SizedBox(height: 10),
            SignInButton(
              Buttons.Google,
              onPressed: googleSignIn,
            ),
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Üye değil misiniz? ",
                  style: TextStyle(color: Colors.grey.shade500),
                ),
                GestureDetector(
                  onTap: navigateToRegisterPage,
                  child: Text(
                    "Hemen kayıt ol",
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
