import 'package:flutter/foundation.dart';

import 'playing_card.dart';

class Player extends ChangeNotifier {
  static const maxCards = 7;

  final List<PlayingCard> hand =
      List.generate(maxCards, (index) => PlayingCard.random());

  void removeCard(PlayingCard card) {
    hand.remove(card);
    notifyListeners();
  }
}
