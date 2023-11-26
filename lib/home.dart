import 'package:flutter/material.dart';
import 'dart:math';
import 'score.dart';
import "scorepage.dart";

void main() => runApp(const HomePage());

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int rand = 2 + Random().nextInt(98); //The random number
  String msg = "Play!";
  String btnMode = "Guess";
  int n = 0, tries = 10, least = 1, most = 100, wins = 0, loses = 0;
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
    'You Lost!': Colors.deepOrange,
  };
  void mode() {
    tries = 10;
    least = 1;
    if (difficulty == "Easy") {
      most = 100;
      rand = 2 + Random().nextInt(98);
    } else if (difficulty == "Medium") {
      most = 500;
      rand = 2 + Random().nextInt(498);
    } else {
      most = 1000;
      rand = 2 + Random().nextInt(998);
    }
  }

  void restart() {
    setState(() {
      mode();
      n = 0;
      msg = "Play!";
      exact = "?";
      clearText();
      btnMode = "Guess";
      alreadyWin = false;
      alreadylost = false;
    });
  }

  bool alreadyWin = false;
  bool alreadylost = false;
  void matchNumber() {
    setState(() {
      if (tries > 0) {
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
      if (rand == n) {
        if (!alreadyWin) {
          alreadyWin = true;
          msg = "Winner!";
          tries++;
          exact = rand.toString();
          wins++;
          winsLastMatch = true;
          btnMode = "Restart";
        } else {
          restart();
          alreadyWin = false;
        }
      }
      if (tries == 0) {
        if (!alreadylost) {
          alreadylost = true;
          tries = 0;
          msg = "You Lost!";
          exact = rand.toString();
          loses++;
          winsLastMatch = false;
          btnMode = "Restart";
        } else {
          restart();
          alreadylost = false;
        }
      }
    });
  }

  List<String> diffLevels = ["Easy", "Medium", "Hard"];
  String? difficulty = "Easy";
  void chooseDiff() {
    restart();
    setState(() {
      if (difficulty == "Easy") {
        most = 100;
        rand = 2 + Random().nextInt(98);
      } else if (difficulty == "Medium") {
        most = 500;
        rand = 2 + Random().nextInt(498);
      } else {
        most = 1000;
        rand = 2 + Random().nextInt(998);
      }
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void goToScore() {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => const ScorePage(),
        settings: RouteSettings(arguments: Score(wins, loses, winsLastMatch))));
  }

  final TextEditingController _textController = TextEditingController();

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
            const Text(
              "Guess The Number",
              style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'PressStart2P'),
            ),
            ElevatedButton(
              onPressed: restart,
              style: ButtonStyle(
                elevation: MaterialStateProperty.all(0),
              ),
              child: const Icon(
                Icons.restart_alt,
                color: Colors.yellow,
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
        shape: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.yellow, width: 20.0)),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
            child: ListView(
              children: [
                Row(
                  children: [
                    SizedBox(
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
                    const Expanded(
                        child: ListTile(
                      title: Text(
                        "Guest",
                        style: TextStyle(color: Colors.white, fontSize: 10),
                      ),
                      subtitle: Text(
                        "Sign Up From Here ->",
                        style: TextStyle(color: Colors.white, fontSize: 8.0),
                      ),
                    )),
                  ],
                ),
                const SizedBox(
                  height: 16.0,
                ),
                const SizedBox(
                  height: 16.0,
                ),
                const Text(
                  "Change The Difficulty?",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Colors.white),
                ),
                const SizedBox(
                  height: 16.0,
                ),
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
                                style: const TextStyle(fontSize: 25),
                              ),
                            ))
                        .toList(),
                    onChanged: (item) => setState(() {
                      difficulty = item;
                      chooseDiff();
                    }),
                    style: const TextStyle(
                      color: Colors.yellow,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16.0,
                ),
                // ElevatedButton(onPressed: (){);}, child: ListTile(title: Text("Show Score",style: TextStyle(color: Colors.white),),leading: Icon(Icons.sports_score_outlined) ,))
                const ListTile(
                  title: Text(
                    "Score: ",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w900),
                  ),
                ),
                const SizedBox(
                  height: 16.0,
                ),
                const Text(
                  "Number of Wins",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 12.0),
                ),
                const SizedBox(
                  height: 16.0,
                ),
                Text(
                  "$wins",
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.yellow, fontSize: 20.0),
                ),
                const SizedBox(
                  height: 16.0,
                  child: Divider(),
                ),
                const Text(
                  "Number of Losses",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 12.0),
                ),
                const SizedBox(
                  height: 16.0,
                ),
                Text(
                  "$loses",
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red, fontSize: 20.0),
                ),
                const SizedBox(
                  height: 16.0,
                ),
                ElevatedButton(
                    onPressed: goToScore,
                    child: const Text(
                      "Show Details",
                      style: TextStyle(
                        fontSize: 10.0,
                        fontFamily: 'PressStart2P',
                      ),
                    )),
                const SizedBox(
                  height: 30.0,
                ),
                const Text(
                  "How To Play?",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 10.0),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                IconButton(
                  icon: const Icon(Icons.info),
                  color: Colors.white,
                  onPressed: () {
                    // Show a hint when the button is pressed
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Hint'),
                          content: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                  "Easy:Try guessing a number between 1 & 100"),
                              SizedBox(
                                height: 16.0,
                              ),
                              Text(
                                  "Medium:Try guessing a number between 1 & 500"),
                              SizedBox(
                                height: 16.0,
                              ),
                              Text(
                                  "Hard:Try guessing a number between 1 & 1000"),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('OK'),
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
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.blue),
                  child: Text("You Have $tries Attempts",
                      style: const TextStyle(
                          fontFamily: 'PressStart2P',
                          fontSize: 15.0,
                          color: Colors.yellow,
                          fontWeight: FontWeight.w900))),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "$least",
                    style: const TextStyle(
                        fontSize: 20.0,
                        color: Colors.yellow,
                        fontWeight: FontWeight.w800),
                  ),
                  Text(
                    " < $exact < ",
                    style: const TextStyle(
                        fontSize: 24.0,
                        color: Colors.orange,
                        fontWeight: FontWeight.w800),
                  ),
                  Text(
                    "$most",
                    style: const TextStyle(
                        fontSize: 20.0,
                        color: Colors.yellow,
                        fontWeight: FontWeight.w800),
                  )
                ],
              ),
              Text(
                msg,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: messageColors.containsKey(msg)
                      ? messageColors[msg]
                      : Colors.orange,
                  fontSize: 30.0,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(
                height: 16.0,
              ),
              SizedBox(
                width: 400.0,
                height: 50.0,
                child: TextField(
                  controller: _textController,
                  keyboardType: TextInputType.number,
                  autofocus: false,
                  mouseCursor: MaterialStateMouseCursor.textable,
                  cursorColor: Colors.yellow,
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Enter the number",
                      hintStyle: TextStyle(color: Colors.white, fontSize: 12.0),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.yellow))),
                  onChanged: (v) {
                    setNumber(v);
                  },
                  style: const TextStyle(
                      fontFamily: 'PressStart2P',
                      color: Colors.white,
                      letterSpacing: 5.0,
                      fontSize: 20.0),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
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
                        btnMode,
                        style: const TextStyle(
                            fontSize: 30.0,
                            fontWeight: FontWeight.w900,
                            fontFamily: 'PressStart2P',
                            color: Colors.blue),
                      ),
                      const SizedBox(
                        width: 10.0,
                      ),
                      const Icon(
                        Icons.videogame_asset,
                        color: Colors.deepPurple,
                        size: 50,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 12.0,
              )
            ],
          ),
        ),
      ),
    );
  }
}
