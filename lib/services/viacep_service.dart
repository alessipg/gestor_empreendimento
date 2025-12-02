import 'package:http/http.dart' as http;
import 'dart:convert';

class ViaCepService {
  static Future<Map<String, dynamic>?> buscarCep(String cep) async {
    final cepLimpo = cep.replaceAll(RegExp(r'[^0-9]'), '');
    if (cepLimpo.length != 8) return null;

    final url = Uri.parse('https://viacep.com.br/ws/$cepLimpo/json/');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['erro'] != null) return null;
        return {
          'cep': data['cep'],
          'logradouro': data['logradouro'],
          'bairro': data['bairro'],
          'localidade': data['localidade'],
          'uf': data['uf'],
        };
      }
    } catch (e) {
      print('Erro ao buscar CEP: $e');
    }
    return null;
  }
}
