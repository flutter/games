A starter Flutter project with a minimal shell of a game
including the following features:

- main menu screen
- basic navigation
- game-y theming
- settings
- sound

You can jump directly into building your game in `lib/play_session/`.

When you're ready for things like ads, in-app purchases, achievements,
analytics, crash reporting, and so on, 
there are resources ready for you
at [flutter.dev/games](https://flutter.dev/games).


# Development

To run the app in debug mode:

    flutter run

It is often convenient to develop your game as a desktop app.
For example, you can run `flutter run -d macOS`, and get the same UI
in a desktop window on a Mac. That way, you don't need to use a
simulator/emulator or attach a mobile device.


## Code organization

Code is organized in a loose and shallow feature-first fashion.
In `lib/`, you'll therefore find directories such as `audio`,
`main_menu` or `settings`. Nothing fancy, but usable.

```text
lib
├── app_lifecycle
├── audio
├── game_internals
├── level_selection
├── main_menu
├── play_session
├── player_progress
├── settings
├── style
├── win_game
│
├── main.dart
└── router.dart
```

The state management approach is intentionally low-level. That way, it's easy to
take this project and run with it, without having to learn new paradigms, or having
to remember to run `flutter pub run build_runner watch`. You are,
of course, encouraged to use whatever paradigm, helper package or code generation
scheme that you prefer.


## Building for production

To build the app for iOS (and open Xcode when finished):

```shell
flutter build ipa && open build/ios/archive/Runner.xcarchive
```

To build the app for Android (and open the folder with the bundle when finished):

```shell
flutter build appbundle && open build/app/outputs/bundle/release
```

While the template is primarily meant for mobile games, you can also publish
for the web. This might be useful for web-based demos, for example,
or for rapid play-testing. The following command requires installing
[`peanut`](https://pub.dev/packages/peanut/install).

```bash
flutter pub global run peanut \
--web-renderer canvaskit \
--extra-args "--base-href=/name_of_your_github_repo/" \
&& git push origin --set-upstream gh-pages
```

The last line of the command above automatically pushes
your newly built web game to GitHub pages, assuming that you have
that set up.

Lastly, it is of course possible to build your game for desktop platforms:
Windows, Linux and macOS. 
Follow the [standard instructions](https://docs.flutter.dev/platform-integration/desktop).


# Integrations

Focus on making your core gameplay fun first. Don't worry about
integrations like ads, in-app purchases, analytics, and so on.
It's easy to add them later, and you can find recipes and codelabs
for them at [flutter.dev/games](https://flutter.dev/games).

Change the package name of your game
before you start any of the deeper integrations.
[StackOverflow has instructions](https://stackoverflow.com/a/51550358/1416886)
for this, and the [`rename`](https://pub.dev/packages/rename) tool
(on pub.dev) automates the process.


## Audio

Audio is enabled by default and ready to go. You can modify code
in `lib/audio/` to your liking.

You can find some music
tracks in `assets/music` — these are Creative Commons Attribution (CC-BY)
licensed, and are included in this repository with permission. If you decide
to keep these tracks in your game, please don't forget to give credit
to the musician, [Mr Smith][].

[Mr Smith]: https://freemusicarchive.org/music/mr-smith

The repository also includes a few sound effect samples in `assets/sfx`.
These are public domain (CC0) and you will almost surely want to replace
them because they're just recordings of a developer doing silly sounds
with their mouth.

## Logging

The template uses the [`logging`](https://pub.dev/packages/logging) package
to log messages to the console. This makes it very easy to log messages
from anywhere with something like the following:

```dart
import 'package:logging/logging.dart';

final _log = Logger('Foo');

void foo() {
  _log.info('Hello, world!');
}
```

This will show up in the console as:

```text
[Foo] Hello, world!
```

When using Flutter DevTools, all the metadata of the log message is preserved, 
so you can filter by logger name, log level, and so on.

Later, when you're closer to production, you can gather these log messages
(see `lib/main.dart`) and send them to a service like Firebase Crashlytics
when appropriate.
See [`firebase_crashlytics`](https://pub.dev/packages/firebase_crashlytics)
for more information.


## Settings

The settings page is enabled by default, and accessible both
from the main menu and through the "gear" button in the play session screen.

Settings are saved to local storage using the 
[`shared_preferences`](https://pub.dev/packages/shared_preferences)
package.
To change what preferences are saved and how, edit files in
`lib/settings/persistence`.


# Icon

To update the launcher icon, first change the files
`assets/icon-adaptive-foreground.png` and `assets/icon.png`.
Then, run the following:

```bash
dart run flutter_launcher_icons:main
```

You can [configure](https://github.com/fluttercommunity/flutter_launcher_icons#book-guide)
the look of the icon in the `flutter_icons:` section of `pubspec.yaml`.


# Troubleshooting

## CocoaPods

When upgrading to higher versions of Flutter or plugins, you might encounter an error when
building the iOS or macOS app. A good first thing to try is to delete the `ios/Podfile.lock`
file (or `macos/Podfile.lock`, respectively), then trying to build again. (You can achieve
a more thorough cleanup by running `flutter clean` instead.)

If this doesn't help, here are some more methods:

- See if everything is still okay with your Flutter and CocoaPods installation
  by running `flutter doctor`. Revisit the macOS 
  [Flutter installation guide](https://docs.flutter.dev/get-started/install/macos)
  if needed.
- Update CocoaPods specs directory:

  ```sh
  cd ios
  pod repo update
  cd ..
  ```

  (Substitute `ios` for `macos` when appropriate.)
- Open the project in Xcode, 
  [increase the build target](https://stackoverflow.com/a/38602597/1416886),
  then select _Product_ > _Clean Build Folder_.

## Warnings in console

When running the game for the first time, you might see warnings like the following:

> Note: Some input files use or override a deprecated API.

or

> warning: 'viewState' was deprecated in macOS 11.0: Use -initWithState: instead

These warning come from the various plugins that are used by the template. They are not harmful 
and can be ignored. The warnings are meant for the plugin authors, not for you, the game developer.
