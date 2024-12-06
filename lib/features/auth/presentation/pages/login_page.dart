import 'package:connect/features/auth/presentation/components/my_text_field.dart';
import 'package:connect/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isObscured = true;
  bool _keedLoggedIn = false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void _toggleObscureText() {
    setState(() {
      _isObscured = !_isObscured;
    });
  }

  void login() {
    final String email = emailController.text;
    final String password = passwordController.text;

    final authCubit = context.read<AuthCubit>();

    if (email.isNotEmpty && password.isNotEmpty) {
      authCubit.login(email, password);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Email e Senha necessários")));
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Column(
                children: [
                  const SizedBox(height: 100),
                  SvgPicture.asset(
                    'assets/logo.svg',
                    width: 220,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 100),
                  const Text(
                    'Bem Vindo ao innova connect!',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: MyTextField(
                      controller: emailController,
                      hintText: "Email de usuário",
                      isObscured: false,
                      isSecret: false,
                      toggleObscureText: () {},
                    ),
                  ),
                  const SizedBox(height: 50),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: MyTextField(
                      controller: passwordController,
                      hintText: 'Senha do usuário',
                      isObscured: _isObscured,
                      isSecret: true,
                      toggleObscureText: _toggleObscureText,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Row(
                      children: [
                        Checkbox(
                          value: _keedLoggedIn,
                          shape: const CircleBorder(),
                          activeColor: Theme.of(context).colorScheme.primary,
                          side: BorderSide(
                            width: 3,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          onChanged: (bool? value) {
                            setState(
                              () {
                                _keedLoggedIn = value!;
                              },
                            );
                          },
                        ),
                        const SizedBox(width: 5),
                        const Text('Manter Login ativo'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 80),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(
                          Theme.of(context).colorScheme.secondary,
                        ),
                        textStyle: WidgetStateProperty.all(
                          const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                        shape: WidgetStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        foregroundColor: WidgetStateProperty.all(Colors.white),
                        elevation: WidgetStateProperty.all(0),
                        minimumSize: WidgetStateProperty.all(
                          const Size(double.infinity, 50),
                        ),
                      ),
                      onPressed: login,
                      child: const Text("Entrar"),
                    ),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {},
                    child: Text(
                      "Esqueceu a senha?",
                      style: TextStyle(color: Theme.of(context).colorScheme.primary),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 10,
              left: 0,
              right: 0,
              child: Center(
                child: Column(
                  children: [
                    const Text("Ainda não tem login no app?"),
                    const SizedBox(height: 5),
                    GestureDetector(
                      onTap: () {},
                      child: Text(
                        "Clique aqui",
                        style: TextStyle(color: Theme.of(context).colorScheme.primary),
                      ),
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
