import 'package:boards/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:boards/utils/validators.dart';

class CustomCheckBox extends StatefulWidget {
  /// Сопровождающий текст
  final String? text;

  /// Нужен ли стандартный валидатор на заполненность
  final bool? needStandardValidator;

  /// Дополнительный валидатор после стандартных, если требуется(запрос)
  final Future<String?>? Function(bool)? onReady;

  /// Если стоит true, то секбокс меняется на toggle кнопку
  final bool needSwitch;

  /// Убрать паддинг
  final bool removePadding;

  /// Булевая переменная для стартового значения
  final bool? value;

  /// Функция на изменение значения
  final Function? onChanged;

  const CustomCheckBox(
      {Key? key,
      this.text,
      this.needStandardValidator,
      this.onReady,
      this.needSwitch = false,
      this.removePadding = false,
      this.value,
      this.onChanged})
      : super(key: key);

  @override
  State<CustomCheckBox> createState() => _CustomCheckBoxState();
}

class _CustomCheckBoxState extends State<CustomCheckBox> {
  bool _check = false;
  bool _loader = false;
  bool _hover = false;
  Color _toggleColor = AppColor.toggleUnSelected;
  String? _textError;
  double _withOpacity = 0;

  /// Функция по нажатию на кнопку
  void _onChanged(value, state) async {
    setState(() {
      _loader = true;
    });
    await getBoolValidator(
            value: !_check,
            onReady: widget.onReady,
            requiredValidator: widget.needStandardValidator)
        .then((result) {
      _textError = result;
      state.didChange(value);
      _check = value!;
      _loader = false;
      _hover = false;
      _withOpacity = 0;
    });
    if (widget.onChanged != null) {
      widget.onChanged!(value);
    }
  }

  /// CheckBox виджет
  Container _checkbox(state, size) {
    return Container(
      margin: EdgeInsets.only(
          top: 5, bottom: 5, left: _hover == true ? 0 : 24, right: 14),
      height: size,
      width: size,
      decoration: BoxDecoration(
          color: AppColor.textButton,
          borderRadius:
              BorderRadius.circular(CheckboxTheme.of(context).splashRadius!)),
      child: Checkbox(
          activeColor: AppColor.checkBoxConfirm,
          value: state.value,
          onChanged: (value) => _onChanged(value, state)),
    );
  }

  /// Switch виджет
  MouseRegion _switch(state) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Padding(
        padding: !widget.removePadding
            ? const EdgeInsets.only(top: 5, bottom: 5, left: 24, right: 14)
            : EdgeInsets.zero,
        child: FlutterSwitch(
            width: 36,
            height: 20,
            toggleSize: 16,
            borderRadius: 12.5,
            padding: 2.5,
            toggleColor: AppColor.focusTransparentButton,
            activeColor: AppColor.textButton,
            inactiveColor: _toggleColor,
            value: state.value,
            onToggle: (value) => _onChanged(value, state)),
      ),
    );
  }

  /// Лоадер
  Padding _loaderWidget(size) {
    return Padding(
      padding: EdgeInsets.only(
          left: widget.needSwitch == true ? 34 : 24,
          right: widget.needSwitch == true ? 24 : 14,
          top: widget.needSwitch == true ? 7 : 5,
          bottom: widget.needSwitch == true ? 7 : 5),
      child: SizedBox(
          width: size,
          height: size,
          child: const CircularProgressIndicator(strokeWidth: 2)),
    );
  }

  /// Текст
  Flexible _text(state, theme) {
    return Flexible(
        child: Padding(
      padding: const EdgeInsets.only(right: 32.0),
      child: Text(widget.text!,
          style: theme.textTheme.caption!.copyWith(
              color: AppColor.textColorLight,
              decoration:
                  state.value == true ? TextDecoration.lineThrough : null)),
    ));
  }

  /// Действия при наведении на чек-бокс
  void _onEnter(value, FormFieldState<bool> state) {
    if (state.value == true && widget.needSwitch == false) {
      setState(() {
        _hover = true;
        _withOpacity = 0.2;
      });
    }
    if (state.value == false && widget.needSwitch == true) {
      setState(() {
        _toggleColor = AppColor.toggleSelected;
      });
    }
  }

  /// Действия при покидании зоны чек-бокса
  void _onExit(value) {
    if (widget.needSwitch == false) {
      setState(() {
        _hover = false;
        _withOpacity = 0;
      });
    } else {
      setState(() {
        _toggleColor = AppColor.toggleUnSelected;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const double _size = 16;
    final ThemeData _theme = Theme.of(context);
    return Container(
      color: AppColor.textColorSelected.withOpacity(_withOpacity),
      child: FormField<bool>(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          initialValue: widget.value ?? false,
          validator: (_) => _textError,
          builder: (state) {
            return MouseRegion(
              onEnter: (value) => _onEnter(value, state),
              onExit: (value) => _onExit(value),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    alignment: AlignmentDirectional.center,
                    children: [
                      Row(
                        children: [
                          if (_hover == true && !widget.needSwitch)
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 0.0),
                              child: SizedBox(
                                  width: 24,
                                  child: Icon(
                                    Icons.drag_indicator,
                                    color: AppColor.textColorSelected,
                                    size: 20,
                                  )),
                            ),
                          if (_loader == false)
                            widget.needSwitch == false
                                ? _checkbox(state, _size)
                                : _switch(state),
                          if (_loader == true && widget.onReady != null)
                            _loaderWidget(_size),
                          if (widget.text != null) _text(state, _theme),
                        ],
                      ),
                      if (_hover == true && !widget.needSwitch)
                        const Padding(
                          padding: EdgeInsets.only(right: 7),
                          child: Align(
                              alignment: Alignment.centerRight,
                              child: Icon(Icons.adjust,
                                  color: AppColor.textColorSelected, size: 20)),
                        )
                    ],
                  ),
                  if (state.hasError) _ErrorWidget(theme: _theme, state: state)
                ],
              ),
            );
          }),
    );
  }
}

/// Виджет отображения ошибки
class _ErrorWidget extends StatelessWidget {
  final ThemeData theme;
  final FormFieldState<bool>? state;
  final String? errorText;

  const _ErrorWidget(
      {Key? key, required this.theme, this.state, this.errorText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 8, left: 24, right: 12),
      decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: AppColor.cancel, width: 2))),
      child: Row(
        children: [
          Flexible(
            child: Text(
              state?.errorText ?? errorText ?? '',
              style: theme.textTheme.caption!.copyWith(color: AppColor.cancel),
            ),
          ),
        ],
      ),
    );
  }
}
