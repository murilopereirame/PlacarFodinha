import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHandler {
  Future<Database> database;
  
  DatabaseHandler() {
    if(database == null)
      database = openDB();
  }

  Future<Database> openDB() async {
    return openDatabase(
      join(await getDatabasesPath(), 'fodinha.db'),
       onCreate: (db, version) {          
          db.execute('CREATE TABLE "NovoJogo" ("id"	INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE, "frase"	TEXT NOT NULL);');
          db.execute('CREATE TABLE "GameOver" ("id"	INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE, "frase"	TEXT NOT NULL);');
          db.execute('CREATE TABLE "DoisPontos" ("id"	INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE, "frase"	TEXT NOT NULL);');
          db.execute('CREATE TABLE "Config" ("id"	INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE, "darkMode"	INTEGER NOT NULL DEFAULT 0, "maximoPontos"	INTEGER NOT NULL DEFAULT 5, "manterTela"	INTEGER NOT NULL DEFAULT 1, "habilitarFala"	INTEGER NOT NULL DEFAULT 1);');
          db.execute('INSERT INTO GameOver (id, frase) VALUES(1, "O jogador {0} é muito lixo! Perdeu man!");');
          db.execute('INSERT INTO GameOver (id, frase) VALUES(2, "Perdeu PlayBoy! Vai aprender a jogar!");');
          db.execute('INSERT INTO GameOver (id, frase) VALUES(3, "Alguém ensina o {0} a jogar!");');
          db.execute('INSERT INTO GameOver (id, frase) VALUES(4, "When I see you again.. OOOOOOOO");');
          db.execute('INSERT INTO DoisPontos (id, frase) VALUES(1, "Ta sentando na mandioca em filhão!");');
          db.execute('INSERT INTO DoisPontos (id, frase) VALUES(2, "Quem é Mia Khalifa perto de você!");');
          db.execute('INSERT INTO DoisPontos (id, frase) VALUES(3, "Kid Bengala mandou abraços");');
          db.execute('INSERT INTO DoisPontos (id, frase) VALUES(4, "Já virou buraco negro!");');
          db.execute('INSERT INTO NovoJogo (id, frase) VALUES(1, "Abraços do tio Kid! Bom jogo");');
          db.execute('INSERT INTO NovoJogo (id, frase) VALUES(2, "Bom jogo a todos!");');
          db.execute('INSERT INTO NovoJogo (id, frase) VALUES(3, "New game? Boa!");');
          db.execute('INSERT INTO Config (id, darkMode, maximoPontos, habilitarFala, manterTela) VALUES (1, 0, 5, 1, 1)');
       },
       version: 1,
    );
  }

  Future<bool> inserirFrase(String frase, String table) async {      
    final Database db = await openDB();
    var result;
    
    try {
      result = await db.insert(
        table,
        {'frase' : frase},
        conflictAlgorithm: ConflictAlgorithm.replace,      
      );
    } catch(error) {
      print(error);
    }

    if(result > 0)
      return true;
    else
      return false;
  }

  Future<List<String>> obterFrases(String table) async {
    final Database db = await database;

    final List<Map<String, dynamic>> maps = await db.query(table);    
    return List.generate(maps.length, (i) {
      return maps[i]['frase'];
    });
  }

  Future<bool> deletarFrase(String frase, String table) async {

    final Database db = await openDB();
    var count = await db.delete(table, where: 'frase = ?', whereArgs: [frase]);

    if(count > 0)
      return true;
    else
      return false;
  }

  Future<bool> atualizarConfigs(int darkMode, int maximoPontos, int manterTela, int habilitarFala) async {
    final Database db = await database;
    
    var count;
    
    try{
      count = await db.update('Config', 
        {
          'darkMode':darkMode, 'maximoPontos':maximoPontos,
          'manterTela':manterTela, 'habilitarFala':habilitarFala
        }, 
      );
    } catch(error) {
      print(error);
    }

    if(count > 0)
      return true;
    else
      return false;
  }

  Future<Map<String, int>> obterConfigs(String table) async {
    final Database db = await database;

    final List<Map<String, dynamic>> maps = await db.query(table);    
    return {
      'darkMode':maps[0]['darkMode'],
      'maximoPontos':maps[0]['maximoPontos'],
      'manterTela':maps[0]['manterTela'],
      'habilitarFala':maps[0]['habilitarFala']
    };
  }
}