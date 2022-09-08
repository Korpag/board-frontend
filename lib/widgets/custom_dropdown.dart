import 'package:boards/theme/app_color.dart';
import 'package:boards/theme/app_shadow.dart';
import 'package:boards/widgets/label.dart';
import 'package:flutter/material.dart';
import 'package:boards/utils/validators.dart';

class CustomDropDown extends StatefulWidget {
  /// Лист итемов для дроп дайна с одиночным выбором
  final List? item;

  /// Текстконтроллер для перехвата выбранного итема в стандартном дропдауне
  final TextEditingController? textController;

  /// Мапа для передачи итемов дропдауну с мультивыбором
  final Map<Color, String>? multiChoiceItems;

  /// Мапа с выбранными итемами.
  final Map<Color, String>? selectItems;

  /// Булевая переменная для выбора необходимости мультивыбора
  final bool needMultiChoice;

  /// Хинт текст для дропдауна
  final String? hintText;

  /// Нужен ли стандартный валидатор на заполненность
  final bool? needStandardValidator;

  /// Дополнительный валидатор после стандартных, если требуется(запрос)
  final Future<String?>? Function(String)? onReady;

  /// Функция при выборе итема
  final Function? onSelect;

  const CustomDropDown(
      {Key? key,
      this.item,
      this.needMultiChoice = false,
      this.hintText,
      this.multiChoiceItems,
      this.selectItems,
      this.textController,
      this.needStandardValidator,
      this.onReady,
      this.onSelect})
      : super(key: key);

  @override
  State<CustomDropDown> createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown> {
  bool _expansionItem = false;
  String? _textError;
  IconData _icon = Icons.keyboard_arrow_down_rounded;
  late TextEditingController _textController;
  Map<Color, String>? _multiChoiceItems;
  Map<Color, String>? _itemsMap;

  @override
  void initState() {
    super.initState();
    _textController = widget.textController ?? TextEditingController();
    _itemsMap = widget.selectItems ?? <Color, String>{};
    _multiChoiceItems = widget.multiChoiceItems ?? {};
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  /// List с ключами итемов
  List<Color> _typeColorItem() {
    return _multiChoiceItems!.entries.map((e) => e.key).toList();
  }

  /// List с values итемов
  List<String> _typeStringItem() {
    return _multiChoiceItems!.entries.map((e) => e.value).toList();
  }

  /// Функция на suffixIcon
  void _onTap() {
    if (_icon == Icons.clear) {
      _textController.clear();
      _icon = Icons.keyboard_arrow_down;
      setState(() {});
    } else {
      _expansionItem = true;
      setState(() {});
    }
  }

  /// Декорации инпута
  InputDecoration _inputDecoration(ThemeData theme) {
    return InputDecoration(
      focusedBorder: _icon == Icons.clear
          ? const OutlineInputBorder(borderSide: BorderSide.none)
          : null,
      errorText: null,
      fillColor:
          _icon == Icons.clear ? AppColor.textButton : AppColor.inputFillColor,
      errorStyle: theme.textTheme.caption!.copyWith(color: AppColor.cancel),
      hintText: widget.hintText ?? 'Выберите из списка',
      hintStyle: theme.textTheme.caption!
          .copyWith(color: AppColor.inputHint, letterSpacing: 0.25),
      suffixIcon: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
              onTap: _onTap,
              child: Icon(_icon,
                  color: _icon == Icons.clear
                      ? AppColor.focusTransparentButton
                      : AppColor.inputHint)),
          const SizedBox(width: 12)
        ],
      ),
      suffixIconConstraints: const BoxConstraints(maxHeight: 20),
    );
  }

  /// Фокус, анфокус инпута
  void _logicFocus(value, FormFieldState<bool> state) async {
    if (!value) {
      _expansionItem = false;
      setState(() {});
      _icon = Icons.keyboard_arrow_down_rounded;
      await getDropDownValidator(
              items: _itemsMap,
              requiredValidator: widget.needStandardValidator,
              itemSelect: _textController.text,
              needMultiChoice: widget.needMultiChoice,
              onReady: widget.onReady)
          .then((x) {
        _textError = x;
        state.validate();
      });
    }
    if (value) {
      _textError = null;
      state.validate();
    }
  }

  /// Действия при нажатии на выбранный итем
  void _onTapItem(index) {
    if (!widget.needMultiChoice) {
      _textController.text = widget.item![index];
      _icon = Icons.clear;
      _expansionItem = false;
      setState(() {});
      if (widget.onSelect != null) {
        widget.onSelect!(_textController.text);
      }
    }
    if (widget.needMultiChoice) {
      if (_itemsMap!.containsKey(_typeColorItem()[index])) {
        _itemsMap!.remove(_typeColorItem()[index]);
      } else {
        _itemsMap!.addAll({_typeColorItem()[index]: _typeStringItem()[index]});
      }
      if (widget.onSelect != null) {
        widget.onSelect!(_itemsMap);
      }
    }
  }

  /// Виджет отображения итемов дропдаун списка
  Container _dropDownList(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6),
      decoration: const BoxDecoration(
          color: AppColor.calendarFill, boxShadow: [AppShadow.formShadow]),
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: widget.needMultiChoice
              ? _typeStringItem().length
              : widget.item!.length,
          itemBuilder: (context, index) {
            return _ItemDropDown(
              onTap: () => _onTapItem(index),
              needMultiChoice: widget.needMultiChoice,
              itemColor:
                  widget.needMultiChoice ? _typeColorItem()[index] : null,
              item: widget.needMultiChoice
                  ? _typeStringItem()[index]
                  : widget.item![index],
              theme: theme,
              itemsSelect: _itemsMap!,
            );
          }),
    );
  }

  /// Отображение выбранных лейблов
  Align _viewSelectLabel(theme, FormFieldState<bool> state) {
    final List<Color> _itemColor =
        _itemsMap!.entries.map((e) => e.key).toList();
    final List<String> _itemString =
        _itemsMap!.entries.map((e) => e.value).toList();
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        children: [
          const SizedBox(height: 10),
          Wrap(
              spacing: 10,
              runSpacing: 10,
              children: List.generate(_itemColor.length, (index) {
                return Label(
                  colorLabel: _itemColor[index],
                  text: _itemString[index],
                  shadowLabel: false,
                  onTapClearButton: () async {
                    _itemsMap!.remove(_itemColor[index]);
                    await getDropDownValidator(
                            items: _itemsMap,
                            requiredValidator: widget.needStandardValidator,
                            needMultiChoice: widget.needMultiChoice)
                        .then((value) {
                      _textError = value;
                      state.validate();
                    });
                    setState(() {});
                  },
                );
              })),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);
    return FormField<bool>(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      initialValue: false,
      validator: (_) => _textError,
      builder: (state) => FocusScope(
        onFocusChange: (value) => _logicFocus(value, state),
        child: Column(
          children: [
            TextFormField(
                onTap: () {
                  _expansionItem = true;
                  setState(() {});
                },
                controller: _textController,
                style: _theme.textTheme.headline3!.copyWith(
                    color: _icon == Icons.clear
                        ? AppColor.focusTransparentButton
                        : null),
                cursorColor: AppColor.textButton,
                readOnly: true,
                decoration: _inputDecoration(_theme)),
            if (_expansionItem == true) _dropDownList(_theme),
            if (_expansionItem == false && _itemsMap!.isNotEmpty)
              _viewSelectLabel(_theme, state),
            if (state.hasError)
              _ErrorWidget(
                theme: _theme,
                state: state,
              )
          ],
        ),
      ),
    );
  }
}

/// Виджет итема
class _ItemDropDown extends StatefulWidget {
  final ThemeData theme;
  final Color? itemColor;
  final String item;
  final bool? needMultiChoice;
  final Function onTap;
  final Map<Color, String> itemsSelect;

  const _ItemDropDown(
      {Key? key,
      required this.item,
      required this.theme,
      this.needMultiChoice,
      this.itemColor,
      required this.onTap,
      required this.itemsSelect})
      : super(key: key);

  @override
  State<_ItemDropDown> createState() => _ItemDropDownState();
}

class _ItemDropDownState extends State<_ItemDropDown> {
  Color _hoverColor = Colors.transparent;

  void _onEnter(value) {
    _hoverColor = AppColor.checkBoxUnSelectedSide;
    setState(() {});
  }

  void _onExit(value) {
    _hoverColor = Colors.transparent;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.needMultiChoice == true) {
          setState(() {});
        }
        widget.onTap();
      },
      child: MouseRegion(
          onEnter: _onEnter,
          onExit: _onExit,
          cursor: SystemMouseCursors.click,
          child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 7),
              color: _hoverColor,
              child: Row(
                children: [
                  if (widget.needMultiChoice == true)
                    Row(
                      children: [
                        widget.itemsSelect.containsKey(widget.itemColor)
                            ? const Icon(Icons.done,
                                color: AppColor.arrowLight, size: 12)
                            : const SizedBox(width: 12),
                        Container(
                          margin: const EdgeInsets.only(left: 11, right: 16),
                          width: 14,
                          height: 14,
                          decoration: BoxDecoration(
                              color: widget.itemColor,
                              borderRadius: BorderRadius.circular(1.5)),
                        )
                      ],
                    ),
                  Flexible(
                    child: Text(
                      widget.item,
                      style: widget.theme.textTheme.button!.copyWith(
                          color: AppColor.arrowLight, letterSpacing: 0.22),
                    ),
                  ),
                ],
              ))),
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
