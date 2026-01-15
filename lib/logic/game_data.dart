import '../utils/shared_import.dart';

class GameData {
  late int level;
  late int score;
  late bool isPlaying;
  int? targetIndex;
  int totalTime = 0;
  int maxScore = 0;

  GameData() {
    level = 1;
    score = 0;
    isPlaying = true;
  }

  void reset() {
    level = 1;
    score = 0;
    isPlaying = true;

    totalTime = 0;
    maxScore = 0;
  }

  void nextLevel(int timeLeft) {
    targetIndex = Random().nextInt((getGridSize() * getGridSize()) - 1);
    level++;
    print("-------24>>>${timeLeft}");
    addScore(1 + timeLeft);
    // score = 0;
    totalTime += (10 - timeLeft);
    maxScore += 11;
    print('level: $level');
  }

  void addScore(int value) {
    score += value;
  }

  void endGame() {
    isPlaying = false;
  }

  int getGridSize() {
    if (level >= 15 && level < 30) return 3;
    if (level >= 30 && level < 50) return 4;
    if (level >= 50) return 5;
    return 2;
  }
}
