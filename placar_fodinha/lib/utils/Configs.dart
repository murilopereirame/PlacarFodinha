import 'package:placar_fodinha/utils/Database.dart';

class Configs {
  static Configs instance;

  var db = DatabaseHandler();

  int maxPontos;

  List<String> gameOverFalas = ['O jogador {0} é muito lixo! Perdeu man!', 'Perdeu PlayBoy! Vai aprender a jogar!', 'Alguém ensina o {0} a jogar!', 'When I see you again.. OOOOOOOO' ];
  List<String> doisPontosFalas = ['Ta sentando na mandioca em filhão!', 'Quem é Mia Khalifa perto de você!', 'Kid Bengala mandou abraços', 'Já virou buraco negro!' ];
  List<String> novoJogoFalas = ['Bom jogo a todos!', 'New game? Boa!', 'Abraços do tio Kid! Bom jogo' ];

  bool darkTheme = false;
  bool manterTela = true;
  bool habilitarFala = true;

  static Configs getInstance() {
    if(instance == null) {
      instance = new Configs();
    }

    return instance;
  }

  void carregarConfiguracoes() async {
    gameOverFalas = await db.obterFrases('GameOver');
    doisPontosFalas = await db.obterFrases('DoisPontos');
    novoJogoFalas = await db.obterFrases('NovoJogo');

    Map<String, int> configs = await db.obterConfigs('Config');

    (configs['darkMode'] == 1) ? this.darkTheme = true : this.darkTheme = false;
    (configs['manterTela'] == 1) ? this.manterTela = true : this.manterTela = false;
    (configs['habilitarFala'] == 1) ? this.habilitarFala = true : this.habilitarFala = false;

    this.maxPontos = configs['maximoPontos'];
  }

  int getMaxPontos() {
    return this.maxPontos;
  }

  void setMaxPontos(int pontos) {
    this.maxPontos = pontos;
  }

  void setDark() {
    this.darkTheme = true;
  }

  void setLight() {
    this.darkTheme = false;
  }

  void addNovaFala(String fala, int qtde) {
    if(qtde == 0)
      gameOverFalas.add(fala);
    else if(qtde == 2)
      doisPontosFalas.add(fala);
    else if(qtde == -1)
      novoJogoFalas.add(fala);
  }

  bool getTheme() {
    return this.darkTheme;
  }

  bool getManterTela() {
    return this.manterTela;
  }

  bool getHabilitarFala() {
    return this.habilitarFala;
  }

  void setManterTela(bool value) {
    this.manterTela = value;
  }

  void setHabilitarFala(bool value) {
    this.habilitarFala = value;
  }

  List<String> getFalasBoasVindas() {
    return this.novoJogoFalas;
  }

  List<String> getFalasGameOver() {
    return this.gameOverFalas;
  }

  List<String> getFalasDoisPontos() {
    return this.doisPontosFalas;
  }

  void removerFala(String fala, int tipo) {
    if(tipo == -1) {
      novoJogoFalas.remove(fala);
    } else if(tipo == 0) {
      gameOverFalas.remove(fala);
    } else if(tipo == 2) {
      doisPontosFalas.remove(fala);
    }
  }
}