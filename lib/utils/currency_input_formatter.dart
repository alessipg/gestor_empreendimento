import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CurrencyInputFormatter extends TextInputFormatter {
  final NumberFormat _formatter = NumberFormat.currency(
    locale: 'pt_BR', // or 'en_US'
    symbol: 'R\$',
    decimalDigits: 2,
  );

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Remove all non-digits
    String digits = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    if (digits.isEmpty) {
      return newValue.copyWith(text: '');
    }

    // Parse cents → divide by 100
    double value = double.parse(digits) / 100;

    // Format with 2 decimals
    final newText = _formatter.format(value);

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }

  // Método utilitário para obter o valor numérico a partir do texto formatado
  static double getCleanValue(String text) {
    if (text.isEmpty) return 0.0;

    // Remove todos os caracteres que não são dígitos, vírgula ou ponto
    final cleaned = text.replaceAll(RegExp(r'[^\d,.]'), '');

    // remove all thousand separators (.)
    String noDots = cleaned.replaceAll('.', '');
    // replace decimal comma with dot
    String normalized = noDots.replaceAll(',', '.');

    return double.parse(normalized);
  }
}
