import 'package:formz/formz.dart';

enum DisplayNameValidationError { invalid }

class DisplayNameInput extends FormzInput<String, DisplayNameValidationError> {
  const DisplayNameInput.pure() : super.pure('');
  const DisplayNameInput.dirty([super.value = '']) : super.dirty();

  @override
  DisplayNameValidationError? validator(String value) {
    return value.trim().isNotEmpty ? null : DisplayNameValidationError.invalid;
  }
}
