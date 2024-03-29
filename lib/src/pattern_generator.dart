import 'dart:math';

import 'game_pattern.dart';

class PatternGenerator {
  final Random _rand = Random();

  GamePattern getPattern() =>
      GamePattern(_possiblePatterns[_rand.nextInt(_possiblePatterns.length)]);
}

const _possiblePatterns = [
  [
    [1],
  ],
  [
    [1],
    [1],
  ],
  [
    [1, 1],
  ],
  [
    [1, 1],
    [1, 1],
  ],
  [
    [1, 0],
    [0, 1],
  ],
  [
    [0, 1],
    [1, 0],
  ],
  [
    [1, 0],
    [1, 1],
  ],
  [
    [0, 1],
    [1, 1],
  ],
  [
    [1, 1],
    [0, 1],
  ],
  [
    [1, 1],
    [1, 0],
  ],
  [
    [1, 1, 1],
  ],
  [
    [1],
    [1],
    [1],
  ],
  [
    [1, 1, 1],
    [1, 1, 1],
  ],
  [
    [1, 1],
    [1, 1],
    [1, 1],
  ],
  [
    [0, 1, 1],
    [1, 1, 0],
  ],
  [
    [1, 1, 0],
    [0, 1, 1],
  ],
  [
    [1, 0],
    [1, 1],
    [0, 1],
  ],
  [
    [0, 1],
    [1, 1],
    [1, 0],
  ],
  [
    [1, 0],
    [1, 1],
    [1, 0],
  ],
  [
    [1, 1],
    [1, 0],
    [1, 0],
  ],
  [
    [1, 0],
    [1, 0],
    [1, 1],
  ],
  [
    [0, 1],
    [1, 1],
    [0, 1],
  ],
  [
    [0, 1, 0],
    [1, 1, 1],
  ],
  [
    [1, 1, 1],
    [0, 1, 0],
  ],
  [
    [1, 0, 0],
    [1, 1, 1],
  ],
  [
    [0, 0, 1],
    [1, 1, 1],
  ],
  [
    [1, 1, 1],
    [0, 0, 1],
  ],
  [
    [1, 1, 1],
    [1, 0, 0],
  ],
  [
    [0, 1],
    [0, 1],
    [1, 1],
  ],
  [
    [1, 1],
    [0, 1],
    [0, 1],
  ],
  [
    [1, 0],
    [0, 1],
    [1, 0],
  ],
  [
    [0, 1],
    [1, 0],
    [0, 1],
  ],
  [
    [1, 0, 1],
    [0, 1, 0],
  ],
  [
    [0, 1, 0],
    [1, 0, 1],
  ],
  [
    [1, 0, 0],
    [0, 1, 0],
    [0, 0, 1],
  ],
  [
    [0, 0, 1],
    [0, 1, 0],
    [1, 0, 0],
  ],
  [
    [0, 1, 0],
    [1, 0, 1],
    [0, 1, 0],
  ],
  [
    [0, 1, 0],
    [1, 1, 1],
    [0, 1, 0],
  ],
  [
    [1, 0, 1],
    [1, 0, 1],
    [1, 0, 1],
  ],
  [
    [1, 0, 1],
    [0, 1, 0],
    [1, 0, 1],
  ],
  [
    [1, 1, 1],
    [1, 1, 1],
    [1, 1, 1],
  ],
  [
    [1, 0, 0],
    [1, 0, 0],
    [1, 1, 1],
  ],
  [
    [1, 1, 1],
    [0, 0, 1],
    [0, 0, 1],
  ],
  [
    [0, 0, 1],
    [0, 0, 1],
    [1, 1, 1],
  ],
  [
    [1, 1, 1],
    [1, 0, 0],
    [1, 0, 0],
  ],
  [
    [1, 1, 1],
    [1, 0, 1],
    [1, 1, 1],
  ],
  [
    [0, 1, 0],
    [1, 1, 1],
    [1, 0, 1],
  ],
  [
    [1, 0, 1],
    [1, 1, 1],
    [0, 1, 0],
  ],
  [
    [1, 1, 0],
    [0, 1, 1],
    [1, 1, 0],
  ],
  [
    [0, 1, 1],
    [1, 1, 0],
    [0, 1, 1],
  ],
  [
    [1, 0, 0],
    [1, 1, 0],
    [1, 1, 1],
  ],
  [
    [1, 1, 1],
    [0, 1, 1],
    [0, 0, 1],
  ],
  [
    [1, 1, 1],
    [1, 1, 0],
    [1, 0, 0],
  ],
  [
    [0, 0, 1],
    [0, 1, 1],
    [1, 1, 1],
  ],
  [
    [1, 1, 1, 1],
  ],
  [
    [1],
    [1],
    [1],
    [1],
  ],
  [
    [1, 1, 1, 1, 1],
  ],
  [
    [1],
    [1],
    [1],
    [1],
    [1],
  ],
];
