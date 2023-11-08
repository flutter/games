// Copyright 2023, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../game_internals/board_state.dart';
import 'player_hand_widget.dart';
import 'playing_area_widget.dart';

/// This widget defines the game UI itself, without things like the settings
/// button or the back button.
class BoardWidget extends StatefulWidget {
  const BoardWidget({super.key});

  @override
  State<BoardWidget> createState() => _BoardWidgetState();
}

class _BoardWidgetState extends State<BoardWidget> {
  @override
  Widget build(BuildContext context) {
    final boardState = context.watch<BoardState>();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: Wrap(
            alignment: WrapAlignment.center,
            spacing: 20,
            runSpacing: 20,
            children: [
              PlayingAreaWidget(boardState.areaOne),
              PlayingAreaWidget(boardState.areaTwo),
            ],
          ),
        ),
        PlayerHandWidget(),
      ],
    );
  }
}
