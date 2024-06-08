import 'package:flutter/material.dart';
import 'package:notes/services/auth/auth_exceptions.dart';
import 'package:notes/services/auth/bloc/auth_bloc.dart';
import 'package:notes/services/auth/bloc/auth_event.dart';
import 'package:notes/services/auth/bloc/auth_state.dart';
import 'package:notes/utilities/dialogs/error_dialog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/utilities/dialogs/loading_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  CloseDialog? _closeDialogHandle;

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
        if (state is AuthStateLoggedOut) {
          final closeDialog = _closeDialogHandle;

          if (!state.isLoading && closeDialog != null) {
            closeDialog();
            _closeDialogHandle = null;
          } else if (state.isLoading && closeDialog == null) {
            _closeDialogHandle = showLoadingDialog(
              context: context,
              text: 'Loading...',
            );
          }

          if (state.exception is UserNotFoundAuthException) {
            await showErrorDialog(
              context,
              'User not found.',
            );
          } else if (state.exception is WrongPasswordAuthException) {
            await showErrorDialog(
              context,
              'Wrong Credentials.',
            );
          } else if (state.exception is InvalidCredentialException) {
            await showErrorDialog(
              context,
              'Invalid Credential.',
            );
          } else if (state.exception is GenericException) {
            await showErrorDialog(
              context,
              'Authentication Error. Please try again.',
            );
          }
        }
      },
      child: Scaffold(
          appBar: AppBar(
            title: const Text('Login', style: TextStyle(color: Colors.white)),
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
                  context.read<AuthBloc>().add(AuthEventLogIn(
                        email,
                        password,
                      ));
                },
                child: const Text('Login'),
              ),
              TextButton(
                onPressed: () {
                  context.read<AuthBloc>().add(
                        const AuthEventShouldRegister(),
                      );
                },
                child: const Text('Register User'),
              ),
            ],
          )),
    );
  }
}
