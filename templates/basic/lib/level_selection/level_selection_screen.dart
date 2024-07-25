// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:basic/cubits/cubits.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../audio/sounds.dart';
import '../blocs/blocs.dart';
import '../style/my_button.dart';
import '../style/palette.dart';
import '../style/responsive_screen.dart';
import 'levels.dart';

class LevelSelectionScreen extends StatelessWidget {
  const LevelSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();

    return Scaffold(
      backgroundColor: palette.backgroundLevelSelection,
      body: ResponsiveScreen(
        squarishMainArea: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Center(
                child: Text(
                  'Select level',
                  style:
                      TextStyle(fontFamily: 'Permanent Marker', fontSize: 30),
                ),
              ),
            ),
            const SizedBox(height: 50),
            Expanded(
              child: BlocBuilder<PlayerProgressBloc, PlayerProgressState>(
                builder: (context, state) {
                  return ListView(
                    children: [
                      for (final level in gameLevels)
                        ListTile(
                          enabled:
                              state.highestLevelReached >= level.number - 1,
                          onTap: () {
                            context.read<AudioCubit>().playSfx(
                                  SfxType.buttonTap,
                                  context.read<SettingsBloc>().state,
                                );

                            GoRouter.of(context)
                                .go('/play/session/${level.number}');
                          },
                          leading: Text(level.number.toString()),
                          title: Text('Level #${level.number}'),
                        )
                    ],
                  );
                },
              ),
            ),
          ],
        ),
        rectangularMenuArea: MyButton(
          onPressed: () {
            GoRouter.of(context).go('/');
          },
          child: const Text('Back'),
        ),
      ),
    );
  }
}
