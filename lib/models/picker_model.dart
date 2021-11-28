import 'package:flutter/material.dart';

class PickerModel {
  const PickerModel(this.name, {required this.code, required this.icon});
  final String name;
  final Object code;
  final Icon icon;

  @override
  String toString() => name;
}