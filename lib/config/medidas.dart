enum Medidas {
  gramas('g'),
  quilogramas('kg'),
  litros('L'),
  mililitros('ml'),
  unidade('un');

  const Medidas(this.sigla);
  final String sigla;
}