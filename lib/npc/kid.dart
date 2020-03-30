import 'package:bonfire/bonfire.dart';
import 'package:darkness_dungeon/enemies/boss.dart';
import 'package:darkness_dungeon/util/conversation.dart';
import 'package:darkness_dungeon/util/dialogs.dart';
import 'package:darkness_dungeon/util/localization/strings_location.dart';
import 'package:darkness_dungeon/util/talk.dart';
import 'package:flame/animation.dart' as FlameAnimation;

class Kid extends GameDecoration {
  bool conversationWithHero = false;
  Kid(
    Position position,
  ) : super(
          animation: FlameAnimation.Animation.sequenced(
            "npc/kid_idle_left.png",
            4,
            textureWidth: 16,
            textureHeight: 22,
          ),
          initPosition: position,
          width: 20,
          height: 26,
        );

  @override
  void update(double dt) {
    super.update(dt);
    if (!conversationWithHero) {
      Boss boss = gameRef.enemies.firstWhere((e) => e is Boss);
      if (boss != null && boss.isDead) {
        conversationWithHero = true;
        gameRef.gameCamera.moveToPositionAnimated(
          Position(
            positionInWorld.left,
            positionInWorld.top,
          ),
          finish: () {
            _startConversation();
          },
        );
      }
    }
  }

  void _startConversation() {
    Conversation.show(gameRef.context, [
      Talk(
        getString('talk_kid_2'),
        Flame.util.animationAsWidget(
          Position(80, 100),
          FlameAnimation.Animation.sequenced(
            "npc/kid_idle_left.png",
            4,
            textureWidth: 16,
            textureHeight: 22,
          ),
        ),
        personDirection: PersonDirection.RIGHT,
      ),
      Talk(
        getString('talk_player_4'),
        Flame.util.animationAsWidget(
          Position(80, 100),
          FlameAnimation.Animation.sequenced(
            "player/knight_idle.png",
            4,
            textureWidth: 16,
            textureHeight: 22,
          ),
        ),
        personDirection: PersonDirection.LEFT,
      ),
    ], finish: () {
      gameRef.gameCamera.moveToPlayerAnimated(finish: () {
        Dialogs.showCongratulations(gameRef.context);
      });
    });
  }
}