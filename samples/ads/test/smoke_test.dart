// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:ads/ads/my_banner_ad.dart';
import 'package:ads/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('smoke test', (tester) async {
    // Build our game and trigger a frame.
    await tester.pumpWidget(MyApp());

    // Verify that the 'Play' button is shown.
    expect(find.text('Play'), findsOneWidget);

    // Tap 'Play'.
    await tester.tap(find.text('Play'));
    await tester.pumpAndSettle();
    expect(find.text('Select level'), findsOneWidget);

    // Tap level 1.
    await tester.tap(find.text('Level #1'));
    await tester.pumpAndSettle();

    // Find the first level's "tutorial" text.
    expect(find.text('Drag the slider to 5% or above!'), findsOneWidget);

    // Win game by tapping into the middle of the slider.
    await tester.tap(find.byType(Slider));

    // Wait for success animation.
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // Expect the banner.
    expect(find.byType(MyBannerAdWidget), findsOneWidget);
  });
}
