import 'package:flutter/cupertino.dart';

import 'app_color.dart';

abstract class AppShadow {
  static const BoxShadow formShadow = BoxShadow(
      color: AppColor.inputFillColor, offset: Offset(2, 2), blurRadius: 5);
}
