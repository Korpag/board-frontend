import 'package:flutter/material.dart';

import 'package:boards/theme/app_color.dart';

import 'package:boards/widgets/button.dart';
import 'package:boards/widgets/custom_card.dart';
import 'package:boards/widgets/custom_form.dart';
import 'package:boards/widgets/label.dart';
import 'package:boards/widgets/markdown_editor.dart';

/// Страница для отображения имеющихся виджетов
class DemonstrationPage extends StatelessWidget {
  const DemonstrationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Button.add(onTap: () {}),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Button.buttonTransparent(onTap: () {}),
                    ),
                    Button.cancel(onTap: () {}),
                  ],
                ),
                const SizedBox(height: 50),
                Center(
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 21,
                    children: const [
                      Label(text: 'Выполнено', colorLabel: AppColor.green),
                      Label(text: 'Ошибка', colorLabel: AppColor.red),
                      Label(text: 'Тест', colorLabel: AppColor.orange),
                      Label(text: 'Доработка', colorLabel: AppColor.purple),
                      Label(
                          text: 'Отмена',
                          colorLabel: AppColor.yellow,
                          colorText: Color(0xff1F2D39)),
                      Label(text: 'Блокировка', colorLabel: AppColor.blue),
                    ],
                  ),
                ),
                const SizedBox(height: 50),
                const MarkDownEditor(),
                const SizedBox(height: 50),
                Wrap(spacing: 50, runSpacing: 20, children: [
                  CustomCard(
                    shortDescription:
                        'Создание виджета Markdown, который будет соответствовать высоким стандартам нашей компании',
                    items: {Colors.teal: 'Создание'},
                  ),
                  CustomCard(
                    shortDescription:
                        'Доработка существующего виджета CustomForm. Опираясь на новые вводные, стоит исправить несколько нюансов, подробности в карточке.',
                    items: {AppColor.purple: 'Доработка'},
                    taskID: 'issue 12',
                  ),
                  CustomCard(
                    shortDescription:
                        'Сборная солянка в карточке. Стоит выполнить все. Тут вам и правки и доработки и тесты, а так же ошибки. Для чего все это? Простая демонстрация возможностей, не более. Кстати, забыл, выполнивший эту задачу, получит что-то интересное, ну или ничего.',
                    items: {
                      AppColor.purple: 'Доработка',
                      AppColor.green: 'Выполнено',
                      AppColor.orange: 'Тест',
                      AppColor.blue: 'Блокировка',
                      AppColor.red: 'Ошибка'
                    },
                  ),
                  CustomCard(
                    shortDescription: 'Верстка виджета Markdown',
                    items: {
                      AppColor.blue: 'Блокировка',
                      AppColor.red: 'Ошибка'
                    },
                  ),
                ]),
                const SizedBox(height: 50),
                CustomForm.text(
                    editInput: true,
                    textController: TextEditingController()
                      ..text =
                          'Специальный редактируемый инпут с подсвечиваемым полем ввода'),
                const SizedBox(height: 50),
                CustomForm.text(),
                const SizedBox(height: 50),
                CustomForm.text(
                    editInput: true,
                    textController: TextEditingController()
                      ..text =
                          'Пользователь test@mail.ru - для проверки работы ассинхронности и лоадера'),
                const SizedBox(height: 10),
                CustomForm.email(onReady: (value) async {
                  await Future.delayed(const Duration(seconds: 1));
                  return value == 'test@mail.ru'
                      ? 'Пользователь существует'
                      : null;
                }),
                const SizedBox(height: 50),
                CustomForm.password(),
                const SizedBox(height: 50),
                SizedBox(
                  width: 210,
                  child: CustomForm.date(),
                ),
                const SizedBox(height: 50),
                SizedBox(
                  width: 350,
                  child: CustomForm.date(needRangeDate: true),
                ),
                const SizedBox(height: 50),
                CustomForm.phone(),
                const SizedBox(height: 50),
                CustomForm.dropDown(
                    item: List.generate(5, (index) => 'Элемент ${index + 1}')),
                const SizedBox(height: 50),
                CustomForm.dropDown(
                    needStandardValidator: true,
                    hintText: 'Выберите из списка (Обязательное поле)',
                    item: List.generate(5, (index) => 'Элемент ${index + 1}')),
                const SizedBox(height: 50),
                CustomForm.multiChoiceDropDown(item: {
                  Colors.deepOrange: 'Отмена',
                  Colors.blue: 'Ошибка',
                  const Color(0xffd12344): 'Тест',
                  Colors.purple: 'Доработка'
                }, hintText: 'Выберите лейбл'),
                const SizedBox(height: 50),
                CustomForm.checkBox(
                  text: 'Стандартный CheckBox',
                ),
                const SizedBox(height: 10),
                CustomForm.checkBox(
                  text: 'Обязательный CheckBox',
                  needStandardValidator: true,
                ),
                const SizedBox(height: 10),
                CustomForm.checkBox(
                    text: 'Проверка ассинхронного запроса (успешного)',
                    onReady: (value) async {
                      await Future.delayed(const Duration(seconds: 1));
                      return value == false ? 'Упс, что-то пошло не так' : null;
                    }),
                const SizedBox(height: 50),
                Row(
                  children: [
                    CustomForm.toggle(),
                    CustomForm.toggle(),
                    CustomForm.toggle(),
                  ],
                ),
                const SizedBox(height: 10),
                CustomForm.toggle(text: 'Стандартная Toggle-кнопка'),
                const SizedBox(height: 10),
                CustomForm.toggle(
                    text: 'Обязательная Toggle-кнопка',
                    needStandardValidator: true),
                const SizedBox(height: 10),
                CustomForm.toggle(
                    text: 'Проверка ассинхронного запроса (неуспешного)',
                    onReady: (value) async {
                      await Future.delayed(const Duration(seconds: 1));
                      return value == true ? 'Упс, что-то пошло не так' : null;
                    }),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
