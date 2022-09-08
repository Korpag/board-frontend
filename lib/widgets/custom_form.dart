import 'package:boards/widgets/custom_checkbox.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:boards/widgets/custom_dropdown.dart';
import 'package:boards/widgets/custom_input.dart';

abstract class CustomForm {
  /// Стандартный текстовый Input.
  static text(
      {Key? keyForm,
      AutovalidateMode? autoValidateMode,
      TextInputType? keyboardType,
      TextEditingController? textController,
      String? hintText,
      bool? readOnly,
      bool? requiredValidator,
      TextInputFormatter? textInputFormatter,
      Future<String?>? Function(String)? onReady,
      Function? onChanged,
      Function(String)? onSubmitted,
      bool? editInput, Color? fillColor,
      bool? needRequest}) {
    return CustomInput(
      keyForm: keyForm,
      autoValidateMode: autoValidateMode ?? AutovalidateMode.disabled,
      textInputFormatter: textInputFormatter,
      textController: textController,
      requiredValidator: requiredValidator,
      keyboardType: keyboardType,
      hintText: editInput == true ? '' : hintText ?? 'Введите текст:',
      typeForm: 'text',
      readOnly: readOnly,
      onSubmitted: onSubmitted,
      onChanged: onChanged,
      editInput: editInput,
      fillColor: fillColor,
      needRequest: needRequest,
      onReady: onReady,
    );
  }

  /// Input для ввода почты с соответствующими настройками
  static email(
      {Key? keyForm,
      TextEditingController? textController,
      Future<String?>? Function(String)? onReady,
      bool? needRequest}) {
    return CustomInput(
      keyForm: keyForm,
      textController: textController,
      hintText: 'Введите email (адрес электронной почты):',
      typeForm: 'email',
      onReady: onReady,
      needRequest: needRequest,
    );
  }

  /// Input для ввода телефона с соответствующими настройками
  static phone(
      {Key? keyForm,
      TextEditingController? textController,
      bool? requiredValidator,
      Future<String?>? Function(String)? onReady,
      bool? needRequest}) {
    return CustomInput(
      keyForm: keyForm,
      textController: textController,
      requiredValidator: requiredValidator,
      hintText: 'Введите номер телефона:',
      typeForm: 'phone',
      onReady: onReady,
      needRequest: needRequest,
    );
  }

  /// Input для ввода пароля с соответствующими настройками
  static password(
      {Key? keyForm, String? hintText, TextEditingController? textController}) {
    return CustomInput(
      keyForm: keyForm,
      typeForm: 'password',
      textController: textController,
      hintText: hintText ?? 'Введите пароль:',
    );
  }

  /// Input для ввода даты с соответствующими настройками
  static date(
      {Key? keyForm,
      TextEditingController? textController,
      bool? requiredValidator,
      bool needRangeDate = false,
      Future<String?>? Function(String)? onReady,
      bool? needRequest}) {
    return CustomInput(
      keyForm: keyForm,
      textController: textController,
      keyboardType: TextInputType.number,
      requiredValidator: requiredValidator,
      hintText: !needRangeDate ? 'ДД-ММ-ГГ' : 'ДД.ММ.ГГ — ДД.ММ.ГГ',
      typeForm: !needRangeDate ? 'date' : 'date_range',
      readOnly: true,
      needRequest: needRequest,
      onReady: onReady,
    );
  }

  /// CheckBox для подтверждения с соответствующими настройками
  static checkBox(
      {String? text,
      bool? needStandardValidator,
      bool? value,
      Function? onChanged,
      Future<String?>? Function(bool)? onReady}) {
    return CustomCheckBox(
      text: text,
      onReady: onReady,
      onChanged: onChanged,
      value: value,
      needStandardValidator: needStandardValidator,
    );
  }

  /// ToggleButton для подтверждения с соответствующими настройками
  static toggle(
      {String? text,
      bool? needStandardValidator,
      bool? value,
      Function? onChanged,
      Future<String?>? Function(bool)? onReady,
      bool removePadding = false}) {
    return CustomCheckBox(
      text: text,
      onReady: onReady,
      onChanged: onChanged,
      value: value,
      needSwitch: true,
      needStandardValidator: needStandardValidator,
      removePadding: removePadding,
    );
  }

  /// Dropdown с соответствующими настройками
  static dropDown(
      {required List item,
      String? hintText,
      bool? needStandardValidator,
      Function? onSelect,
      Future<String?>? Function(String)? onReady,
      TextEditingController? textController}) {
    return CustomDropDown(
      textController: textController,
      needStandardValidator: needStandardValidator,
      item: item,
      onSelect: onSelect,
      onReady: onReady,
      hintText: hintText,
    );
  }

  /// Dropdown с мультивыбором с соответствующими настройками
  static multiChoiceDropDown(
      {required Map<Color, String> item,
      String? hintText,
      Function? onSelect,
      bool? needStandardValidator,
      Map<Color, String>? selectItems}) {
    return CustomDropDown(
      multiChoiceItems: item,
      needMultiChoice: true,
      onSelect: onSelect,
      hintText: hintText,
      needStandardValidator: needStandardValidator,
      selectItems: selectItems,
    );
  }
}
