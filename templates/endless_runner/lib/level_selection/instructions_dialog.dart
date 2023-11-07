import 'package:flame/components.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nes_ui/nes_ui.dart';

class InstructionsDialog extends StatefulWidget {
  const InstructionsDialog({super.key});

  @override
  State<InstructionsDialog> createState() => _InstructionsDialogState();
}

class _InstructionsDialogState extends State<InstructionsDialog> {
  final _pageController = PageController();
  late int _currentPage = _pageController.initialPage;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Instructions',
          style: TextStyle(
            fontFamily: GoogleFonts.pressStart2p().fontFamily,
            fontSize: 25,
          ),
        ),
        const SizedBox(height: 30),
        Row(
          children: [
            SizedBox(
              width: 30,
              child: _currentPage != 0
                  ? NesIconButton(
                      icon: NesIcons.leftArrowIndicator,
                      onPress: () {
                        _pageController.previousPage(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeInOut,
                        );
                      },
                    )
                  : null,
            ),
            SizedBox(
              width: 350,
              height: 100,
              child: PageView(
                controller: _pageController,
                onPageChanged: (int newPage) {
                  setState(() {
                    _currentPage = newPage;
                  });
                },
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        flex: 3,
                        child: SizedBox(
                          width: 100,
                          height: 100,
                          child: SpriteAnimationWidget.asset(
                            path: 'dash/dash_spritesheet.png',
                            data: SpriteAnimationData.sequenced(
                              amount: 3,
                              stepTime: 0.15,
                              textureSize: Vector2.all(16),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      const Flexible(
                        flex: 7,
                        child: Text(
                          'Tap/click on the screen to jump in that direction, tap again to double jump.',
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Flexible(
                        flex: 7,
                        child: Text(
                          'You have to save as many Embers as possible to clear the level.',
                        ),
                      ),
                      const SizedBox(width: 20),
                      Flexible(
                        flex: 3,
                        child: SizedBox(
                          width: 60,
                          height: 60,
                          child: SpriteAnimationWidget.asset(
                            path: 'ember.png',
                            data: SpriteAnimationData.sequenced(
                              amount: 4,
                              stepTime: 0.15,
                              textureSize: Vector2.all(16),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        flex: 4,
                        child: SizedBox(
                          width: 200,
                          height: 100,
                          child:
                              SpriteWidget.asset(path: 'enemies/obstacles.png'),
                        ),
                      ),
                      const SizedBox(width: 20),
                      const Flexible(
                        flex: 6,
                        child: Text(
                          'Watch out for these, they will make you drop your Embers.',
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 30,
              child: _currentPage != 2
                  ? NesIconButton(
                      icon: NesIcons.rightArrowIndicator,
                      onPress: () {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeInOut,
                        );
                      },
                    )
                  : null,
            ),
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }
}
