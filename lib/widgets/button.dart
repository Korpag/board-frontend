import 'package:flutter/material.dart';
import 'package:boards/theme/app_color.dart';

class Button extends StatefulWidget {
  /// Текст кнопки
  final String text;

  /// Цвет текста кнопки
  final Color colorText;

  /// Цвет кнопки
  final Color colorButton;

  /// Вертикальный внутренний паддинг для кнопки
  final double verticalPadding;

  /// Горизонтальный внутренний паддинг для кнопки
  final double horizontalPadding;

  /// BorderRadius для кнопки
  final double borderRadius;

  /// Функция по нажатию на кнопку
  final Function() onTap;

  /// Прозрачный вид кнопки
  final bool noColorButton;

  /// Нужен ли feedBack при наведении
  final bool feedBack;

  const Button(
      {Key? key,
      this.verticalPadding = 7,
      this.horizontalPadding = 14,
      required this.text,
      this.borderRadius = 2.5,
      this.colorText = AppColor.textButton,
      this.colorButton = AppColor.confirm,
      required this.onTap,
      this.noColorButton = false,
      this.feedBack = true})
      : super(key: key);

  /// Классическая кнопка добавить
  static add({String text = 'Добавить', required Function() onTap}) {
    return Button(text: text, onTap: onTap);
  }

  /// Классическая кнопка отменить, есть возможность задать цвет.
  static cancel({String text = 'Отменить', required Function() onTap}) {
    return Button(text: text, colorButton: AppColor.cancel, onTap: onTap);
  }

  /// Кнопка без фидбека
  static noFeedBack(
      {required String text,
      required Function() onTap,
      bool noColorButton = false,
      Color colorButton = AppColor.green}) {
    return Button(
      text: text,
      colorButton: colorButton,
      noColorButton: noColorButton,
      onTap: onTap,
      feedBack: false,
    );
  }

  /// Кнопка с прозрачным фоном
  static buttonTransparent(
      {String text = 'Отменить', required Function() onTap}) {
    return Button(
      text: text,
      colorButton: AppColor.textButton,
      onTap: onTap,
      noColorButton: true,
    );
  }

  @override
  State<Button> createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  double _withOpacityButton = 0.25;
  double _withOpacityText = 0.4;
  Color _backgroundColor = Colors.transparent;

  /// Функция для изменения отображения при наведении мышки на кнопку
  void _onHover(onHover) {
    if (onHover == true) {
      _withOpacityButton = 1;
      _withOpacityText = 1;
      _backgroundColor = AppColor.focusTransparentButton;
    } else {
      _withOpacityButton = 0.25;
      _withOpacityText = 0.4;
      _backgroundColor = Colors.transparent;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);
    return InkWell(
      onTap: widget.onTap,
      onHover: widget.feedBack ? _onHover : null,
      mouseCursor: SystemMouseCursors.click,
      child: Container(
        decoration: BoxDecoration(
            color: widget.noColorButton == false
                ? widget.colorButton
                    .withOpacity(widget.feedBack ? _withOpacityButton : 1)
                : _backgroundColor,
            border: Border.all(
                color:
                    widget.colorButton.withOpacity(widget.noColorButton == false
                        ? 1
                        : widget.feedBack
                            ? _withOpacityText
                            : 1)),
            borderRadius: BorderRadius.circular(widget.borderRadius)),
        padding: EdgeInsets.only(
          top: widget.verticalPadding,
          bottom: widget.verticalPadding - 1,
          left: widget.horizontalPadding,
          right: widget.horizontalPadding,
        ),
        child: Text(widget.text,
            style: _theme.textTheme.button!.copyWith(
                color: widget.colorText
                    .withOpacity(widget.feedBack ? _withOpacityText : 1))),
      ),
    );
  }
}
