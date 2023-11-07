import 'package:flame/palette.dart';

/// A palette of colors to be used in the game.
///
/// The reason we're not going with something like Material Design's
/// `Theme` is simply that this is simpler to work with and yet gives
/// us everything we need for a game.
///
/// Games generally have more radical color palettes than apps. For example,
/// every level of a game can have radically different colors.
/// At the same time, games rarely support dark mode.
///
/// Colors here are implemented as getters so that hot reloading works.
/// In practice, we could just as easily implement the colors
/// as `static const`. But this way the palette is more malleable:
/// we could allow players to customize colors, for example,
/// or even get the colors from the network.
class Palette {
  PaletteEntry get seed => const PaletteEntry(Color(0xFF0050bc));
  PaletteEntry get text => const PaletteEntry(Color(0xee352b42));
  PaletteEntry get backgroundMain => const PaletteEntry(Color(0xffa2fff3));
  PaletteEntry get backgroundLevelSelection =>
      const PaletteEntry(Color(0xffffcd75));
  PaletteEntry get backgroundPlaySession =>
      const PaletteEntry(Color(0xffa2fff3));
  PaletteEntry get backgroundSettings => const PaletteEntry(Color(0xffbfc8e3));
}
