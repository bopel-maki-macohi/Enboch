package ui;

import flixel.util.FlxTimer;
import utilShitsie.api.GamejoltAPI;
import flixel.addons.ui.FlxUIButton;
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

	var authBtn:FlxUIButton;

	var canDoAnything:Bool = true;

	override function create()
	{
		super.create();

		FlxG.camera.bgColor = FlxColor.GRAY;

		usernameInput = new FlxUIInputText(0, 0, Math.round(FlxG.width / 3), GamejoltAPI.username, 32);
		usertokenInput = new FlxUIInputText(0, 0, Math.round(FlxG.width / 3), GamejoltAPI.usertoken, 32);

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
		topText.y = topText.height;

		topText.alignment = CENTER;

		var usernameTXT = new FlxText(usernameInput.getGraphicMidpoint().x, usernameInput.y - 24, 0, 'Username', 16);
		var usertokenTXT = new FlxText(usertokenInput.getGraphicMidpoint().x, usertokenInput.y - 24, 0, 'Usertoken', 16);

		usernameTXT.x -= usernameTXT.width / 2;
		usertokenTXT.x -= usertokenTXT.width / 2;

		authBtn = new FlxUIButton(0, 0, 'Log in', authBtnClick);

		authBtn.resize(authBtn.width * 2, authBtn.height * 2);
		authBtn.setLabelFormat(null, authBtn.label.size * 2, FlxColor.BLACK, CENTER);

		for (point in authBtn.labelOffsets)
		{
			point.y -= 6;
		}

		authBtn.screenCenter();
		authBtn.y += authBtn.height * 2;

		addMultiple([topText, usernameInput, usertokenInput, usernameTXT, usertokenTXT, authBtn]);

		FlxG.mouse.visible = true;
	}

	function authBtnClick()
	{
		if (!canDoAnything)
			return;

		canDoAnything = false;
		FlxG.sound.play('ui_select'.makePath(audio));
		GamejoltAPI.login(usernameInput.text, usertokenInput.text, onAuthThingy);
	}

	function onAuthThingy(authed:Bool)
	{
		if (authed)
		{
			topText.text = 'GAMEJOLT LOGIN MENU\nLOGGED IN!';
			FlxG.sound.play('gamejolt_loggedIn'.makePath(audio));
		}
		else
		{
			topText.text = 'GAMEJOLT LOGIN MENU\nCould not log in...';
			FlxG.sound.play('gamejolt_loginFAIL'.makePath(audio));
		}

		FlxTimer.wait(1, () ->
		{
			FlxG.switchState(() -> new MainMenuState());
		});
	}

	override function destroy()
	{
		FlxG.mouse.visible = false;

		super.destroy();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		topText.screenCenter(X);

		if (usernameInput != null)
			if (usernameInput.hasFocus && !canDoAnything)
				usernameInput.hasFocus = canDoAnything;

		if (usertokenInput != null)
			if (usertokenInput.hasFocus && !canDoAnything)
				usertokenInput.hasFocus = canDoAnything;

		if (Controls.leave.justPressed && !usernameInput.hasFocus && !usertokenInput.hasFocus)
			FlxG.switchState(() -> new MainMenuState());
	}
}
