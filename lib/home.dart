import 'package:flutter/material.dart';
import 'package:mobile_project_one/leaderboard.dart';
import 'package:mobile_project_one/signup.dart';
import 'package:shared_preferences/shared_preferences.dart';
import "package:http/http.dart" as http;
import "login.dart";
import 'dart:math';
import 'dart:convert' as convert;

const String _baseURL = 'mhmd12z.000webhostapp.com';
const String _baseURLHttp = 'https://mhmd12z.000webhostapp.com';

void main() => runApp(const HomePage());

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String username="Guest";
  late String uid;
  late Map info;
  bool guest = false;
  int rand = 2 + Random().nextInt(98);
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
  @override
  void initState() {
    getUserData();
    super.initState();
  }

  void getUserData() async {
      final pref = await SharedPreferences.getInstance();
      if(pref.getString("username")==null){
        setState(() {
          guest=true;
        });
      }
      setState(() {
      username = pref.getString("username")!;
      uid = pref.getString("uid")!;
      });
      final url = Uri.https(_baseURL, 'getPlayerStats.php',{'uid':uid});
      final response = await http.get(url)
          .timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) {
        final jsonResponse = convert.jsonDecode(response.body);
        setState(() {
          wins=int.parse(jsonResponse['wins']);
          loses=int.parse(jsonResponse['losses']);
        });

      }
  }
  List<String> diffLevels = ["Easy", "Medium", "Hard"];
  String difficulty = "Easy";
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
  void addWin(
      String userId,
      String mode
      ) async {
    final response = await http.post(
      Uri.parse('$_baseURLHttp/addWin.php'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: convert.jsonEncode(<String, String>{
        'uid': userId,
        'mode': mode
      }),
    ).timeout(const Duration(seconds: 5));
  }
  void addLoss(
      String userId,
      ) async {
    final response = await http.post(
      Uri.parse('$_baseURLHttp/addLoss.php'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: convert.jsonEncode(<String, String>{
        'uid': userId,
      }),
    ).timeout(const Duration(seconds: 5));
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
          if(!guest) {
            addWin(uid, difficulty);
          }
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
          if(!guest) {
            addLoss(uid);
          }
          winsLastMatch = false;
          btnMode = "Restart";
        } else {
          restart();
          alreadylost = false;
        }
      }
    });
  }


  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
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
                  color: Colors.white,),
            ),
                IconButton(
                  onPressed: restart,
                  style: ButtonStyle(
                    elevation: MaterialStateProperty.all(0),
                  ),
                  icon: const Icon(
                    Icons.restart_alt,
                    color: Colors.yellow,
                  ),
                ),
          ],
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple[800],
        elevation: 0,
      ),
      drawer: Drawer(
        elevation: 0,
        shape: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.yellow, width: 20.0)),
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/bgc.jpeg"),
              fit: BoxFit.cover,
              opacity: 0.7
            ),
          ),
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
                      Expanded(
                          child: ListTile(
                        title: Text(
                          username,
                          style: const TextStyle(color: Colors.white, fontSize: 10),
                        ),
                        subtitle: Text(
                          username=="Guest"?"Sign Up ->":"Logout? ->",
                          style: const TextStyle(color: Colors.white, fontSize: 8.0),
                        ),
                            trailing: username=="Guest"? IconButton(onPressed: (){
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (context)=>const SignUp())
                              );
                            }, icon: const Icon(Icons.login,color: Colors.white)):IconButton(onPressed: () async {
                              final SharedPreferences prefs = await SharedPreferences.getInstance();
                              prefs.remove('username');
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (context)=>const Login())
                              );
                            }, icon: const Icon(Icons.exit_to_app,color: Colors.white,),),
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
                        difficulty = item!;
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
                  const SizedBox(
                    height: 30.0,
                  ),
                  ElevatedButton(onPressed: (){
                    setState(() {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const Leaderboard()));
                    });
                  }, child: const Text("Leaderboard")),
                  const SizedBox(height: 16,),
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
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/nav4.jpg"),
            opacity: 0.6,
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                    image: const DecorationImage(
                        image: AssetImage("assets/bgc.jpeg"),
                        fit: BoxFit.cover,
                        opacity: 0.5
                    ),
                  ),
                      child: Text("You Have $tries Attempts",
                          style: const TextStyle(
                              fontSize: 15.0,
                              color: Colors.yellow,
                              fontWeight: FontWeight.w900)),
                    ),
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
                  child: TextFormField(
                    controller: _textController,
                    keyboardType: TextInputType.number,
                    autofocus: false,
                    mouseCursor: MaterialStateMouseCursor.textable,
                    cursorColor: Colors.yellow,
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Enter a number",
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
      ),
    );
  }
}