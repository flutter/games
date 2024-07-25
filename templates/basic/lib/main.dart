// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:developer' as dev;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:logging/logging.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import 'app_lifecycle/app_lifecycle.dart';
import 'blocs/blocs.dart';
import 'cubits/cubits.dart';
import 'router.dart';
import 'style/palette.dart';

Future<void> main() async {
  // Basic logging setup.
  Logger.root.level = kDebugMode ? Level.FINE : Level.INFO;
  Logger.root.onRecord.listen((record) {
    dev.log(
      record.message,
      time: record.time,
      level: record.level.value,
      name: record.loggerName,
    );
  });

  WidgetsFlutterBinding.ensureInitialized();
  // Put game into full screen mode on mobile devices.
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  // Lock the game to portrait mode on mobile devices.
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorage.webStorageDirectory
        : await getTemporaryDirectory(),
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AppLifecycleObserver(
      child: Provider(
        create: (context) => Palette(),
        child: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => AudioCubit()..initializeAudio(),
            ),
            BlocProvider(
              create: (context) => PlayerProgressBloc(),
            ),
            BlocProvider(
              create: (context) => SettingsBloc(
                appLifecycleNotifier: context.read<AppLifecycleStateNotifier>(),

                /// Enables the [AudioCubit] to track changes to settings.
                /// Namely, when any of [SettingsState.audioOn],
                /// [SettingsState.musicOn] or [SettingsState.soundsOn] changes,
                /// the audio cubit will act accordingly.
                audioCubit: context.read<AudioCubit>(),
              ),
            ),
          ],
          child: Builder(builder: (context) {
            final palette = context.watch<Palette>();

            return MaterialApp.router(
              title: 'My Flutter Game',
              theme: ThemeData.from(
                colorScheme: ColorScheme.fromSeed(
                  seedColor: palette.darkPen,
                  surface: palette.backgroundMain,
                ),
                textTheme: TextTheme(
                  bodyMedium: TextStyle(color: palette.ink),
                ),
                useMaterial3: true,
              ).copyWith(
                // Make buttons more fun.
                filledButtonTheme: FilledButtonThemeData(
                  style: FilledButton.styleFrom(
                    textStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              routerConfig: router,
            );
          }),
        ),
      ),
    );
  }
}
