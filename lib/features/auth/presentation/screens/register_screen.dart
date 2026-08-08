import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/shared/theme/app_spacing.dart';
import 'package:vocabik_app/shared/presentation/widgets/interactions/bounce_wrapper.dart';
import 'package:vocabik_app/shared/presentation/widgets/inputs/password_input_widget.dart';
import 'package:vocabik_app/shared/theme/app_radius.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:vocabik_app/core/di/injection.dart';
import 'package:vocabik_app/features/auth/presentation/bloc/register_bloc.dart';
import 'package:vocabik_app/features/auth/presentation/bloc/register_event.dart';
import 'package:vocabik_app/features/auth/presentation/bloc/register_state.dart';
import 'package:vocabik_app/features/auth/presentation/widgets/password_strength_indicator.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<RegisterBloc>(),
      child: const RegisterScreenView(),
    );
  }
}

class RegisterScreenView extends StatefulWidget {
  const RegisterScreenView({super.key});

  @override
  State<RegisterScreenView> createState() => _RegisterScreenViewState();
}

class _RegisterScreenViewState extends State<RegisterScreenView> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  PasswordStrength _passwordStrength = PasswordStrength.none;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(() {
      context.read<RegisterBloc>().add(RegisterDisplayNameChanged(_nameController.text));
    });
    _emailController.addListener(() {
      context.read<RegisterBloc>().add(RegisterEmailChanged(_emailController.text));
    });
    _passwordController.addListener(() {
      final password = _passwordController.text;
      context.read<RegisterBloc>().add(RegisterPasswordChanged(password));
      _evaluatePasswordStrength(password);
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _evaluatePasswordStrength(String password) {
    if (password.isEmpty) {
      setState(() => _passwordStrength = PasswordStrength.none);
      return;
    }
    
    if (password.length < 8) {
      setState(() => _passwordStrength = PasswordStrength.weak);
      return;
    }

    final hasLetters = password.contains(RegExp(r'[a-zA-Z]'));
    final hasNumbers = password.contains(RegExp(r'[0-9]'));
    final hasSpecialCharacters = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

    if (hasLetters && hasNumbers && hasSpecialCharacters) {
      setState(() => _passwordStrength = PasswordStrength.strong);
    } else if (hasLetters && hasNumbers) {
      setState(() => _passwordStrength = PasswordStrength.medium);
    } else {
      setState(() => _passwordStrength = PasswordStrength.weak);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>();
    final l10n = AppLocalizations.of(context)!;

    return BlocListener<RegisterBloc, RegisterState>(
      listener: (context, state) {
        if (state.status == RegisterStatus.failure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(state.errorMessage ?? 'Registration failed')),
            );
        } else if (state.status == RegisterStatus.success) {
          context.push('/verify-email', extra: {
            'email': state.email.value,
            'password': state.password.value,
          });
        }
      },
      child: Scaffold(
        backgroundColor: colors?.background,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
              const SizedBox(height: AppSpacing.xl3),
              // App Logo placeholder (Play button icon in the UI)
              Center(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: colors?.surfaceCard,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.play_arrow_rounded,
                    size: 32,
                    color: Color(0xFF06B6D4), // Primary Cyan
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Text(
                l10n.createFreeAccount,
                textAlign: TextAlign.center,
                style: GoogleFonts.nunito(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: colors?.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.startLearningToday,
                textAlign: TextAlign.center,
                style: GoogleFonts.nunito(
                  fontSize: 16,
                  color: colors?.textSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.xl3),

              // Google Sign Up Placeholder
              BounceWrapper(
                onTap: () {
                  // TODO: Implement Google Sign Up
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: colors?.surfaceCard,
                    borderRadius: BorderRadius.circular(AppRadius.full),
                    border: Border.all(color: colors?.borderSubtle ?? Colors.grey.shade300),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.g_mobiledata, size: 24), // Placeholder for Google Icon
                      const SizedBox(width: 8),
                      Text(
                        l10n.signUpWithGoogle,
                        style: GoogleFonts.nunito(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: colors?.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.xl),
              
              // Divider
              Row(
                children: [
                  Expanded(child: Divider(color: colors?.borderSubtle)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      l10n.orText,
                      style: GoogleFonts.nunito(
                        color: colors?.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Expanded(child: Divider(color: colors?.borderSubtle)),
                ],
              ),

              const SizedBox(height: AppSpacing.xl),

              // Registration Form
              Container(
                decoration: BoxDecoration(
                  color: colors?.surfaceCard,
                  borderRadius: BorderRadius.circular(AppRadius.xl),
                  border: Border.all(color: colors?.borderSubtle ?? Colors.transparent),
                ),
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildTextField(
                      controller: _nameController,
                      hintText: l10n.yourName,
                      colors: colors,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _buildTextField(
                      controller: _emailController,
                      hintText: l10n.emailHint,
                      keyboardType: TextInputType.emailAddress,
                      colors: colors,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    PasswordInputWidget(
                      controller: _passwordController,
                      hintText: l10n.passwordHint,
                      onChanged: _evaluatePasswordStrength,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    PasswordStrengthIndicator(strength: _passwordStrength),
                    const SizedBox(height: AppSpacing.xl),
                    
                    BlocBuilder<RegisterBloc, RegisterState>(
                      buildWhen: (previous, current) => previous.status != current.status || previous.formStatus != current.formStatus,
                      builder: (context, state) {
                        final isValid = state.formStatus == FormzSubmissionStatus.success;
                        final isLoading = state.status == RegisterStatus.loading;

                        return BounceWrapper(
                          onTap: isValid && !isLoading
                              ? () => context.read<RegisterBloc>().add(const RegisterSubmitted())
                              : () {},
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              color: isValid ? const Color(0xFF06B6D4) : Colors.grey, // Primary Cyan or Grey
                              borderRadius: BorderRadius.circular(AppRadius.full),
                            ),
                            alignment: Alignment.center,
                            child: isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                  )
                                : Text(
                                    l10n.actionSignUp,
                                    style: GoogleFonts.nunito(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        );
                      },
                    ),
                    
                    const SizedBox(height: AppSpacing.lg),
                    
                    Text(
                      l10n.signUpTerms,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.nunito(
                        fontSize: 12,
                        color: colors?.textSecondary,
                      ),
                    ),
                    
                    const SizedBox(height: AppSpacing.lg),
                    
                    BounceWrapper(
                      onTap: () {
                        if (context.canPop()) {
                          context.pop();
                        } else {
                          context.go('/login');
                        }
                      },
                      child: Text(
                        l10n.alreadyHaveAccount,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.nunito(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF06B6D4),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
    AppColorsExtension? colors,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: GoogleFonts.nunito(
        color: colors?.textPrimary,
        fontSize: 16,
      ),
      cursorColor: const Color(0xFF06B6D4),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: GoogleFonts.nunito(color: colors?.textSecondary),
        filled: true,
        fillColor: colors?.background,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(color: colors?.borderSubtle ?? Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(color: colors?.borderSubtle ?? Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: Color(0xFF06B6D4), width: 2.0),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.lg),
      ),
    );
  }
}
