/*

www.conversormoedas01.com.br

https://api.hgbrasil.com/finance?format=json-cors&key=0f066ebf

Olá querido aluno!
Na próxima aula utilizaremos o pacote Http, porém, na mais recente versão do Flutter, ele não é mais incluído por padrão.
Para incluir o pacote Http ao seu projeto, adicione o plugin do Http no seu pubspec.yaml da seguinte maneira:
		dependencies:   
		  flutter:
		    sdk: flutter
		 
		  cupertino_icons: ^0.1.2
		  http: ^0.12.0+2        # ADICIONE ESTA LINHA AO SEU PUBSPEC
Tome bastante cuidado com o alinhamento! O http deve ficar no mesmo alinhamento do cupertino_icons e logo abaixo do mesmo!
Logo após clique no botão flutter packages get e prossiga com o curso!
Obs.:
1) Deixe esta nova linha alinhada com a linha do cupertino_icons, dando 2 espaços do lado esquerdo.
2) Utilize sempre a versão mais recente deste plugin, que você pode encontrar aqui: https://pub.dartlang.org/packages/http#-installing-tab-
3) Mais para frente no curso utilizaremos novamente o pacote Http e o procedimento para adicioná-lo ao projeto será o mesmo!

---------------------------------------------------------------------------------------------------------------------

Na próxima aula utilizaremos bordas nos campos de texto, porém na versão mais recente do flutter houve uma pequena mudança nesta área, 
assim a borda não está ficando mais colorida.

Pra resolver, basta aplicar o código a seguir no seu ThemeData:

theme: ThemeData(
  inputDecorationTheme: InputDecorationTheme(
    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white))
  )
)

*/

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Pacote para poder fazer arequisições http
import 'dart:async';// permita que eu faça requisições e não precise ficar esperando pelo retorno delas (assincrona)
import 'dart:convert';// para poder transformar os dados em json

const request = "https://api.hgbrasil.com/finance?format=json-cors&key=0f066ebf"; // A nossa chave criada no site

Future<Map> getData() async { // Função que se chama getData() : Retorna um mapa no futuro
  http.Response response = await http.get(request);// a resposta que eu vou obter vamos chamar de response
                                                   // http.get(request) -> solicitando dados para o servidor (retorna um dado futuro)
                                                   // await significa que vamos esperar pela resposta do get
  return json.decode(response.body); 
}

void main() async { // A função main agora é assincrona por conta do await

  runApp(MaterialApp(
    home: Home(),  //criar um widget statefull scafold e barra
    theme: ThemeData(
            hintColor: Colors.amber,
            primaryColor: Colors.white,
            inputDecorationTheme: InputDecorationTheme(
              enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white))
            )
          )
  ));

}

class Home extends StatefulWidget{
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  
  // Criando controladores para poder obter os textos do TextField e também descobrir quando eles são alterados
  final realController = TextEditingController();// Final: O controlador não vai mudar em nenhum momento
  final dolarController = TextEditingController();
  final euroController = TextEditingController();
  
  void _resetFields(){
    realController.text = ""; // Não precisa entrar no setStato, pois o controlador já faz a modificação
    dolarController.text = "";
    euroController.text = "";
  }

  double dolar;
  double euro;

  void _realChanged(String text){
    if(text.isEmpty){
      _resetFields();
      return;
    }
    double real = double.parse(text);
    dolarController.text = (real/dolar).toStringAsFixed(2);
    euroController.text = (real/euro).toStringAsFixed(2);
  }
  void _dolarChanged(String text){
    if(text.isEmpty){
      _resetFields();
      return;
    }
    double dolar = double.parse(text);
    realController.text = (dolar * this.dolar).toStringAsFixed(2); 
    euroController.text = (dolar * this.dolar / euro).toStringAsFixed(2);
  }
  void _euroChanged(String text){
    if(text.isEmpty){
      _resetFields();
      return;
    }
    double euro = double.parse(text);
    realController.text = (euro * this.euro).toStringAsFixed(2); 
    dolarController.text = (euro * this.euro / dolar).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold( // Biblioteca com alguns layouts prontos
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text("\$ Conversor \$"),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _resetFields,
          )
        ],
      ) ,
      body: FutureBuilder<Map>( // Future builder do tipo MAP( O json retorna um mapa )
        future: getData(), // Vai construir a tela dependendo do que tem no getData() o futuro dos dados 
        builder: (context,snapshot){ // Snapshot: fotografia dos dados momentanio que obtivemos do nosso servidor
          switch(snapshot.connectionState){ //Verificar o status da conexao
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: Text("Carregando Dados...",
                  style: TextStyle(color: Colors.amber,
                  fontSize: 25.0),
                textAlign: TextAlign.center,
                ) ,
              );
            default: // Caso não esteja nem esperando e nem parado (Terminado de carregar so dados)
              if(snapshot.hasError){
                return Center( // Widget que centraliza outro widget
                  child: Text("Erro ao carregar Dados :(",
                    style: TextStyle(color: Colors.amber,
                    fontSize: 25.0),
                  textAlign: TextAlign.center,
                  ) ,
                );
              } else { // Se não obtivermos nenhum erro

                dolar = =
                euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];
                
                return SingleChildScrollView( // Tela rolavel
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[  
                      Icon(Icons.monetization_on,size:150.0,color: Colors.amber),
                      buildTextField("Reais", "R\$", realController, _realChanged), // Função que constroi uma TextField
                      Divider(), // Insere um espaço default entre os campos
                      buildTextField("Dolares", "US\$", dolarController, _dolarChanged), 
                      Divider(),
                      buildTextField("Euros", "€", euroController, _euroChanged) 
                    ],
                  ),
                );
              }  
          }
        }),
    );
  }  
}

Widget buildTextField(String label, String prefix, TextEditingController controlador, Function funcao){ // Função que retorna um widget
  return TextField( 
    controller: controlador, //Inserindo o controlador
    decoration: InputDecoration(
        labelText: label, // parametro da funcao
        labelStyle: TextStyle(color: Colors.amber),
        border: OutlineInputBorder(),
        prefixText: prefix // parametro da funcao
      ),
      style: TextStyle(
        color: Colors.amber,fontSize: 25.0
      ),
      onChanged: funcao, //Toda vez que o campo for modificado irá chamar a função
                         //OBS: OLHAR NO DEBUG CONSOLE - OUTPUT - LOG
      keyboardType: TextInputType.numberWithOptions(decimal: true), // Desta forma você poderá digitar números decimais no iOS também! "." (ponto decimal) 
    );
}