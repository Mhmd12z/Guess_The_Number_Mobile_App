import "package:flutter/material.dart";
import "package:http/http.dart" as http;
import 'dart:convert' as convert;

const String _baseURL = 'mhmd12z.000webhostapp.com';

class Player {
  final int _uid;
  final String _username;
  final String _name;
  final int _winsCount;
  final String _mode;

  Player(this._uid,this._username, this._name,this._winsCount,this._mode);


  String getUserName() {
    return _username;
  }
  String getName(){
    return _name;
  }
  int getScore(){
    return _winsCount;
  }
  String getMode(){
    return _mode;
  }
}
List <Player> _players = [];

void updatePlayers(Function(bool success) update) async {
  try {
    final url = Uri.https(_baseURL, 'getPlayers.php');
    final response = await http.get(url)
        .timeout(const Duration(seconds: 5));
    _players.clear();
    if (response.statusCode == 200) {
      final jsonResponse = convert.jsonDecode(response.body);
      for (var row in jsonResponse) {
        Player p = Player(
            int.parse(row['uid']),
            row['username'],
            row['name'],
            int.parse(row['wins']),
            "Any"
        );
          _players.add(p);
      }
      update(true);
    }
  }
  catch(e) {
    update(false);
  }
}
void getEasy(Function(bool success) update) async {
  try {
    final url = Uri.https(_baseURL, 'getPlayers.php');
    final response = await http.get(url)
        .timeout(const Duration(seconds: 5));
    _players.clear();
    if (response.statusCode == 200) {
      final jsonResponse = convert.jsonDecode(response.body);
      for (var row in jsonResponse) {
        if (row["mode"] == "Easy") {
          Player p = Player(
              int.parse(row['uid']),
              row['username'],
              row['name'],
              int.parse(row['easy_wins']),
              row['mode']
          );
          _players.add(p);
        }
      }
      update(true);
    }
  }
  catch(e) {
    update(false);
  }
}
void getMedium(Function(bool success) update) async {
  try {
    final url = Uri.https(_baseURL, 'getPlayers.php');
    final response = await http.get(url)
        .timeout(const Duration(seconds: 5));
    _players.clear();
    if (response.statusCode == 200) {
      final jsonResponse = convert.jsonDecode(response.body);
      for (var row in jsonResponse) {
        if (row["mode"] == "Medium") {
          Player p = Player(
              int.parse(row['uid']),
              row['username'],
              row['name'],
              int.parse(row['medium_wins']),
              row['mode']
          );
          _players.add(p);
        }
      }
      update(true);
    }
  }
  catch(e) {
    update(false);
  }
}
void getHard(Function(bool success) update) async {
  try {
    final url = Uri.https(_baseURL, 'getPlayers.php');
    final response = await http.get(url)
        .timeout(const Duration(seconds: 5));
    _players.clear();
    if (response.statusCode == 200) {
      final jsonResponse = convert.jsonDecode(response.body);
      for (var row in jsonResponse) {
        if (row["mode"] == "Hard") {
          Player p = Player(
              int.parse(row['uid']),
              row['username'],
              row['name'],
              int.parse(row['hard_wins']),
              row['mode']
          );
          _players.add(p);
        }
      }
      update(true);
    }
  }
  catch(e) {
    update(false);
  }
}
class ShowPlayers extends StatelessWidget {
  const ShowPlayers({super.key});

  @override
  Widget build(BuildContext context) {
    _players.sort((a, b) => b._winsCount.compareTo(a._winsCount));
    Map<int, Player> map = {};
    _players.forEach((player) {
      map[player._uid] = player;
    });

    List<Player> players = map.values.toList();
    return ListView.builder(
        itemCount: players.length,
        itemBuilder: (context, index) {
          if(index==0){
            return SizedBox(
              child: Container(
                decoration: const BoxDecoration(
                    color: Colors.yellow,
                    backgroundBlendMode: BlendMode.difference
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("The Best Score Player",style: TextStyle(color: Colors.yellow,fontWeight: FontWeight.w900),),
                      const SizedBox(height: 20,),
                      Text(players[0].getName().toUpperCase(),style: const TextStyle(color: Colors.white),),
                      const SizedBox(height: 20,),
                      Text("With Score of ${players[0].getScore()} Wins",style: const TextStyle(color: Colors.white),),
                      Text("Mode of ${players[0].getMode()}",style: const TextStyle(color: Colors.white),),
                    ],
                  ),
                ),
              ),
            );
          }else if(index==1){
            return Container(
              decoration: const BoxDecoration(
                  color: Colors.grey,
                  backgroundBlendMode: BlendMode.difference
              ),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("The 2nd Player",style: TextStyle(color: Colors.blueGrey,fontWeight: FontWeight.w900),),
                    const SizedBox(height: 20,),
                    Text(players[1].getName().toUpperCase(),style: const TextStyle(color: Colors.white),),
                    const SizedBox(height: 20,),
                    Text("With Score of ${players[1].getScore()} Wins",style: const TextStyle(color: Colors.white),),
                    Text("Mode of ${players[1].getMode()}",style: const TextStyle(color: Colors.white),),
                  ],
                ),
              ),
            );
          }else if(index==2){
            return Container(
              decoration: const BoxDecoration(
                  color: Colors.brown,
                  backgroundBlendMode: BlendMode.difference
              ),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("The 3rd Player",style: TextStyle(color: Colors.orange,fontWeight: FontWeight.w900),),
                    const SizedBox(height: 20,),
                    Text(players[2].getName().toUpperCase(),style: const TextStyle(color: Colors.white),),
                    const SizedBox(height: 20,),
                    Text("With Score of ${players[2].getScore()} Wins",style: const TextStyle(color: Colors.white),),
                    Text("Mode of ${players[2].getMode()}",style: const TextStyle(color: Colors.white),),
                  ],
                ),
              ),
            );
          }
          else{
            return ListTile(subtitle: Text(players[index].getMode()),leadingAndTrailingTextStyle: const TextStyle(fontSize: 20,fontWeight: FontWeight.w900),leading: Text((index+1).toString(),style: TextStyle(color: (index)<3? Colors.yellow:Colors.white)),title: Text(players[index].getName(),style: const TextStyle(color: Colors.white)),trailing: Text(players[index].getUserName(),style: const TextStyle(color: Colors.white)),shape: Border.all(style: BorderStyle.solid,width: 4,color: Colors.white),minVerticalPadding: 20,tileColor: Colors.blueGrey,);
            }
        });
  }
}
