class Player {
  String name;
  List<int> scores;
  late int totalScores;

  Player({required this.name, required this.totalScores}) : scores = [];

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      name: json['name'],
      totalScores: json['totalScores'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'totalScores': totalScores,
    };
  }

  void addScore(int score) {
    scores.add(score);
  }

  void addTotalScores() {
    this.totalScores = this.getTotalScore();
  }

  int getTotalScore() {
    return scores.fold(0, (sum, score) => sum + score);
  }

  @override
  String toString() {
    return '$name: ${getTotalScore()}';
  }

  void addName(String newName) {
    name = newName;
  }
}
