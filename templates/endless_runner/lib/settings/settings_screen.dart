import '../player_progress/player_progress.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../style/wobbly_button.dart';
import '../style/palette.dart';
import 'custom_name_dialog.dart';
import 'settings.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  static const _gap = SizedBox(height: 60);

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsController>();
    final palette = context.watch<Palette>();

    return Scaffold(
      backgroundColor: palette.backgroundSettings.color,
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 600,
                ),
                child: ListView(
                  children: [
                    _gap,
                    const Text(
                      'Settings',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Press Start 2P',
                        fontSize: 30,
                        height: 1,
                      ),
                    ),
                    _gap,
                    const _NameChangeLine(
                      'Name',
                    ),
                    ValueListenableBuilder<bool>(
                      valueListenable: settings.soundsOn,
                      builder: (context, soundsOn, child) => _SettingsLine(
                        'Sound FX',
                        Icon(soundsOn ? Icons.graphic_eq : Icons.volume_off),
                        onSelected: () => settings.toggleSoundsOn(),
                      ),
                    ),
                    ValueListenableBuilder<bool>(
                      valueListenable: settings.musicOn,
                      builder: (context, musicOn, child) => _SettingsLine(
                        'Music',
                        Icon(musicOn ? Icons.music_note : Icons.music_off),
                        onSelected: () => settings.toggleMusicOn(),
                      ),
                    ),
                    _SettingsLine(
                      'Reset progress',
                      const Icon(Icons.delete),
                      onSelected: () {
                        context.read<PlayerProgress>().reset();

                        final messenger = ScaffoldMessenger.of(context);
                        messenger.showSnackBar(
                          const SnackBar(
                              content: Text('Player progress has been reset.')),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            _gap,
            WobblyButton(
              onPressed: () {
                GoRouter.of(context).pop();
              },
              child: const Text('Back'),
            ),
            _gap,
          ],
        ),
      ),
    );
  }
}

class _NameChangeLine extends StatelessWidget {
  final String title;

  const _NameChangeLine(this.title);

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsController>();

    return InkResponse(
      highlightShape: BoxShape.rectangle,
      onTap: () => showCustomNameDialog(context),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title,
                style: const TextStyle(
                  fontFamily: 'Press Start 2P',
                  fontSize: 20,
                )),
            const Spacer(),
            ValueListenableBuilder(
              valueListenable: settings.playerName,
              builder: (context, name, child) => Text(
                '‘$name’',
                style: const TextStyle(
                  fontFamily: 'Press Start 2P',
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsLine extends StatelessWidget {
  final String title;

  final Widget icon;

  final VoidCallback? onSelected;

  const _SettingsLine(this.title, this.icon, {this.onSelected});

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      highlightShape: BoxShape.rectangle,
      onTap: onSelected,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: 'Press Start 2P',
                  fontSize: 20,
                ),
              ),
            ),
            icon,
          ],
        ),
      ),
    );
  }
}
