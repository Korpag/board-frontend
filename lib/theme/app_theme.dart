import 'package:boards/theme/app_color.dart';
import 'package:flutter/material.dart';

final ThemeData appThemeData = ThemeData(
    colorScheme:
        ThemeData().colorScheme.copyWith(primary: AppColor.checkBoxConfirm),

    /// Инпут
    inputDecorationTheme: InputDecorationTheme(
        isDense: true,
        filled: true,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        focusedErrorBorder: _border(color: AppColor.cancel),
        errorBorder: _border(color: AppColor.cancel),
        focusedBorder: _border(color: AppColor.inputSelectedBorder),
        enabledBorder:
            _border(color: AppColor.inputUnSelectedBorder, width: 0.5)),

    /// Чекбокс
    checkboxTheme: CheckboxThemeData(
        splashRadius: _borderRadius,
        side: MaterialStateBorderSide.resolveWith(
          (states) => BorderSide(width: 1.0, color: getColor(states)),
        ),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_borderRadius))),
    scaffoldBackgroundColor: AppColor.background,

    /// Шрифты
    textTheme: const TextTheme(
        button: TextStyle(
          fontFamily: "PT Root UI",
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColor.textButton,
        ),
        caption: TextStyle(
          fontFamily: "PT Root UI",
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppColor.textColorSelected,
        ),
        headline3: TextStyle(
          fontFamily: "PT Root UI",
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: AppColor.textColorLight,
        )));

/// Залить фон по умолчанию в пустом значении нельзя, поэтому мы обернули чек-бокс в контейнер с фоном, но ему требуется аналогичное закругление, что и в теме чек бокса
/// Нам нужно достучаться до значения в BorderRadius.circular, но напрямую обратится нельзя
/// А к сплеш радиусу, можно. Поэтому мы делаем общую переменую.
const double _borderRadius = 2.5;

/// Цвета бордерсайда в зависимости от стейта чекбокса
Color getColor(Set<MaterialState> states) {
  const Set<MaterialState> interactiveStates = <MaterialState>{
    MaterialState.selected,
  };
  if (states.any(interactiveStates.contains)) {
    return AppColor.checkBoxConfirm;
  }
  return AppColor.checkBoxUnSelectedSide;
}

/// Универсальный бордер для инпута
OutlineInputBorder _border({required Color color, double width = 2}) {
  return OutlineInputBorder(
      borderRadius: BorderRadius.circular(2.5),
      borderSide: BorderSide(color: color, width: width));
}
