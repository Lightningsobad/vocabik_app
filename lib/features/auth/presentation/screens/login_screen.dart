import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/shared/presentation/widgets/buttons/primary_button.dart';
import 'package:vocabik_app/shared/presentation/widgets/buttons/social_login_button.dart';

import '../../../../core/di/injection.dart';
import '../bloc/auth_bloc.dart';
import '../widgets/email_password_form.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AuthBloc>(),
      child: const LoginView(),
    );
  }
}

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>();
    
    return Scaffold(
      backgroundColor: colors?.background ?? Colors.white,
      body: BlocConsumer<AuthBloc, AuthState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          if (state.status == AuthStatus.success) {
            context.go('/home');
          } else if (state.status == AuthStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage ?? 'Có lỗi xảy ra')),
            );
          }
        },
        builder: (context, state) {
          final emailError = state.email.displayError != null 
              ? 'Email không hợp lệ' 
              : null;
          final passwordError = state.password.displayError != null 
              ? 'Mật khẩu phải từ 6 ký tự' 
              : null;

          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 400),
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: colors?.surfaceCard ?? Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  border: Border.all(
                    color: colors?.borderSubtle ?? Colors.grey.shade300,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Icon / Logo
                    Center(
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: const Color(0xFF0F172A),
                          borderRadius: BorderRadius.circular(13),
                          border: Border.all(color: Colors.blue),
                        ),
                        child: const Center(
                          child: Icon(Icons.play_arrow, color: Colors.blue, size: 18),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Đăng nhập vào Vocabik',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Social Buttons
                    SocialLoginButton(
                      text: 'Tiếp tục với Google',
                      icon: const Text('G', style: TextStyle(color: Color(0xFF4285F4), fontWeight: FontWeight.bold, fontSize: 18)),
                      onPressed: () {},
                    ),
                    const SizedBox(height: 10),
                    SocialLoginButton(
                      text: 'Tiếp tục với Facebook',
                      icon: const Text('f', style: TextStyle(color: Color(0xFF1877F2), fontWeight: FontWeight.bold, fontSize: 18)),
                      onPressed: () {},
                    ),
                    const SizedBox(height: 24),
                    const Row(
                      children: [
                        Expanded(child: Divider()),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Text('hoặc', style: TextStyle(fontSize: 12, color: Colors.grey)),
                        ),
                        Expanded(child: Divider()),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Form
                    EmailPasswordForm(
                      emailController: _emailController,
                      passwordController: _passwordController,
                      emailError: emailError,
                      passwordError: passwordError,
                      onEmailChanged: (value) => context.read<AuthBloc>().add(EmailChanged(value)),
                      onPasswordChanged: (value) => context.read<AuthBloc>().add(PasswordChanged(value)),
                    ),
                    const SizedBox(height: 14),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: const Text('Quên mật khẩu? →', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                      ),
                    ),
                    const SizedBox(height: 14),
                    PrimaryButton(
                      text: 'Đăng nhập',
                      isLoading: state.status == AuthStatus.loading,
                      onPressed: () => context.read<AuthBloc>().add(const LoginSubmitted()),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Chưa có tài khoản? ', style: TextStyle(color: Colors.grey)),
                        TextButton(
                          onPressed: () {},
                          child: const Text('Đăng ký miễn phí →', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
