import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/services/auth/auth_exceptions.dart';
import 'package:notes/services/auth/bloc/auth_bloc.dart';
import 'package:notes/services/auth/bloc/auth_event.dart';
import 'package:notes/services/auth/bloc/auth_state.dart';
import 'package:notes/utilities/dialogs/error_dialog.dart';

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
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateRegistering) {
          if (state.exception is WeakPasswordException) {
            await showErrorDialog(
              context,
              'Weak password',
            );
          } else if (state.exception is EmailAlreadyInUseException) {
            await showErrorDialog(
              context,
              'Email Already in Use',
            );
          } else if (state.exception is InvalidEmailException) {
            await showErrorDialog(
              context,
              'Invalid Email',
            );
          } else if (state.exception is GenericException) {
            await showErrorDialog(
              context,
              'Unable to Register User',
            );
          }
        }
      },
      child: Scaffold(
          appBar: AppBar(
            title:
                const Text('Register', style: TextStyle(color: Colors.white)),
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

                  context.read<AuthBloc>().add(AuthEventRegister(
                        email,
                        password,
                      ));
                },
                child: const Text('Register'),
              ),
              TextButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(
                          const AuthEventLogOut(),
                        );
                  },
                  child: const Text('Already Registered? Login here!')),
            ],
          )),
    );
  }
}
