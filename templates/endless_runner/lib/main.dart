import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nes_ui/nes_ui.dart';
import 'package:provider/provider.dart';

import 'router.dart';
import 'app_lifecycle/app_lifecycle.dart';
import 'audio/audio_controller.dart';
import 'player_progress/player_progress.dart';
import 'settings/settings.dart';
import 'style/palette.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.setLandscape();
  await Flame.device.fullScreen();
  runApp(const MyGame());
}

class MyGame extends StatelessWidget {
  const MyGame({super.key});

  @override
  Widget build(BuildContext context) {
    return AppLifecycleObserver(
      child: MultiProvider(
        providers: [
          Provider(create: (context) => Palette()),
          ChangeNotifierProvider(create: (context) => PlayerProgress()),
          Provider(create: (context) => SettingsController()),
          // Set up audio.
          ProxyProvider2<SettingsController, AppLifecycleStateNotifier,
              AudioController>(
            // Ensures that music starts immediately.
            lazy: false,
            create: (context) => AudioController(),
            update: (context, settings, lifecycleNotifier, audio) {
              audio!.attachDependencies(lifecycleNotifier, settings);
              return audio;
            },
            dispose: (context, audio) => audio.dispose(),
          ),
        ],
        child: Builder(builder: (context) {
          final palette = context.watch<Palette>();

          return MaterialApp.router(
            title: 'Endless Runner',
            theme: flutterNesTheme().copyWith(
              colorScheme: ColorScheme.fromSeed(
                seedColor: palette.seed.color,
                surface: palette.backgroundMain.color,
              ),
              textTheme: GoogleFonts.pressStart2pTextTheme().apply(
                bodyColor: palette.text.color,
                displayColor: palette.text.color,
              ),
            ),
            routeInformationProvider: router.routeInformationProvider,
            routeInformationParser: router.routeInformationParser,
            routerDelegate: router.routerDelegate,
          );
        }),
      ),
    );
  }
}
