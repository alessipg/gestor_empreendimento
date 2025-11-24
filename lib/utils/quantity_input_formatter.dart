import 'package:flutter/services.dart';
import 'dart:math' as math;

class QuantityInputFormatter extends TextInputFormatter {
  static const int decimalDigits = 3; // sempre 3 casas

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Mantém só os dígitos
    final digitsOnly = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    if (digitsOnly.isEmpty) {
      return const TextEditingValue(text: '');
    }

    // Converte para número com 3 casas fixas
    final number = double.parse(digitsOnly) / math.pow(10, decimalDigits);

    final formatted = number.toStringAsFixed(decimalDigits);

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

  /// Utilitário para recuperar o valor real
  static double getCleanValue(String text) {
    if (text.isEmpty) return 0.0;
    return double.tryParse(text.replaceAll(',', '.')) ?? 0.0;
  }
}
