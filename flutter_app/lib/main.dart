import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import "graphqlConf.dart";
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';


var uuid = Uuid();

GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();

void _makePostRequest(String Movimiento, String puerto) async {
  // set up POST request arguments
  String url = 'http://dnscont01.southcentralus.azurecontainer.io:300'+puerto+'/'+Movimiento;
  //Map<String, String> headers = {"Content-type": "application/json"};
  //String json = "{\"mov\":\""+movimiento+"\"}";
  // make POST request
  Response response = await post(url/*, headers: headers, body: json*/);
  // check the status code for the result
  int statusCode = response.statusCode;
  // this API passes back the id of the new item added to the body
  String body = response.body;
  // {
  //   "title": "Hello",
  //   "body": "body text",
  //   "userId": 1,
  //   "id": 101
  // }
}

String fechaActual(){
  var now = new DateTime.now();
  var formatter = DateFormat("yyyy-MM-dd HH:mm:ss");
  String formatterDate = formatter.format(now);
  return formatterDate;
}

void main() => runApp(
GraphQLProvider(
client: graphQLConfiguration.client,
child: CacheProvider(child: MyApp()),
),
);

class QueryMutation {
  String addMov(String _id, String mov, String registerDate, String duration, String place) {
    return """
      mutation{
          addMov(_id: "$_id", mov: "$mov", RegisterDate: "$registerDate", Duration: "$duration", place : "$place"){
            _id,
            mov,
            RegisterDate,
            Duration,
            place
          }
      }
    """;
  }
}


class MyApp extends StatelessWidget {
  static const String _title = 'Carrito';
  QueryMutation addMutation = QueryMutation();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      //home: MyHomePage(title: 'hola'),
      home: Scaffold(
        appBar: AppBar(title: const Text(_title)),
          body: Container(
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    IconButton(
                      onPressed:() async {
                        GraphQLClient _client = graphQLConfiguration.clientToQuery();
                        QueryResult result = await _client.mutate(
                          MutationOptions(
                            document: addMutation.addMov(
                                uuid.v4(),
                                "Arriba",
                                fechaActual(),
                                "00:00:01",
                                "APP"
                            ),
                          ),
                        );
                        _makePostRequest("arriba","2");
                      },
                      icon: Icon(Icons.expand_less),
                      iconSize: 100.0,
                      color: Colors.black,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    IconButton(
                      onPressed: () async {
                        GraphQLClient _client = graphQLConfiguration.clientToQuery();
                        QueryResult result = await _client.mutate(
                          MutationOptions(
                            document: addMutation.addMov(
                                uuid.v4(),
                                "izquierda",
                                fechaActual(),
                                "00:00:01",
                                "APP"
                            ),
                          ),
                        );
                        _makePostRequest("izquierda","4");
                      },
                      icon: Icon(Icons.chevron_left),
                      iconSize: 100.0,
                      color: Colors.black,
                    ),
                    IconButton(
                      onPressed:  () async {
                                    GraphQLClient _client = graphQLConfiguration.clientToQuery();
                                    QueryResult result = await _client.mutate(
                                    MutationOptions(
                                    document: addMutation.addMov(
                                      uuid.v4(),
                                      "prender led",
                                       fechaActual(),
                                      "00:00:01",
                                      "APP"
                                    ),
                                    ),
                                    );
                                    _makePostRequest("prenderLed","5");
                                    },
                      icon: Icon(Icons.highlight),
                      iconSize: 80.0,
                      color: Colors.black,
                    ),
                    IconButton(
                      onPressed: () async {
                        GraphQLClient _client = graphQLConfiguration.clientToQuery();
                        QueryResult result = await _client.mutate(
                          MutationOptions(
                            document: addMutation.addMov(
                                uuid.v4(),
                                "derecha",
                                fechaActual(),
                                "00:00:01",
                                "APP"
                            ),
                          ),
                        );
                        _makePostRequest("derecha","3");
                      },
                      icon: Icon(Icons.chevron_right),
                      iconSize: 100.0,
                      color: Colors.black,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    IconButton(
                      onPressed: () async {
                        GraphQLClient _client = graphQLConfiguration.clientToQuery();
                        QueryResult result = await _client.mutate(
                          MutationOptions(
                            document: addMutation.addMov(
                                uuid.v4(),
                                "abajo",
                                fechaActual(),
                                "00:00:01",
                                "APP"
                            ),
                          ),
                        );
                        _makePostRequest("abajo","2");
                      },
                      icon: Icon(Icons.expand_more),
                      iconSize: 100.0,
                      color: Colors.black,
                    ),
                  ],
                ),
                /*const Image(
                  image: NetworkImage('https://of3lia.com/wp-content/uploads/2018/09/Foto-coche-comprimida.png'),
                  width: 400.0,
                ),*/
              ],
            ),
          ),
      ),
    );

  }
}




class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Yohuhhyhs many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
