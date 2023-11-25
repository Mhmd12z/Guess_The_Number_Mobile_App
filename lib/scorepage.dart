import 'package:flutter/material.dart';
import 'score.dart';

class ScorePage extends StatefulWidget {
  const ScorePage({Key? key}) : super(key: key);
  @override
  State<ScorePage> createState() => _ScorePageState();
}

class _ScorePageState extends State<ScorePage> {
  @override
  Widget build(BuildContext context) {
    final score = ModalRoute.of(context)!.settings.arguments as Score;
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      appBar: AppBar(
        title: const Text("Score Dashboard",style: TextStyle(fontFamily: "PressStart2P",fontSize: 12),),
        centerTitle: true,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Icon(
              Icons.star,
              color: Colors.yellow,
              size: 100,
            ),
            const SizedBox(height: 20.0),
            Text(
              score.toString(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.yellow,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20.0),
            Text(
              'Total Played ${score.getTotal()}',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.yellow,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 16.0,),
            Text(score.getMatches(),style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)
          ],
        ),
      ),
    );
  }
}
