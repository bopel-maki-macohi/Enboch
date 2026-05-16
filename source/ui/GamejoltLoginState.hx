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

		usernameInput = new FlxUIInputText(0, 0, Math.round(FlxG.width / 3), '', 32);
		usertokenInput = new FlxUIInputText(0, 0, Math.round(FlxG.width / 3), '', 32);

		usernameInput.screenCenter(X);
		usernameInput.x -= usernameInput.width / 1.5;

		usertokenInput.screenCenter(X);
		usertokenInput.x += usernameInput.width / 1.5;

		usernameInput.screenCenter(Y);
		usertokenInput.screenCenter(Y);

		usernameInput.fieldBorderThickness = usertokenInput.fieldBorderThickness = 2;

		topText = new FlxText();
		topText.size = 32;

		topText.text = 'GAMEJOLT LOGIN MENU';
		topText.screenCenter(X);
		topText.y = topText.height;

		var usernameTXT = new FlxText(usernameInput.getGraphicMidpoint().x, usernameInput.y - 24, 0, 'Username', 16);
		var usertokenTXT = new FlxText(usertokenInput.getGraphicMidpoint().x, usertokenInput.y - 24, 0, 'Usertoken', 16);

		usernameTXT.x -= usernameTXT.width / 2;
		usertokenTXT.x -= usertokenTXT.width / 2;

		addMultiple([
			topText,

			usernameInput,
			usertokenInput,

			usernameTXT,
			usertokenTXT,
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
