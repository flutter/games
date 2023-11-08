// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter_test/flutter_test.dart';
import 'package:card/main.dart';
import 'package:card/play_session/playing_card_widget.dart';

void main() {
  testWidgets('smoke test', (tester) async {
    // Build our game and trigger a frame.
    await tester.pumpWidget(MyApp());

    // Verify that the 'Play' button is shown.
    expect(find.text('Play'), findsOneWidget);

    // Verify that the 'Settings' button is shown.
    expect(find.text('Settings'), findsOneWidget);

    // Go to 'Settings'.
    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();
    expect(find.text('Music'), findsOneWidget);

    // Go back to main menu.
    await tester.tap(find.text('Back'));
    await tester.pumpAndSettle();

    // Tap 'Play'.
    await tester.tap(find.text('Play'));
    await tester.pumpAndSettle();
    expect(find.byType(PlayingCardWidget), findsWidgets);

    // Tap 'Back'.
    await tester.tap(find.text('Back'));
    await tester.pumpAndSettle();

    // Verify we're back on the homepage.
    expect(find.text('Play'), findsOneWidget);
  });
}
