import 'package:flutter/widgets.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';
import 'package:vocabik_app/features/auth/presentation/models/display_name_input.dart';
import 'package:vocabik_app/features/auth/presentation/models/email_input.dart';
import 'package:vocabik_app/features/auth/presentation/models/password_input.dart';

class AuthValidationHelper {
  AuthValidationHelper._();

  static String? getDisplayNameError(
    BuildContext context,
    DisplayNameInput displayName,
  ) {
    if (displayName.displayError == null) return null;
    final l10n = AppLocalizations.of(context);
    switch (displayName.displayError!) {
      case DisplayNameValidationError.invalid:
        return l10n?.nameCannotBeEmpty ?? 'Name cannot be empty';
    }
  }

  static String? getEmailError(
    BuildContext context,
    EmailInput email,
  ) {
    if (email.displayError == null) return null;
    final l10n = AppLocalizations.of(context);
    switch (email.displayError!) {
      case EmailValidationError.empty:
      case EmailValidationError.invalid:
        return l10n?.emailInvalid ?? 'Invalid email';
    }
  }

  static String? getPasswordError(
    BuildContext context,
    PasswordInput password,
  ) {
    if (password.displayError == null) return null;
    final l10n = AppLocalizations.of(context);
    switch (password.displayError!) {
      case PasswordValidationError.empty:
      case PasswordValidationError.short:
        return l10n?.passwordMinLength ?? 'Password must be at least 6 characters';
    }
  }
}
