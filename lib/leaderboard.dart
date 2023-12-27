import 'package:flutter/material.dart';
import 'player.dart';

class Leaderboard extends StatefulWidget {
  const Leaderboard({super.key});

  @override
  State<Leaderboard> createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard> {
  bool _load = false; // used to show products list or progress bar

  void update(bool success) {
    setState(() {
      _load = true; // show product list
      if (!success) {
        // API request failed
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('failed to load data')));
      }
    });
  }

  @override
  void initState() {
    // update data when the widget is added to the tree the first time.
    updatePlayers(update);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Leaderboard"),
          leading: IconButton(onPressed: !_load ? null : () {
            setState(() {
              _load = false; // show progress bar
              updatePlayers(update); // update data asynchronously
            });
          }, icon: const Icon(Icons.refresh)),
          centerTitle: true,
        ),
        body: _load
            ? const ShowPlayers()
            : const Center(
                child: SizedBox(
                    width: 100,
                    height: 100,
                    child: CircularProgressIndicator())));
  }
}
