import 'package:flutter/material.dart';
import 'dart:math';
import 'score.dart';
import "scorepage.dart";

void main() => runApp(HomePage());

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int rand = 1 + Random().nextInt(100);
  String msg = "Play!";
  int n = 0;
  int tries = 10;
  int least = 1;
  int most = 100;
  int count = 10;
  int wins = 0;
  int loses = 0;
  var exact = "?";
  bool winsLastMatch = false;
  void setNumber(v) {
    setState(() {
      n = int.parse(v);
    });
  }
  final Map<String, Color> messageColors = {
    'High': Colors.red[400]!,
    'Too High': Colors.red,
    'Low': Colors.cyanAccent,
    'Too Low': Colors.blue,
    'Winner!': Colors.yellowAccent,
    'You Loosed!': Colors.deepOrange,
  };
  void restart() {
    setState(() {
      tries = 10;
      least = 1;
      most = 100;
      n = 0;
      rand = Random().nextInt(100);
      msg = "Play!";
      exact = "?";
      difficulty = "EZ";
      clearText();
    });
  }

  void matchNumber() {
    setState(() {
      if (tries > 0) {
        if (rand == n) {
          msg = "Winner!";
          tries++;
          exact = rand.toString();
          wins++;
          winsLastMatch=true;
        }
        if (n > rand) {
          most = n;
        } else if (n < rand) {
          least = n;
        }
        if ((rand - n) > 0) {
          if ((rand - n) > 10) {
            msg = "Too Low";
          } else {
            msg = "Low";
          }
        } else if ((rand - n) < 0) {
          if ((rand - n) < -10) {
            msg = "Too High";
          } else {
            msg = "High";
          }
        }
          tries--;
      }
      if(tries==0){
        tries = 0;
        msg = "You Loosed!";
        exact = rand.toString();
        loses++;
        winsLastMatch=false;
      }
    });
  }

  List<String> diffLevels = ["EZ", "Medium", "GG"];
  String? difficulty = "EZ";
  void chooseDiff() {
    setState(() {
      if (difficulty == "EZ") {
        most = 100;
        rand = 1 + Random().nextInt(100);
      } else if (difficulty == "Medium") {
        most = 500;
        rand = 1 + Random().nextInt(500);
      } else {
        most = 1000;
        rand = 1 + Random().nextInt(1000);
      }
    });
  }

  final TextEditingController _controllerWins = TextEditingController();
  final TextEditingController _controllerLoses = TextEditingController();
  @override
  void dispose() {
    _controllerWins.dispose();
    _controllerLoses.dispose();
    super.dispose();
  }

  void showScore() {
    try {
      int wins = int.parse(_controllerWins.text);
      int loses = int.parse(_controllerLoses.text);
    } catch (e) {
      print(e);
    }
  }
  void goToScore(){
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context)=> const ScorePage(),
        settings: RouteSettings(arguments: Score(wins,loses,winsLastMatch))
      )
    );
  }
  TextEditingController _textController = TextEditingController();

  void clearText() {
    _textController.clear();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.deepPurple,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Guess The Number",
              style: TextStyle(fontSize: 12.0,fontWeight: FontWeight.w900,fontFamily: 'PressStart2P'),
            ),
            ElevatedButton(
              onPressed: restart,
              child: Icon(
                Icons.restart_alt,
                color: Colors.yellow,
              ),
              style: ButtonStyle(
                elevation: MaterialStateProperty.all(0),
              ),
            )
          ],
        ),
        centerTitle: true,
        elevation: 0,
      ),
      drawer: Drawer(
        backgroundColor: Colors.blue,
        elevation: 0,
        shape: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.yellow, width: 20.0)),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
            child: ListView(
              children: [
                Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(60),
                        child: Image.asset(
                          "assets/avatar.jpeg",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Expanded(
                        child: ListTile(
                      title: Text(
                        "Guest",
                        style: TextStyle(color: Colors.white,fontSize: 10),
                      ),
                      subtitle: Text(
                        "Sign Up From Here ->",
                        style: TextStyle(color: Colors.white,fontSize: 8.0),
                      ),
                    )),
                  ],
                ),
                SizedBox(
                  height: 16.0,
                ),
                SizedBox(
                  height: 16.0,
                ),
            Text("Change The Difficulty?",textAlign:TextAlign.center,style: TextStyle(fontSize: 12,color: Colors.white),)
            ,
                SizedBox(height: 16.0,),
                Container(
                  alignment: Alignment.center,
                  child: DropdownButton<String>(
                    value: difficulty,
                    borderRadius: BorderRadius.circular(10.0),
                    isExpanded: true,
                    elevation: 0,
                    focusColor: Colors.blue,
                    dropdownColor: Colors.purple,
                    items: diffLevels
                        .map((item) => DropdownMenuItem(
                              value: item,
                              child: Text(
                                item,
                                style: TextStyle(fontSize: 25),
                              ),
                            ))
                        .toList(),
                    onChanged: (item) => setState(() {
                      difficulty = item;
                      chooseDiff();
                    }),
                    style: TextStyle(
                      color: Colors.yellow,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                SizedBox(
                  height: 16.0,
                ),
                // ElevatedButton(onPressed: (){);}, child: ListTile(title: Text("Show Score",style: TextStyle(color: Colors.white),),leading: Icon(Icons.sports_score_outlined) ,))
                ListTile(
                  title: Text("Score: ",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w900),),
                ),
                SizedBox(
                  height: 16.0,
                ),
                Text(
                  "Number of Wins",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 12.0),
                ),
                SizedBox(
                  height: 16.0,
                ),
                Text(
                  "$wins",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.yellow, fontSize: 20.0),
                ),
                SizedBox(
                  height: 16.0,
                  child: Divider(),
                ),
                Text(
                  "Number of Loses",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 12.0),
                ),
                SizedBox(height: 16.0,),
                Text(
                  "$loses",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.red, fontSize: 20.0),
                ),
                SizedBox(height: 16.0,),
                ElevatedButton(onPressed: goToScore, child: Text("Show Details",style: TextStyle(
                  fontSize: 10.0,
                  fontFamily: 'PressStart2P',
                ),)),
                SizedBox(height: 30.0,),
                Text("How To Play?",textAlign: TextAlign.center,style: TextStyle(
                  color: Colors.white,
                  fontSize: 10.0
                ),),
                SizedBox(height: 10.0,),
                IconButton(
                  icon: Icon(Icons.info),
                  color: Colors.white,
                  onPressed: () {
                    // Show a hint when the button is pressed
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Hint'),
                          content: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text("EZ:Try guessing a number between 1 & 100"),
                              SizedBox(height: 16.0,),
                              Text("Medium:Try guessing a number between 1 & 500"),
                              SizedBox(height: 16.0,),
                              Text("GG:Try guessing a number between 1 & 1000"),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),

      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.blue),
                  child: Text("You Have $tries Attempts",
                      style: TextStyle(
                        fontFamily: 'PressStart2P',
                          fontSize: 15.0,
                          color: Colors.yellow,
                          fontWeight: FontWeight.w900))),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "$least",
                    style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.yellow,
                        fontWeight: FontWeight.w800),
                  ),
                  Text(
                    " < $exact < ",
                    style: TextStyle(
                        fontSize: 24.0,
                        color: Colors.orange,
                        fontWeight: FontWeight.w800),
                  ),
                  Text(
                    "$most",
                    style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.yellow,
                        fontWeight: FontWeight.w800),
                  )
                ],
              ),
              Text(
                "$msg",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: messageColors.containsKey(msg) ? messageColors[msg] : Colors.orange,
                  fontSize: 30.0,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(height: 16.0,),
              SizedBox(
                width: 400.0,
                height: 50.0,
                child: TextField(
                  controller: _textController,
                  keyboardType: TextInputType.number,
                  autofocus: true,
                  showCursor: false,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Enter the number",
                      hintStyle: TextStyle(color: Colors.white,fontSize: 12.0),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.yellow))),
                  onChanged: (v) {
                    setNumber(v);
                  },
                  style: TextStyle(
                    fontFamily: 'PressStart2P',
                      color: Colors.white, letterSpacing: 5.0, fontSize: 20.0),
                ),
              ),
              SizedBox(height: 20,),
              SizedBox(
                width: 400.0,
                height: 100.0,
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.yellow)),
                  onPressed: matchNumber,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Guess",
                        style: TextStyle(
                            fontSize: 30.0,
                            fontWeight: FontWeight.w900,
                            fontFamily: 'PressStart2P',
                            color: Colors.blue),
                      ),SizedBox(
                        width: 10.0,
                      ),
                      Icon(Icons.videogame_asset, color: Colors.deepPurple, size: 50,),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 12.0,)
            ],
          ),
        ),
      ),
    );
  }
}
