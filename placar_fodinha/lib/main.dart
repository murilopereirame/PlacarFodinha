import 'package:flutter/material.dart';
import 'package:placar_fodinha/screens/Configuracoes.dart';
import 'package:placar_fodinha/utils/Configs.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:placar_fodinha/screens/NovoJogo.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Configs.getInstance().carregarConfiguracoes();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return DynamicTheme(
      defaultBrightness: Brightness.light,
      data: (brightness) => new ThemeData(
        primarySwatch: Colors.red,
        brightness: brightness,
      ),
      themedWidgetBuilder: (context, theme) {
        return new MaterialApp(
          title: 'Placar Fodinha',
          theme: theme,
          home: new MyHomePage(title: 'Menu'),
        );
      }
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  
  _displayDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Sobre'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text('Dev:', style: TextStyle(fontFamily: 'Poison', fontWeight: FontWeight.bold)),
              Text('Murilo Pereira', style: TextStyle(fontFamily: 'Poison')),
              Divider(color: Colors.transparent),
              Text('Colabs:', style: TextStyle(fontFamily: 'Poison', fontWeight: FontWeight.bold)),
              Text('Murilo "Bird" Marçal', style: TextStyle(fontFamily: 'Poison')),
              Text('Leonardo "Vamp" Contini', style: TextStyle(fontFamily: 'Poison')),
              Divider(color: Colors.transparent,),
              Text('Imagens:', style: TextStyle(fontFamily: 'Poison', fontWeight: FontWeight.bold)),
              Text('Freepik', style: TextStyle(fontFamily: 'Poison')),
            ],
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      }
    );
  }

  @override
  void initState() {
    super.initState();
    print(Configs.getInstance().getTheme());    
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset('assets/images/logo.png', scale: 3,),
                Divider(color: Colors.transparent, height: 30,),
                SizedBox(
                  width: MediaQuery.of(context).size.width - 200,
                  child: RaisedButton(
                    child: Text('Novo jogo'),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => NovoJogo()),
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width - 200,
                  child: RaisedButton(
                    child: Text('Configurações'),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Configuracoes()),
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width - 200,
                  child: RaisedButton(
                    onPressed: () => _displayDialog(context), 
                    child: Text('Sobre')
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
