import 'package:flutter/material.dart';
import 'package:placar_fodinha/utils/Configs.dart';
import 'package:placar_fodinha/utils/Database.dart';
import 'package:dynamic_theme/dynamic_theme.dart';

class Configuracoes extends StatefulWidget {
  Configuracoes({Key key}) : super(key: key);

  @override
  _ConfiguracoesState createState() => _ConfiguracoesState();
}

class _ConfiguracoesState extends State<Configuracoes> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController _pontos = new TextEditingController(text: Configs.getInstance().getMaxPontos().toString());

  TextEditingController _frase = new TextEditingController();
   
  _displayDialog(BuildContext context, int tipo) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Insira a frase desejada'),
          content: TextField(
            controller: _frase,
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text('Adicionar'),
              onPressed: () {
                addFrase(tipo, _frase.text);
                Navigator.of(context).pop();
              },
            )
          ],
        );
      }
    );
  }

  _confirmaRemove(BuildContext context, int tipo, String frase) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Tem certeza que deseja remover a frase?'),        
          actions: <Widget>[
            new FlatButton(
              child: new Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text('Remover'),
              onPressed: () {
                deletarFrase(frase, tipo);
                Navigator.of(context).pop();
              },
            )
          ],
        );
      }
    );
  }

  void addFrase(int tipo, String frase) {
    setState(() {
      Configs.getInstance().addNovaFala(frase, tipo);
    });    

    String table = '';

    switch(tipo) {
      case 0:
        table = 'GameOver';
      break;

      case 2:
        table = 'DoisPontos';
      break;

      case -1:
        table = 'NovoJogo';
      break;

      default:
        return;
      break;
    }

    DatabaseHandler db = new DatabaseHandler();
    db.inserirFrase(frase, table);
  }

  void deletarFrase(String frase, int tipo) {
    setState(() {
      Configs.getInstance().removerFala(frase, tipo);
    });    

    String table = '';

    switch(tipo) {
      case 0:
        table = 'GameOver';
      break;

      case 2:
        table = 'DoisPontos';
      break;

      case -1:
        table = 'NovoJogo';
      break;

      default:
        return;
      break;
    }
    
    DatabaseHandler db = new DatabaseHandler();
    db.deletarFrase(frase, table);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        DatabaseHandler db = new DatabaseHandler();

        Configs.getInstance().setMaxPontos(int.parse(_pontos.text));

        int darkMode = Configs.getInstance().getTheme() ? 1 : 0;
        int maximoPontos = int.parse(_pontos.text);
        int manterTela = Configs.getInstance().getManterTela() ? 1 : 0;
        int habilitarFala = Configs.getInstance().getHabilitarFala() ? 1 : 0;

        db.atualizarConfigs(darkMode, maximoPontos, manterTela, habilitarFala);

        setState(() {
          Configs.getInstance().getTheme() ? DynamicTheme.of(context).setBrightness(Brightness.dark) : DynamicTheme.of(context).setBrightness(Brightness.light);
        });        

        return true;
      },
      child:Scaffold(
        key: _scaffoldKey,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(top: 30, left: 10, right: 10, bottom: 30),
            child:Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget> [
                Row(
                  children: <Widget> [
                    Expanded(
                      flex: 8,
                      child: Text(
                        'Utilizar tema escuro',
                        style: TextStyle(
                          fontFamily: 'Poison',
                          fontSize: 23,
                        )
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Switch(
                        value: Configs.getInstance().getTheme(),
                        onChanged: (value) {
                          setState(() {
                            if(value)
                              Configs.getInstance().setDark();
                            else
                              Configs.getInstance().setLight();
                          });
                        },
                        activeTrackColor: Colors.redAccent, 
                        activeColor: Colors.red,
                      ),
                    ),
                  ]
                ),
                Row(
                  children: <Widget> [
                    Expanded(
                      flex: 8,
                      child: Text(
                        'Manter tela acesa',
                        style: TextStyle(
                          fontFamily: 'Poison',
                          fontSize: 23,
                        )                      
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Switch(
                        value: Configs.getInstance().getManterTela(),
                        onChanged: (value) {
                          setState(() {
                            Configs.getInstance().setManterTela(value);
                          });
                        },
                        activeTrackColor: Colors.redAccent, 
                        activeColor: Colors.red,
                      ),
                    ),
                  ]
                ),
                Row(
                  children: <Widget> [
                    Expanded(
                      flex: 8,
                      child: Text(
                        'Habilitar falas',
                        style: TextStyle(
                          fontFamily: 'Poison',
                          fontSize: 23,
                        ) 
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Switch(
                        value: Configs.getInstance().getHabilitarFala(),
                        onChanged: (value) {
                          setState(() {
                            Configs.getInstance().setHabilitarFala(value);
                          });
                        },
                        activeTrackColor: Colors.redAccent, 
                        activeColor: Colors.red,
                      ),
                    ),
                  ]
                ),
                Row(
                  children: <Widget> [
                    Expanded(
                      flex: 8,
                      child: Text(
                        'Máximo de pontos',
                        style: TextStyle(
                          fontFamily: 'Poison',
                          fontSize: 23,
                        ) 
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: TextField(
                        controller: _pontos,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Poison',
                          fontSize: 20,
                        ) 
                      ),
                    ),
                  ]
                ),
                Divider(color: Colors.transparent, height: 30),
                Container(
                  child: Column(
                    children: <Widget> [
                      Row(
                        children: <Widget> [
                          Expanded(
                            flex: 8,
                            child: Text(
                              'Frases de novo jogo',
                              style: TextStyle(
                                fontFamily: 'Poison',
                                fontSize: 20,
                              ) 
                            )
                          ),
                          Expanded(
                            flex: 2,
                            child: InkWell(
                              child: Icon(
                                Icons.add, 
                                color: Colors.green
                              ),
                              onTap: () => _displayDialog(context, -1),
                            ),
                          ),
                        ]
                      ),
                      Container(
                        height: (MediaQuery.of(context).size.height/2.0)/2.0,
                        child: ListView.builder(
                          itemCount: Configs.getInstance().getFalasBoasVindas().length,
                          itemBuilder: (BuildContext context, int index) {     
                            return Container(
                              height: 45, 
                              padding: EdgeInsets.all(5.0),
                              alignment: Alignment.centerLeft,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget> [
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                        flex: 8,
                                        child: Text(Configs.getInstance().getFalasBoasVindas()[index]),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: InkWell(
                                          child: Icon(
                                            Icons.delete, 
                                            color: Colors.red
                                          ),
                                          onTap: () => _confirmaRemove(context, -1, Configs.getInstance().getFalasBoasVindas()[index]),
                                        )
                                      ),
                                    ],
                                  ),
                                ],
                              )                            
                            );
                          },
                        ),
                      ),                    
                    ]
                  ),
                ),
                Container(
                  child: Column(
                    children: <Widget> [
                      Row(
                        children: <Widget> [
                          Expanded(
                            flex: 8,
                            child: Text(
                              'Frases de dois pontos',
                              style: TextStyle(
                                fontFamily: 'Poison',
                                fontSize: 20,
                              ) 
                            )
                          ),
                          Expanded(
                            flex: 2,
                            child: InkWell(
                              child: Icon(
                                Icons.add, 
                                color: Colors.green
                              ),
                              onTap: () => _displayDialog(context, 2),
                            )
                          ),
                        ]
                      ),                   
                      Container(
                        height: (MediaQuery.of(context).size.height/2.0)/2.0,
                        child: ListView.builder(
                          itemCount: Configs.getInstance().getFalasDoisPontos().length,
                          itemBuilder: (BuildContext context, int index) {     
                            return Container(
                              height: 45, 
                              padding: EdgeInsets.all(5.0),
                              alignment: Alignment.centerLeft,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget> [
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                        flex: 8,
                                        child: Text(Configs.getInstance().getFalasDoisPontos()[index]),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: InkWell(
                                          child: Icon(
                                            Icons.delete, 
                                            color: Colors.red
                                          ),
                                          onTap: () => _confirmaRemove(context, 2, Configs.getInstance().getFalasDoisPontos()[index]),
                                        )
                                      ),
                                    ],
                                  ),
                                ],
                              )                            
                            );
                          },
                        ),
                      )
                    ]
                  ),
                ),
                Divider(color: Colors.transparent, height: 30),
                Container(
                  child: Column(
                    children: <Widget> [
                      Row(
                        children: <Widget> [
                          Expanded(
                            flex: 8,
                            child: Text(
                              'Frases de game over',
                              style: TextStyle(
                                fontFamily: 'Poison',
                                fontSize: 20,
                              ) 
                            )
                          ),
                          Expanded(
                            flex: 2,
                            child: InkWell(
                              child: Icon(
                                Icons.add, 
                                color: Colors.green
                              ),
                              onTap: () => _displayDialog(context, 0),
                            )
                          ),
                        ]
                      ),                   
                      Container(
                        height: (MediaQuery.of(context).size.height/2.0)/2.0,
                        child: ListView.builder(
                          itemCount: Configs.getInstance().getFalasGameOver().length,
                          itemBuilder: (BuildContext context, int index) {     
                            return Container(
                              height: 45, 
                              padding: EdgeInsets.all(5.0),
                              alignment: Alignment.centerLeft,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget> [
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                        flex: 8,
                                        child: Text(Configs.getInstance().getFalasGameOver()[index]),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: InkWell(
                                          child: Icon(
                                            Icons.delete, 
                                            color: Colors.red
                                          ),
                                          onTap: () => _confirmaRemove(context, 2, Configs.getInstance().getFalasGameOver()[index]),
                                        )
                                      ),
                                    ],
                                  ),
                                ],
                              )                            
                            );
                          },
                        ),
                      )
                    ]
                  ),
                )
              ],
            ),
          ),
        )
      ),
    );
  }
}