import 'package:flutter/material.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';
import 'package:vocabik_app/shared/presentation/widgets/inputs/app_text_field.dart';
import 'package:vocabik_app/shared/presentation/widgets/inputs/password_input_widget.dart';
import 'package:vocabik_app/shared/theme/app_spacing.dart';

class AuthForm extends StatefulWidget {
  final bool showNameField;
  final TextEditingController? nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final String? nameError;
  final String? emailError;
  final String? passwordError;
  final ValueChanged<String>? onNameChanged;
  final ValueChanged<String>? onEmailChanged;
  final ValueChanged<String>? onPasswordChanged;
  final VoidCallback? onSubmitted;

  const AuthForm({
    super.key,
    this.showNameField = false,
    this.nameController,
    required this.emailController,
    required this.passwordController,
    this.nameError,
    this.emailError,
    this.passwordError,
    this.onNameChanged,
    this.onEmailChanged,
    this.onPasswordChanged,
    this.onSubmitted,
  });

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  late final FocusNode _nameFocusNode;
  late final FocusNode _emailFocusNode;
  late final FocusNode _passwordFocusNode;

  @override
  void initState() {
    super.initState();
    _nameFocusNode = FocusNode();
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _nameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Name field
        if (widget.showNameField) ...[
          AppTextField(
            controller: widget.nameController,
            focusNode: _nameFocusNode,
            hintText: l10n.yourName,
            errorText: widget.nameError,
            keyboardType: TextInputType.name,
            textInputAction: TextInputAction.next,
            onChanged: widget.onNameChanged,
            onSubmitted: (_) => _emailFocusNode.requestFocus(),
          ),
          const SizedBox(height: AppSpacing.md),
        ],

        // Email field
        AppTextField(
          controller: widget.emailController,
          focusNode: _emailFocusNode,
          hintText: l10n.emailHint,
          errorText: widget.emailError,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          onChanged: widget.onEmailChanged,
          onSubmitted: (_) => _passwordFocusNode.requestFocus(),
        ),
        const SizedBox(height: AppSpacing.md),

        // Password field
        PasswordInputWidget(
          controller: widget.passwordController,
          focusNode: _passwordFocusNode,
          hintText: l10n.passwordHint,
          errorText: widget.passwordError,
          textInputAction: TextInputAction.done,
          onChanged: widget.onPasswordChanged,
          onFieldSubmitted: (_) => widget.onSubmitted?.call(),
        ),
      ],
    );
  }
}
