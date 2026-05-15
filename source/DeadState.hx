package;

import flixel.tweens.FlxTween;
import flixel.sound.FlxSound;
import flixel.FlxSprite;
import utilShitsie.EnboState;
import flixel.FlxG;
import flixel.text.FlxText;

class DeadState extends EnboState
{
	var text = new FlxText(0, 0, 0, 'haha u dead lmao', 16);
	var sprite = new FlxSprite();
	var sound:FlxSound = new FlxSound();

	override function create()
	{
		super.create();

		sprite = new FlxSprite(0, 0, '${PlayState.char}/death'.getPath(image));
		add(sprite);

		add(text);
		text.screenCenter();
		text.alpha = 0;

		sound.loadEmbedded('death-${PlayState.char}'.getPath(audio));
		sound.play();

		FlxTween.tween(text, {alpha: 1}, 1, {
			startDelay: (sound.length / 1000) / 2
		});
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.justReleased.ENTER)
			FlxG.switchState(() -> new PlayState());
	}
}
