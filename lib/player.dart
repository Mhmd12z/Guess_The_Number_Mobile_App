import "package:flutter/material.dart";
import "package:http/http.dart" as http;
import 'dart:convert' as convert;

const String _baseURL = 'https://mhmd12z.000webhostapp.com';

class Player {
  final int _uid;
  final String _username;
  final String _name;

  Player(this._uid,this._username, this._name);

  @override
  String toString() {
    return 'ID: $_uid Username: $_username Name: $_name';
  }
}
List <Player> _players = [];

void updatePlayers(Function(bool success) update) async {
  try {
    final url = Uri.https(_baseURL, 'getPlayers.php');
    final response = await http.get(url)
        .timeout(const Duration(seconds: 5)); // max timeout 5 seconds
    _players.clear(); // clear old products
    if (response.statusCode == 200) { // if successful call
      final jsonResponse = convert.jsonDecode(response.body); // create dart json object from json array
      for (var row in jsonResponse) { // iterate over all rows in the json array
        Player p = Player( // create a product object from JSON row object
            int.parse(row['uid']),
            row['username'],
            row['name'],
        );
        _players.add(p); // add the product object to the _products list
      }
      update(true); // callback update method to inform that we completed retrieving data
    }
  }
  catch(e) {
    update(false); // inform through callback that we failed to get data
  }
}
class ShowPlayers extends StatelessWidget {
  const ShowPlayers({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return ListView.builder(
        itemCount: _players.length,
        itemBuilder: (context, index) {
          return Column(children: [
            const SizedBox(height: 30),
            Row(children: [
              SizedBox(width: width * 0.3),
              SizedBox(width: width * 0.5, child:
              Flexible(child: Text(_players[index].toString(),
                  style: const TextStyle(fontSize: 18)))),
            ]),
            const SizedBox(height: 5),
          ]);
        });
  }
}