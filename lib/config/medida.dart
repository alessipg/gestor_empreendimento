enum Medida {
  //g('g', 'gramas'),
  kg('kg', 'quilogramas'),
  l('l', 'litros'),
  //ml('ml', 'mililitros'),
  un('un', 'unidades');

  final String sigla;
  final String nome;
  const Medida(this.sigla, this.nome);

  static Medida fromString(String value) {
    switch (value.toLowerCase()) {
      case 'kg':
        return Medida.kg;
      case 'l':
        return Medida.l;
      case 'un':
        return Medida.un;
      default:
        throw ArgumentError('Invalid Medida value: $value');
    }
  }
}
