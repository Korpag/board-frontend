import 'package:boards/theme/app_color.dart';
import 'package:boards/widgets/button.dart';
import 'package:boards/widgets/custom_form.dart';
import 'package:flutter/material.dart';

class MarkDownEditor extends StatefulWidget {
  final TextEditingController? textController;

  const MarkDownEditor({Key? key, this.textController}) : super(key: key);

  @override
  State<MarkDownEditor> createState() => _MarkDownEditorState();
}

class _MarkDownEditorState extends State<MarkDownEditor> {
  double _heightInput = 150;
  late double _heightInputUpdate;

  /// Виджет изменения размера рабочего поля редактора
  Align _resizeWidget() {
    return Align(
      alignment: Alignment.bottomRight,
      child: MouseRegion(
        cursor: SystemMouseCursors.resizeDown,
        child: GestureDetector(
          onPanStart: (details) {
            _heightInputUpdate = _heightInput;
            if (_heightInputUpdate < 150) {
              _heightInputUpdate = 150;
            }
          },
          onPanUpdate: (details) {
            _heightInput = _heightInputUpdate + details.localPosition.dy;
            setState(() {});
          },
          child: const Icon(
            Icons.signal_cellular_4_bar_rounded,
            size: 18,
            color: AppColor.inputFillColor,
          ),
        ),
      ),
    );
  }

  /// Типовая декорация
  BoxDecoration _boxDecoration({Color fillColor = AppColor.markdownEditor}) {
    return BoxDecoration(
        borderRadius: BorderRadius.circular(3.5),
        border:
        Border.all(color: AppColor.checkBoxUnSelectedSide, width: 0.5),
        color: fillColor);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(7),
      decoration: _boxDecoration(),
      child: Column(
        children: [
          CustomForm.text(
              fillColor: AppColor.markdownInput,
              textController: widget.textController),
          const SizedBox(height: 13),
          Container(
            constraints: const BoxConstraints(minHeight: 150),
            width: double.infinity,
            height: _heightInput,
            decoration: _boxDecoration(fillColor: AppColor.markdownInput),
            child: Stack(
              children: [_resizeWidget()],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Button.noFeedBack(text: 'Отменить', onTap: () {}, noColorButton: true, colorButton: AppColor.textButton),
              const SizedBox(width: 10),
              Button.noFeedBack(text: 'Сохранить', onTap: () {})
            ],
          )
        ],
      ),
    );
  }
}
