import 'package:http/http.dart' as http;
import 'dart:convert';

class ReceitawsService {
  static Future<Map<String, dynamic>?> buscarCnpj(String cnpj) async {
    final cnpjLimpo = cnpj.replaceAll(RegExp(r'[^0-9]'), '');
    if (cnpjLimpo.length != 14) return null;

    final url = Uri.parse('https://www.receitaws.com.br/v1/cnpj/$cnpjLimpo');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'ERROR') return null;
        return {
          'nome': data['nome'] ?? data['fantasia'],
          'telefone': data['telefone']?.replaceAll(RegExp(r'[^0-9]'), ''),
          'email': data['email'],
          'cep': data['cep']?.replaceAll(RegExp(r'[^0-9]'), ''),
          'logradouro': data['logradouro'],
          'numero': data['numero'],
          'bairro': data['bairro'],
          'municipio': data['municipio'],
          'uf': data['uf'],
        };
      }
    } catch (e) {
      print('Erro ao buscar CNPJ: $e');
    }
    return null;
  }
}
