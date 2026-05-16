package ui;

import utilShitsie.controls.Controls;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.FlxG;
import flixel.addons.ui.FlxUIInputText;
import utilShitsie.EnboState;

class GamejoltLoginState extends EnboState
{
	var topText:FlxText;

	var usernameInput:FlxUIInputText;
	var usertokenInput:FlxUIInputText;

	override function create()
	{
		super.create();

		FlxG.camera.bgColor = FlxColor.GRAY;

		usernameInput = new FlxUIInputText(0, 0, Math.round(FlxG.width / 4), '', 32);
		usertokenInput = new FlxUIInputText(0, 0, Math.round(FlxG.width / 4), '', 32);

		usernameInput.screenCenter(X);
		usernameInput.x -= usernameInput.width;
		usertokenInput.screenCenter(X);
		usertokenInput.x += usernameInput.width;

		usernameInput.screenCenter(Y);
		usertokenInput.screenCenter(Y);

		usernameInput.borderSize = 2;
		usertokenInput.borderSize = 2;

		topText = new FlxText();
		topText.size = 32;

		topText.text = 'GAMEJOLT LOGIN MENU';
		topText.screenCenter(X);
		topText.y = topText.height;

		addMultiple([
			topText,

			usernameInput,
			usertokenInput,

			new FlxText(usernameInput.x, usernameInput.y - 24, 0, 'Username', 16),
			new FlxText(usertokenInput.x, usertokenInput.y - 24, 0, 'Usertoken', 16),
		]);

		FlxG.mouse.visible = true;
	}

	override function destroy()
	{
		FlxG.mouse.visible = false;

		super.destroy();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (Controls.leave.justPressed && !usernameInput.hasFocus && !usertokenInput.hasFocus)
			FlxG.switchState(() -> new MainMenuState());
	}
}
