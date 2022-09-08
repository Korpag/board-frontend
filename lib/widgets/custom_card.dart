import 'package:boards/theme/app_color.dart';
import 'package:boards/widgets/label.dart';
import 'package:flutter/material.dart';

class CustomCard extends StatefulWidget {
  /// Идентификатор задачи
  final String taskID;

  /// Итемы лейблов
  final Map<Color, String>? items;

  /// Функия при нажатии на карточку
  final Function? onTap;

  /// Краткое описание
  final String shortDescription;

  /// Строка для аватарки
  final String? avatar;

  const CustomCard(
      {Key? key,
      this.onTap,
      this.shortDescription = '',
      this.items,
      this.taskID = 'ИДЕНТИФИКАТОР ЗАДАЧИ',
      this.avatar})
      : super(key: key);

  @override
  State<CustomCard> createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  Color _colorCard = AppColor.calendarFill;
  double _widthBorder = 0.25;
  Color _colorBorder = AppColor.inputUnSelectedBorder;
  double _widthHoverSizedBox = 41;

  /// Наведение на каточку
  void _onEnter(value) {
    if (_colorCard != AppColor.inputUnSelectedBorder) {
      _colorCard = AppColor.cardHover;
      _widthHoverSizedBox = 17;
    }
    setState(() {});
  }

  /// Выход из зоны карточки
  void _onExit(value) {
    if (_colorCard != AppColor.inputUnSelectedBorder) {
      _colorCard = AppColor.calendarFill;
      _widthHoverSizedBox = 41;
    }
    setState(() {});
  }

  /// Функция по нажатию на карточку
  void _onTap() {
    if (_colorCard == AppColor.inputUnSelectedBorder) {
      _colorCard = AppColor.cardHover;
      _widthBorder = 0.25;
      _colorBorder = AppColor.inputUnSelectedBorder;
      _widthHoverSizedBox = 17;
    } else {
      _colorCard = AppColor.inputUnSelectedBorder;
      _widthBorder = 2;
      _colorBorder = AppColor.cardBorderHover;
      _widthHoverSizedBox = 41;
    }
    if (widget.onTap != null) {
      widget.onTap!();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);
    return InkWell(
      onTap: _onTap,
      child: MouseRegion(
        onEnter: _onEnter,
        onExit: _onExit,
        child: Container(
          padding:
              const EdgeInsets.only(top: 20, left: 17, right: 17, bottom: 12),
          width: 400,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3.5),
              border: Border.all(color: _colorBorder, width: _widthBorder),
              color: _colorCard),
          child: Column(
            children: [
              /// Верхняя часть карточки
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Короткое описание карточки
                  Flexible(
                    child: Container(
                      constraints: const BoxConstraints(minHeight: 24),
                      child: Text(widget.shortDescription,
                          maxLines: 5,
                          overflow: TextOverflow.ellipsis,
                          style: _theme.textTheme.headline3!
                              .copyWith(fontSize: 14, letterSpacing: 0.25)),
                    ),
                  ),

                  /// Отображаемые три точки при наведении
                  Row(
                    children: [
                      SizedBox(width: _widthHoverSizedBox),
                      if (_widthHoverSizedBox == 17)
                        const Icon(Icons.more_vert_rounded,
                            color: AppColor.arrowLight)
                    ],
                  )
                ],
              ),

              /// Нижняя часть карточки. После короткого описания
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 15),

                        /// Отображение лейблов
                        if (widget.items != null)
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: List.generate(
                                widget.items!.length,
                                (index) => Label(
                                      colorLabel: widget.items!.entries
                                          .map((e) => e.key)
                                          .toList()[index],
                                      text: widget.items!.entries
                                          .map((e) => e.value)
                                          .toList()[index],
                                    )),
                          ),

                        /// Отображение идентификатора
                        if (widget.items != null) const SizedBox(height: 15),
                        Text(widget.taskID.toUpperCase(),
                            style: _theme.textTheme.caption)
                      ],
                    ),
                  ),

                  /// Отображение аватарки (Позже раскоммитить, убрать хард)
                  // if (widget.avatar != null)
                  SizedBox(
                    height: 35,
                    width: 35,
                    child: ClipOval(
                        child: Image.network('lib/assets/avatar.jpg',
                            fit: BoxFit.cover)
                        //     Image.network(
                        //   widget.avatar!,
                        //   fit: BoxFit.cover,
                        // )
                        ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
