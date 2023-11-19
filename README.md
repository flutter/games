# games

[![Build Status](https://github.com/flutter/games/actions/workflows/main.yml/badge.svg)](https://github.com/flutter/games/actions/workflows/main.yml)

Home to the official code for the Flutter Casual Games Toolkit 
and other Flutter gaming templates.

Visit [flutter.dev/games](https://flutter.dev/games) for more information.

If you're new to Flutter, you first need to install the 
[Flutter SDK](https://flutter.dev/).


## Organization

The projects in this repository are divided into two broad categories:

1. **Templates.** A small number of starting points for your game project.
   Templates are intended to give you a simple project structure
   on top of which you can build your game.
   They differ to accommodate different game types, 
   from the simplest casual games through drag&drop board games
   to 2D platformers.

2. **Samples.** Intended to show functionality beyond the basics,
   such as multiplayer or ads integration.


```text
.
├── templates
│   ├── basic
│   ├── card
│   └── endless_runner
└── samples
    ├── ads
    ├── multiplayer
    └── ...
```


## How to use

1. Clone this repository.

   To minimize download size, you can use a 
   [partial clone](https://github.blog/2020-12-21-get-up-to-speed-with-partial-clone-and-shallow-clone/):

   ```shell
   git clone --filter=blob:none https://github.com/flutter/games.git
   ```

   (Alternatively, you can 
   [download the ZIP file](https://github.com/flutter/games/archive/refs/heads/main.zip)
   and uncompress it on your workstation.)

2. `cd` into the project you are interested in. For example:

   ```shell
   cd templates/card
   ```

   (Alternatively, you can copy the contents of a project to somewhere else,
   and change to that directory.)

3. (Optional) Rename the project with the 
   [`rename` tool](https://pub.dev/packages/rename).

4. Open the project in your favorite editor and enjoy.


## Interested in contributing?

See the [contributor's guide](CONTRIBUTING.md)!


## Questions or issues?

If you have a general question about one of these samples or how to adapt its
techniques for one of your own apps, try one of these resources:

* [The FlutterDev Google Group](https://groups.google.com/forum/#!forum/flutter-dev)
* [The FlutterDev Discord](https://discord.gg/rflutterdev)
* [The Flame Discord](https://discord.com/invite/pxrBmy4)
* [StackOverflow](https://stackoverflow.com/questions/tagged/flutter)

If you run into a bug in one of the samples, please file an issue in the
[`flutter/flutter` issue tracker](https://github.com/flutter/flutter/issues).
