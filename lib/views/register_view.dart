import 'package:flutter/material.dart';
import 'package:notes/constants/routes.dart';
import 'package:notes/services/auth/auth_exceptions.dart';
import 'package:notes/services/auth/auth_service.dart';
import 'package:notes/utilities/show_error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Register', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.purple,
        ),
        body: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: _emailController,
              enableSuggestions: false,
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Email',
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              autocorrect: false,
              enableSuggestions: false,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
              ),
            ),
            TextButton(
              onPressed: () async {
                final email = _emailController.text;
                final password = _passwordController.text;

                try {
                  await AuthService.firebase().createUser(
                    email: email,
                    password: password,
                  );
                  AuthService.firebase().currentUser;
                  AuthService.firebase().sendEmailVerification();

                  Navigator.of(context).pushNamed(verifyEmailRoute);
                } on WeakPasswordException {
                  await showErrorDialog(
                    context,
                    'Weak password',
                  );
                } on EmailAlreadyInUseException {
                  await showErrorDialog(
                    context,
                    'Email already in use',
                  );
                } on InvalidEmailException {
                  await showErrorDialog(
                    context,
                    'Invalid email',
                  );
                } on GenericException {
                  await showErrorDialog(
                    context,
                    'Unable to Register User',
                  );
                }
              },
              child: const Text('Register'),
            ),
            TextButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(loginRoute, (route) => false);
                },
                child: const Text('Login')),
          ],
        ));
  }
}
