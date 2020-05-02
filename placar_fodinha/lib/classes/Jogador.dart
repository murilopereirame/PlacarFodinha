import 'package:placar_fodinha/utils/Configs.dart';

class Jogador {
  String nome;
  int pontos;
  bool gameover;

  Jogador(String nome) {
    this.nome = nome;
    this.gameover = false;
    pontos = Configs.getInstance().getMaxPontos();
  }

  void removerPonto() {
    this.pontos--;
  }

  void addPonto() {
    this.pontos++;
  }

  void perder() {
    this.gameover = true;
  }

  String getNome() {
    return this.nome;
  }

  int getPontos() {
    return this.pontos;
  }

  bool perdeu() {
    return this.gameover;
  }
}