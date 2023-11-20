class Score{
  int _wins = 0;
  int _loses = 0;
  static int _total=0;
  final List<String> _matches = ["You Not Played"];
  bool _win=false;
  Score(int wins, int loses, bool win){
    _wins = wins;
    _loses = loses;
    _total = _wins+_loses;
    _win = win;
    if(win){
      _matches.add("win");
    }else{
      _matches.add("lose");
    }
  }
  @override
  String toString(){
    if((_wins + _loses) == 0){
      return """
You Not Played Yet
      """;
    }
    return """
You Wins : $_wins Times

You Loses: $_loses Times
    """;
  }
  String getMatches(){
    if((_wins + _loses) == 0){
      return "";
    }
    if(_win){
      return "You wins last match";
    }
    return "You losed last match";
  }
  int getTotal(){
    return _total;
  }
}