import 'dart:math';

class Block {
  bool isHighlighted = false;
  bool isTapped = false;

  void highlight() {
    isHighlighted = true;
  }

  void unhighlight() {
    isHighlighted = false;
  }

  void tap() {
    isTapped = true;
  }

  void reset() {
    isHighlighted = false;
    isTapped = false;
  }
  
  static int randomHighlightedIndex(int level) {
    return Random().nextInt(level * level);
  }
}
