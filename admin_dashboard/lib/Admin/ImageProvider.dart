import 'package:flutter/material.dart';
import 'package:image_picker_windows/image_picker_windows.dart';
import 'package:riverpod/riverpod.dart';

final imagePickerProvider = Provider<ImagePickerWindows>((ref) {
  return ImagePickerWindows();
});
