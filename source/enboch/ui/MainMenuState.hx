package enboch.ui;

import enboch.ui.objects.MainMenuButton;
import enboch.utilShitsie.Define;
import enboch.utilShitsie.EnboState;
import enboch.utilShitsie.api.GamejoltAPI;
import enboch.utilShitsie.controls.Controls;
import enboch.utilShitsie.video.*;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.addons.transition.TransitionData;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import lime.app.Application;

using StringTools;

class MainMenuState extends EnboState
{
	public var textGrp:FlxTypedSpriteGroup<MainMenuButton>;

	var entries:Array<String> = [
		'Levels',
		'Options',
		'',
		'Clear Save',
		((GamejoltAPI.authenticated) ? 'GJ Logout' : 'GJ Login'),
	];

	var camFollow:FlxObject;

	var curSelect:Int = 0;

	var version:FlxText = new FlxText(0, 0, 0,
		'ENBOCH v${Application.current.meta.get('version')}' + ((!Define.debug) ? '' : ' (${Main.gitBranch}:${Main.gitCommit})'), 16);

	override public function new(?TransIn:TransitionData, ?TransOut:TransitionData)
	{
		if (Define.debug)
		{
			if (TransIn == null)
				TransIn = EnboState.DEFAULT_TRANSITION;
			if (TransOut == null)
				TransOut = EnboState.DEFAULT_TRANSITION;
		}

		super(TransIn, TransOut);
	}

	var video:Video;

	override function create()
	{
		super.create();

		video = new Video({
			filePath: 'menuBG',
			shouldLoop: true,

			actuallyLoad: Paycheck.game.settings.menuBGVideo,
		});

		if (video.video != null)
			add(video);

		video.scrollFactor.set();

		#if web
		FlxG.camera.bgColor.alpha = 0;
		#end

		video.alpha = 0;

		canSelect = false;
		FlxTween.tween(video, {alpha: 1}, 1 + entries.length * .1, {
			ease: FlxEase.sineInOut,
			onComplete: t ->
			{
				canSelect = true;
			}
		});

		add(textGrp = new FlxTypedSpriteGroup<MainMenuButton>());

		var logo = new MainMenuButton('logo');
		logo.ID = -2;

		logo.screenCenter(X);
		var oldX = logo.x;
		logo.x = -logo.width * 2;
		FlxTween.tween(logo, {x: oldX}, 1, {
			ease: FlxEase.sineInOut,
		});

		textGrp.add(logo);

		for (i => entry in entries)
		{
			if (entry == '' || entry == null)
				continue;

			var newText = new MainMenuButton(entry);
			newText.ID = i;

			newText.screenCenter(X);
			var oldX = newText.x;
			newText.x = -newText.width * 2;
			FlxTween.tween(newText, {x: oldX}, 1, {
				ease: FlxEase.sineInOut,
				startDelay: i * .1,
			});

			textGrp.add(newText);
		}

		add(camFollow = new FlxObject(640));
		FlxG.camera.follow(camFollow, LOCKON, 0.1);

		version.y = FlxG.height - version.height;
		version.scrollFactor.set();
		add(version);
		version.alpha = 0;

		if (video.video != null)
			version.blend = SUBTRACT;

		FlxTween.tween(version, {alpha: 1}, 1, {
			ease: FlxEase.sineInOut,
		});

		changeSelect(0);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		for (text in textGrp.members)
		{
			if (canSelect)
				text.screenCenter(X);

			text.y = text.ID * 128;
			text.setColorTransform();

			if (curSelect == text.ID)
			{
				camFollow.y = text.y;
				text.setColorTransform(1.5, 1.5);
			}
		}

		if (Controls.ui_up.justPressed && canSelect)
			changeSelect(-1);
		if (Controls.ui_down.justPressed && canSelect)
			changeSelect(1);
		if (Controls.accept.justPressed && canSelect)
			selectThingy();
	}

	function changeSelect(selection:Int)
	{
		curSelect += selection;

		if (entries[curSelect] == null || entries[curSelect] == '')
		{
			if (selection < 0)
				curSelect--;
			if (selection > 0)
				curSelect++;
		}

		if (curSelect < 0)
			curSelect = entries.length - 1;

		if (curSelect > entries.length - 1)
			curSelect = 0;

		for (thing in textGrp)
		{
			var ID = thing.ID + 1;

			// trace('thing${ID} : ${1 -Math.abs(ID - (curSelect + 1)) / 1}');
		}

		FlxG.sound.play('ui/ui_scroll'.makePath(audio));
	}

	var canSelect:Bool = true;

	function selectThingy()
	{
		if (!canSelect)
			return;

		var selection = entries[curSelect];

		FlxG.sound.play('ui/ui_select'.makePath(audio));
		switch (selection.toLowerCase())
		{
			case 'levels', 'play', 'options':
				canSelect = false;
				for (thing in textGrp)
				{
					FlxTween.tween(thing, {x: FlxG.width + thing.width}, 1, {
						startDelay: thing.ID * .1,
						ease: FlxEase.sineInOut,
					});
				}

				FlxTween.tween(version, {alpha: 0}, 1, {
					ease: FlxEase.sineInOut,
				});

				FlxTween.tween(video, {alpha: 0}, 1 + entries.length * .1, {
					ease: FlxEase.sineInOut,
					onComplete: t ->

					{
						switch (selection.toLowerCase())
						{
							case 'options':
								FlxG.switchState(() -> new OptionsMenuState());

							default:
								FlxG.switchState(() -> new LevelSelectMenuState());
						}
					}
				});

			case 'clear save': Paycheck.clear();

			case 'gj login': FlxG.switchState(() -> new GamejoltLoginState());

			case 'gj logout':
				transOut = null;

				FlxG.sound.play('gamejolt/gamejolt_logout'.makePath(audio));
				GamejoltAPI.logout(() ->
				{
					FlxG.resetState();
				});
		}
	}
}
