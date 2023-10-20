import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:siklas/screens/main_screen.dart';
import 'package:siklas/view_models/login_view_model.dart';

class LoginScreen extends StatefulWidget {
  static const String routePath = '/login';

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    if (mounted) {
      context.read<LoginViewModel>().addListener(_errorMessageListener);
      context.read<LoginViewModel>().addListener(_loginSucceedListener);
    }

    super.initState();
  }

  void _errorMessageListener() {
    if (mounted) {
      final loginViewModel = Provider.of<LoginViewModel>(context, listen: false);

      if (loginViewModel.getErrorMessage() != null) {
        ScaffoldMessenger
          .of(context)
          .showSnackBar(SnackBar(content: Text(loginViewModel.getErrorMessage()!)));

        loginViewModel.setErrorMessage(null);
      }
    }
  }

  void _loginSucceedListener() {
    if (mounted) {
      final loginViewModel = Provider.of<LoginViewModel>(context, listen: false);
      
      if (loginViewModel.getIsLoginSuccess()) {
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        Navigator.pushReplacementNamed(context, MainScreen.routePath);
      
        loginViewModel.setIsLoginSuccess(false);
      }
    }
  }

  @override
  void dispose() {
    if (mounted && context.mounted) {
      context.read<LoginViewModel>().removeListener(_errorMessageListener);
      context.read<LoginViewModel>().removeListener(_loginSucceedListener);
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Consumer<LoginViewModel>(
            builder: (context, state, _) {
              return Form(
                key: state.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Siklas',
                      style: Theme.of(context).textTheme.headlineLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20,),
                    TextFormField(
                      controller: state.emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                      ),
                      validator: state.validateEmail,
                    ),
                    const SizedBox(height: 20,),
                    TextFormField(
                      controller: state.passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        suffixIcon: GestureDetector(
                          onTap: state.togglePasswordObscure,
                          child: Icon(state.isPasswordObscured ? Icons.visibility : Icons.visibility_off)
                        ),
                      ),
                      validator: state.validatePassword,
                      obscureText: state.isPasswordObscured,
                    ),
                    const SizedBox(height: 20,),
                    ElevatedButton(
                      onPressed: state.isLoggingIn ? null : state.login,
                      child: state.isLoggingIn
                        ? const CircularProgressIndicator(
                            strokeAlign: -6.0,
                            strokeWidth: 3.0,
                          )
                        : const Text('Masuk')
                    ),
                  ],
                ),
              );
            }
          ),
        ),
      ),
    );
  }
}