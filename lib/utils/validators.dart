/// Пак валидаторов для инпутов
Future<String?> getValidator(
    {String? type,
    required String value,
    bool? requiredValidator,
    Future<String?>? Function(String)? onReady,
    bool? needRequest}) async {
  /// Обязательный валидатор
  if (value.isEmpty && requiredValidator == true) {
    return 'Поле обязательно к заполнению';
  }

  switch (type) {

    /// Валидатор почты
    case 'email':
      if (value.isEmpty) {
        return 'Email не может быть пустым';
      }
      Pattern pattern =
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regex = RegExp(pattern.toString());
      if (!regex.hasMatch(value)) {
        return 'Введите валидный email адрес';
      }
      if (onReady != null) {
        final errorText = await onReady(value);
        if (errorText != null) {
          return errorText;
        }
      }
      return null;

    /// Валидатор пароля
    case 'password':
      if (value.isEmpty) {
        return 'Пароль не может быть пустым';
      }
      Pattern pattern = r'^[A-Za-z0-9\!\@\#\$\&\*\~]{6,}$';
      RegExp regex = RegExp(pattern.toString());
      if (!regex.hasMatch(value)) {
        return 'Минимальное кол-во символов - 6';
      }
      return null;
  }

  /// Валидатор сетевого запроса, после всех стандартных
  if (needRequest == true &&
      onReady != null &&
      type != 'email' &&
      value.isNotEmpty) {
    final errorText = await onReady(value);
    if (errorText != null) {
      return errorText;
    }
  }
  return null;
}

/// пак валидаторов для чекбоксов и туггле кнопок
Future<String?> getBoolValidator(
    {required bool value,
    bool? requiredValidator,
    Future<String?>? Function(bool)? onReady}) async {
  /// Стандартный валидатор
  if (!value && requiredValidator == true) {
    return 'Подтвердите чтобы продолжить';
  }

  /// Валидатор сетевого запроса
  if (onReady != null && value) {
    final errorText = await onReady(value);
    if (errorText != null) {
      return errorText;
    }
  }
  return null;
}

/// пак валидаторов для DropDown
Future<String?> getDropDownValidator(
    {String? itemSelect,
    Map? items,
    bool needMultiChoice = false,
    bool? requiredValidator,
    Future<String?>? Function(String)? onReady}) async {
  /// Стандартный валидатор
  if (itemSelect != null && !needMultiChoice) {
    if (itemSelect.isEmpty && requiredValidator == true) {
      return 'Выберите чтобы продолжить';
    }
  }

  /// Стандартный валидатор для дропдауна с мультивыбором
  if (items != null && needMultiChoice == true) {
    if (items.isEmpty && requiredValidator == true) {
      return 'Выберите чтобы продолжить';
    }
  }

  /// Валидатор сетевого запроса
  if (itemSelect != null) {
    if (onReady != null && itemSelect.isNotEmpty) {
      final errorText = await onReady(itemSelect.toString());
      if (errorText != null) {
        return errorText;
      }
    }
  }
  return null;
}
