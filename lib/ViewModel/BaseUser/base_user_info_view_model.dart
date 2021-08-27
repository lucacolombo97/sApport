import 'package:flutter_form_bloc/flutter_form_bloc.dart';

class BaseUserInfoViewModel extends FormBloc<String, String> {
  final nameText = TextFieldBloc(validators: [
    FieldBlocValidators.required,
  ]);

  final surnameText = TextFieldBloc(validators: [
    FieldBlocValidators.required,
  ]);

  final birthDateTime = InputFieldBloc<DateTime, Object>(
      validators: [
        FieldBlocValidators.required,
      ],
      initialValue: new DateTime(
          DateTime.now().year - 18, DateTime.now().month, DateTime.now().day));

  BaseUserInfoViewModel() {
    addFieldBlocs(fieldBlocs: [nameText, surnameText, birthDateTime]);
  }

  Map get values {
    return {
      'name': nameText.value,
      'surname': surnameText.value,
      'birthDate': birthDateTime.value
    };
  }

  @override
  void onSubmitting() async {
    try {
      emitSuccess();
    } catch (e) {
      emitFailure();
    }
  }
}