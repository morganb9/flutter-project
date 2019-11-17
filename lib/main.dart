import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'model.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'All Places',
      theme: ThemeData(

        primarySwatch: Colors.indigo,
      ),
      home: MyHomePage(title: "Recherche de lieu"),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

Future<Reponses> fetchPost(String city, String type) async {
  final response =
  await http.get('https://api.foursquare.com/v2/venues/search?near='+city+'&query='+type+'&client_id=NM4DQGL0DJBLWO1NOISG1SWJHHPEUOPASMOBKKUNZR5AMGQ1&client_secret=X3R2SBPTN0CM2GGQQLH1BEJIIEGPHZIJZY4LHO21JZEMVBTB&v=20191104');

  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON.
    return Reponses.fromJson(json.decode(response.body));
    //print(json.decode(response.body));

  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load post');
  }
}

Future<VenueDetails> getVenueDetails(Venue itemReponse) async {
  final response =
  await http.get('https://api.foursquare.com/v2/venues/'+itemReponse.id+'?client_id=NM4DQGL0DJBLWO1NOISG1SWJHHPEUOPASMOBKKUNZR5AMGQ1&client_secret=X3R2SBPTN0CM2GGQQLH1BEJIIEGPHZIJZY4LHO21JZEMVBTB&v=20191104');

  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON.
    return VenueDetails.fromJson(json.decode(response.body));
    //print(json.decode(response.body));

  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load post');
  }
}

class _MyHomePageState extends State<MyHomePage> {

  final myControllerCity = TextEditingController();
  final myControllerType = TextEditingController();
  List<Venue> venues = new List<Venue>();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myControllerCity.dispose();
    myControllerType.dispose();
    super.dispose();
  }

  Widget equalNull(BuildContext context, Object obj, String text) {
    if(Object != null){
      return Text(text+" : "+obj);
    }else{
      return Text(text+" : Non référencée !");
    }
  }

  @override
  Widget _MySecondPageStatsse(BuildContext context, Venue item) {

    return Scaffold(
      appBar: AppBar(

        title: Text(widget.title),
      ),
      body: Column(
        children: <Widget>[
          Text(
            item.name??'Aucun Titre',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          equalNull(context, item.cat, "Categorie"),

          Text(item.description??'Description : Aucune'),
          Image.network(
              item.photos[0]
          ),
          FlatButton.icon(
              label: Text("Rechercher sur Google Maps"),
              icon: Icon(Icons.location_on),
              onPressed: () => {
                launch('https://www.google.fr/maps/search/'+item.latitude+','+item.longitude)
              }
          ),
        ],

      ),

    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        title: Text(widget.title),
      ),
      body: Center(

        child: Column(

          mainAxisAlignment: MainAxisAlignment.start,

          children: <Widget>[
            TextField(
              controller: myControllerCity,
              decoration: InputDecoration(
                  hintText: 'Lieu'
              ),
            ),
            TextField(
              controller: myControllerType,
              decoration: InputDecoration(
                  hintText: 'Rechercher'
              ),
            ),
            FlatButton.icon(
              color: Colors.grey,
              icon: Icon(Icons.search),
              label: Text('Rechercher'),
              onPressed: () {

                fetchPost(myControllerCity.text, myControllerType.text).then((result) {
                  venues.clear();
                  setState(() {
                    venues.addAll(result.venues);
                  });
                });
              },
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: venues.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                        child : Container(
                          height: 50,
                          margin: EdgeInsets.all(5.0),
                          color: Colors.grey,
                          child: Row(children: <Widget>[
                            Text( venues[index].name),
                            Icon(Icons.place)]
                          ),
                        ),
                        onTap: () => {
                          getVenueDetails(venues[index]).then((result) {

                            Navigator.push(context, MaterialPageRoute(builder: (_) => _MySecondPageStatsse(context, result.venue)));

                          }),

                        }
                    );
                  }
              ),
            ),

          ],
        ),

      ),

    );
  }
}