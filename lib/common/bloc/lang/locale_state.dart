import 'package:flutter/material.dart';

abstract class LocaleState {}

class LocaleLoading extends LocaleState {}

class LocaleLoaded extends LocaleState {
  final Locale locale;
  LocaleLoaded(this.locale);
}
