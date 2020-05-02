import 'dart:math';

import 'package:flutter/material.dart';
import 'package:placar_fodinha/classes/Jogador.dart';
import 'package:placar_fodinha/utils/Configs.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:screen/screen.dart';

class NovoJogo extends StatefulWidget {
  NovoJogo({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _NovoJogoState createState() => _NovoJogoState();
}

class _NovoJogoState extends State<NovoJogo> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController nome = new TextEditingController();
  List<Jogador> players = new List<Jogador>();

  FlutterTts flutterTts = FlutterTts();

  static AudioCache _player = AudioCache();
  static const _audioPath = "sounds/fode.mp3";

  Future<AudioPlayer> playAudio() async {
    return _player.play(_audioPath, volume: 1.5);
  }

  @override
  void initState() {
    super.initState();
    flutterTts.setLanguage('pt-BR');
    flutterTts.setVolume(2.0);

    if(Configs.getInstance().getManterTela())
      Screen.keepOn(true);
    else
      Screen.keepOn(false);
  }

  void playFode() {
    playAudio();
  }

  Widget montarListaJogadores() {
    List<Widget> childrens = new List<Widget>();

    for(int i = 0; i < players.length; i++) {
      childrens.add(
        Row(
          children: <Widget>[
            SizedBox(
              width: MediaQuery.of(context).size.width/2.0,
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: MediaQuery.of(context).size.width/3.0,
                    child: Padding(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: Text(
                        players[i].getNome(),
                        style: TextStyle(
                          fontFamily: 'Poison',
                          fontSize: 23,
                          color: (players[i].perdeu()) ? Colors.red : Configs.getInstance().getTheme() ? Colors.white : Colors.black
                        )
                      )
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width/8.0,
                    child: Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: Text(
                        players[i].getPontos().toString(),
                        style: TextStyle(
                          fontFamily: 'Poison',
                          fontSize: 23
                        )
                      ),
                    ),
                  )
                ],
              )  
            ),    
            SizedBox(
              width: MediaQuery.of(context).size.width/2.0,
              child: Row(
                children: <Widget>[                
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: RaisedButton(
                        onPressed: () => addPonto(i),
                        child: Wrap(
                          children: <Widget>[
                            Icon(Icons.exposure_plus_1)
                          ]
                        )
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: RaisedButton(
                        child: Wrap(
                          children: <Widget>[ 
                            Icon(Icons.exposure_neg_1),
                          ]
                        ),
                        onPressed: () => removePonto(i),
                      )
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: RaisedButton(
                        child: Wrap(
                          children: <Widget>[ 
                            Icon(Icons.delete),
                          ]
                        ),
                        onPressed: () => removerJogador(i),
                      )
                    )
                  )
                ]
              )                        
            )
          ],
        )
      );
    }

    return Column(
      children: childrens,
    );
  }

  void removerJogador(int index) {
    setState(() {
      this.players.removeAt(index);
    });
  }

  void addJogador() {
    if(nome.text == '') {
      _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('O nome do jogador não pode ser nulo!')));
      return;
    }

    setState(() {
      this.players.add(new Jogador(nome.text));
      nome.text = '';
    });

    if(this.players.length == 2 && Configs.getInstance().novoJogoFalas.length > 0 && Configs.getInstance().getHabilitarFala()) {
      Random random = new Random();
      int index = random.nextInt(Configs.getInstance().novoJogoFalas.length);
      flutterTts.speak(Configs.getInstance().novoJogoFalas[index]);
    }
  }

  void removePonto(int index) {
    if((this.players[index].getPontos() - 1) == 0) {
      this.players[index].perder();
      _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(this.players[index].getNome() + ' perdeu!')));
      
      if(Configs.getInstance().novoJogoFalas.length > 0  && Configs.getInstance().getHabilitarFala()) {
        Random random = new Random();
        int indexFalas = random.nextInt(Configs.getInstance().gameOverFalas.length);
        flutterTts.speak(Configs.getInstance().gameOverFalas[indexFalas].replaceAll('{0}', this.players[index].getNome()));
      }
    } else if((this.players[index].getPontos() - 1) < 0) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('Os pontos não podem ser negativos!')));
      return;
    }

    if((this.players[index].getPontos() - 1) == 2 && Configs.getInstance().novoJogoFalas.length > 0  && Configs.getInstance().getHabilitarFala()) {
      Random random = new Random();
      int indexFalas = random.nextInt(Configs.getInstance().doisPontosFalas.length);
      flutterTts.speak(Configs.getInstance().doisPontosFalas[indexFalas].replaceAll('{0}', this.players[index].getNome()));
    }

    setState(() {
      this.players[index].removerPonto();
    });


  }

  void addPonto(int index) {
    if(this.players[index].perdeu()) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('Este(a) jogador(a) já perdeu!')));
      return;
    }
    else if((this.players[index].getPontos() + 1) > Configs.getInstance().getMaxPontos()){
      _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('O número máximo de pontos é ' + Configs.getInstance().getMaxPontos().toString())));
      return;
    }

    setState(() {
      this.players[index].addPonto();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Padding(
        padding: EdgeInsets.only(top: 30),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text(
                      'Jogador:',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poison'
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: TextField(
                        controller: nome,
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 20,                          
                          fontFamily: 'Poison',                                                 
                        ),
                        decoration: InputDecoration(
                          
                        ),
                      ),
                    )
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: MaterialButton(
                      minWidth: 10,
                      onPressed: addJogador,                      
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Icon(
                          Icons.add,
                        )
                      ),
                    ),
                  ),
                   Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width - 285,
                      child: FlatButton(
                        onPressed: playFode,
                        child: Text(
                          'FODE!',
                          style: TextStyle(

                          ),
                        )
                      ),
                    ),
                  ),
                ],
              )
            ),
            Expanded(
              child: SingleChildScrollView(
                child: montarListaJogadores()
              )
            ),
          ],
        ),
      )
    );
  }
}