List<String> soundTypeToFilename(SfxType type) => switch (type) {
      SfxType.jump => const [
          'jump1.mp3',
        ],
      SfxType.doubleJump => const [
          'double_jump1.mp3',
        ],
      SfxType.hit => const [
          'hit1.mp3',
          'hit2.mp3',
        ],
      SfxType.damage => const [
          'damage1.mp3',
          'damage2.mp3',
        ],
      SfxType.score => const [
          'score1.mp3',
          'score2.mp3',
        ],
      SfxType.buttonTap => const [
          'click1.mp3',
          'click2.mp3',
          'click3.mp3',
          'click4.mp3',
        ]
    };

/// Allows control over loudness of different SFX types.
double soundTypeToVolume(SfxType type) {
  switch (type) {
    case SfxType.score:
    case SfxType.jump:
    case SfxType.doubleJump:
    case SfxType.damage:
    case SfxType.hit:
      return 0.4;
    case SfxType.buttonTap:
      return 1.0;
  }
}

enum SfxType {
  score,
  jump,
  doubleJump,
  hit,
  damage,
  buttonTap,
}
