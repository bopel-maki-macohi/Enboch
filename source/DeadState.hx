package;

import ui.MainMenuState;
import utilShitsie.controls.Controls;
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
		transIn = null;

		super.create();

		sprite = new FlxSprite(0, 0, 'characters/${PlayState.character}/death'.makePath(image));
		add(sprite);

		text.text += '\n\nTotal pay: ${Paycheck.totalPay} (+ ${Paycheck.earned})';
		text.text += '\n\nPress any of the following: ${Controls.accept.keyList} to go back';
		text.text += '\n\nPress any of the following: ${Controls.leave.keyList} to go to the main menu';

		add(text);
		text.screenCenter();
		text.alpha = 0;

		sound.loadEmbedded('death-${PlayState.character}'.makePath(audio));
		sound.play();

		FlxTween.tween(text, {alpha: 1}, (sound.length / 1000) / 2, {
			startDelay: (sound.length / 1000) / 2
		});
		FlxTween.tween(sprite, {alpha: 0}, (sound.length / 1000) / 2, {
			startDelay: (sound.length / 1000) / 2
		});
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (Controls.leave.justPressed)
			FlxG.switchState(() -> new MainMenuState());

		if (Controls.accept.justPressed)
			FlxG.switchState(() -> new PlayState());
	}
}
