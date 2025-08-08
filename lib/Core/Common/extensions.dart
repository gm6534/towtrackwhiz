import 'package:flutter/material.dart';

extension TextStyles on BuildContext {
  TextTheme get appTextStyles => Theme.of(this).textTheme;
}
