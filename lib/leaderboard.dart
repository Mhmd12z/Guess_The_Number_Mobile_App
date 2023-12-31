import 'package:flutter/material.dart';
import 'player.dart';

class Leaderboard extends StatefulWidget {
  const Leaderboard({super.key});

  @override
  State<Leaderboard> createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard> {
  bool _load = false;

  void update(bool success) {
    setState(() {
      _load = true;
      if (!success) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('failed to load data')));
      }
    });
  }

  @override
  void initState() {
    updatePlayers(update);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Leaderboard",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w900),),
            IconButton(onPressed: !_load ? null : () {
              setState(() {
                _load = false;
                updatePlayers(update);
              });
            }, icon: const Icon(Icons.refresh,color: Colors.white,)),
          ]),
          flexibleSpace: const Image(
            image: AssetImage('assets/nav2.jpg'),
            fit: BoxFit.cover,
          ),
          leading: IconButton(onPressed: (){
            Navigator.of(context).pop();
          }, icon: const Icon(Icons.arrow_back,color: Colors.white,)),
          backgroundColor: Colors.transparent,
          centerTitle: true,
        ),
      body: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/bgc.jpeg"),
                  fit: BoxFit.cover,
                  opacity: 0.5
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(onPressed: !_load ? null : () {
                    setState(() {
                      _load = false;
                      updatePlayers(update);
                    });
                  }, child: const Text("All",style: TextStyle(fontWeight: FontWeight.w900),)),
                  TextButton(onPressed: !_load ? null : () {
                    setState(() {
                      _load = false;
                      getEasy(update);
                    });
                  }, child: const Text("Easy",style: TextStyle(fontWeight: FontWeight.w900),)),
                  TextButton(onPressed: !_load ? null : () {
                    setState(() {
                      _load = false;
                      getMedium(update);
                    });
                  }, child: const Text("Medium",style: TextStyle(fontWeight: FontWeight.w900),)),
                  TextButton(onPressed: !_load ? null : () {
                    setState(() {
                      _load = false;
                      getHard(update);
                    });
                  }, child: const Text("Hard",style: TextStyle(fontWeight: FontWeight.w900),)),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/bgc.jpeg"),
                    fit: BoxFit.cover,
                    opacity: 0.5
                ),
              ),
              child: _load
                  ? const ShowPlayers()
                  : const Center(
                child: SizedBox(
                    width: 100,
                    height: 100,
                    child: CircularProgressIndicator()
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
