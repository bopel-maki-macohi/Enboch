package enboch.ui;

import flixel.util.FlxTimer;
import enboch.utilShitsie.api.GamejoltAPI;
import flixel.addons.ui.FlxUIButton;
import enboch.utilShitsie.controls.Controls;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.FlxG;
import flixel.addons.ui.FlxUIInputText;
import enboch.utilShitsie.EnboState;

class GamejoltLoginState extends EnboState
{
	var topText:FlxText;

	var usernameInput:FlxUIInputText;
	var usertokenInput:FlxUIInputText;

	var authBtn:FlxUIButton;
	var leaveBtn:FlxUIButton;

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
		leaveBtn = new FlxUIButton(0, 0, 'Leave', leaveBtnClick);

		authBtn.resize(authBtn.width * 2, authBtn.height * 2);
		authBtn.setLabelFormat(null, authBtn.label.size * 2, FlxColor.BLACK, CENTER);

		leaveBtn.resize(leaveBtn.width * 2, leaveBtn.height * 2);
		leaveBtn.setLabelFormat(null, leaveBtn.label.size * 2, FlxColor.BLACK, CENTER);

		for (point in authBtn.labelOffsets)
			point.y -= 6;
		for (point in leaveBtn.labelOffsets)
			point.y -= 6;

		authBtn.screenCenter();
		authBtn.y += authBtn.height * 2;

		leaveBtn.screenCenter();
		leaveBtn.y += leaveBtn.height * 2;

		authBtn.x -= authBtn.width;
		leaveBtn.x += leaveBtn.width;

		addMultiple([
			topText,
			usernameInput,
			usertokenInput,
			usernameTXT,
			usertokenTXT,
			authBtn,
			leaveBtn
		]);

		FlxG.mouse.visible = true;
	}

	function authBtnClick()
	{
		if (!canDoAnything)
			return;

		canDoAnything = false;
		FlxG.sound.play('ui/ui_select'.makePath(audio));
		GamejoltAPI.login(usernameInput.text, usertokenInput.text, onAuthThingy);
	}

	function leaveBtnClick()
	{
		if (!canDoAnything)
			return;

		canDoAnything = false;
		FlxG.sound.play('ui/ui_select'.makePath(audio));
		FlxG.switchState(() -> new MainMenuState());
	}

	function onAuthThingy(authed:Bool)
	{
		if (authed)
		{
			topText.text = 'GAMEJOLT LOGIN MENU\nLOGGED IN!';
			FlxG.sound.play('gamejolt/gamejolt_loggedIn'.makePath(audio));
		}
		else
		{
			topText.text = 'GAMEJOLT LOGIN MENU\nCould not log in...';
			FlxG.sound.play('gamejolt/gamejolt_loginFAIL'.makePath(audio));
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
