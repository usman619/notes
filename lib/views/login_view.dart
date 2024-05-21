import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:notes/constants/routes.dart';
import 'package:notes/firebase_options.dart';
import 'package:notes/utilities/show_error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
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
          title: const Text('Login', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.purple,
        ),
        body: FutureBuilder(
          future: Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform,
          ),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                return Column(
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
                          await FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                            email: email,
                            password: password,
                          );

                          final user = FirebaseAuth.instance.currentUser;

                          if (user?.emailVerified ?? false) {
                            // user's email is verified
                            Navigator.of(context).pushNamedAndRemoveUntil(
                              notesRoute,
                              (route) => false,
                            );
                          } else {
                            // user's email is not verified
                            Navigator.of(context).pushNamedAndRemoveUntil(
                              verifyEmailRoute,
                              (route) => false,
                            );
                          }
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'user-not-found') {
                            await showErrorDialog(
                              context,
                              'User not found.',
                            );
                          } else if (e.code == 'invalid-credential') {
                            await showErrorDialog(
                              context,
                              'Invalid Credential.',
                            );
                          } else {
                            await showErrorDialog(
                              context,
                              'Error: ${e.code}',
                            );
                          }
                        } catch (e) {
                          await showErrorDialog(
                            context,
                            e.toString(),
                          );
                        }
                      },
                      child: const Text('Login'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          registerRoute,
                          (route) => false,
                        );
                      },
                      child: const Text('Register User'),
                    ),
                  ],
                );

              default:
                return const Center(child: CircularProgressIndicator());
            }
          },
        ));
  }
}
