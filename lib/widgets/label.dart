import 'package:boards/theme/app_color.dart';
import 'package:flutter/material.dart';

class Label extends StatelessWidget {
  /// Цвет плашки лейбла
  final Color colorLabel;

  /// Цвет текста
  final Color colorText;

  /// Текст
  final String text;

  /// Функция нажатия на крестик. Если она не равна null, то крестик отображается
  final Function()? onTapClearButton;

  /// Нужны ли тени
  final bool shadowLabel;

  const Label(
      {Key? key,
      this.colorLabel = AppColor.confirm,
      this.colorText = AppColor.textButton,
      this.text = 'Кнопка',
      this.onTapClearButton,
      this.shadowLabel = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.only(
          left: 14,
          right: onTapClearButton != null ? 11 : 14,
          bottom: 2,
          top: 2),
      decoration: BoxDecoration(
          color: colorLabel,
          borderRadius: BorderRadius.circular(2.5),
          boxShadow: [
            if (shadowLabel) BoxShadow(color: colorLabel, blurRadius: 10)
          ]),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(text,
              style: _theme.textTheme.button!
                  .copyWith(fontWeight: FontWeight.w700, color: colorText)),
          if (onTapClearButton != null)
            Row(
              children: [
                const SizedBox(width: 11),
                InkWell(
                  onTap: onTapClearButton ?? () {},
                  child: const Icon(Icons.clear,
                      color: AppColor.textButton, size: 12),
                )
              ],
            )
        ],
      ),
    );
  }
}
