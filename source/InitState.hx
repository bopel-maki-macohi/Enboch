import enboch.ui.*;
import enboch.ui.debug.*;
import enboch.utilShitsie.*;
import enboch.utilShitsie.api.GamejoltAPI;
import enboch.utilShitsie.api.trophies.Trophies;
import enboch.utilShitsie.controls.Controls;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.addons.transition.FlxTransitionableState;
import flixel.util.typeLimit.NextState.InitialState;
import openfl.events.Event;

using StringTools;

class InitState extends FlxGame
{
	public static function getInitalState():InitialState
	{
		if ((Define.hxvlc || Define.FORCE_VCS) && !VideoCacheState.initalized)
			return VideoCacheState;

		if (Define.DIE)
			return DeadState;

		if (Define.TROPHY_TESTING)
			return TrophyTesting;

		if (Define.GAME != null)
		{
			PlayState.character = Define.GAME;

			return PlayState;
		}

		if (Define.PATH_FUNCTION_TESTING)
			return PathFunctionTesting;

		if (Paycheck.game.firstTime || Define.GJ_LOGIN)
			return GamejoltLoginState;

		return MainMenuState;
	}

	override public function new()
	{
		#if js
		// trace(document.URL);

		if (document.URL.contains('gjapi_username='))
			if (document.URL.contains('gjapi_token='))
			{
				var wantedPieces = document.URL.split('?')[1].split('&');

				// trace(wantedPieces[0]); // gjapi_username
				// trace(wantedPieces[1]); // gjapi_token

				var gjapi_username = wantedPieces[0].split('=')[1];
				var gjapi_token = wantedPieces[1].split('=')[1];

				// trace(gjapi_username); // gjapi_username
				// trace(gjapi_token); // gjapi_token

				Paycheck.game.gj_username = gjapi_username;
				Paycheck.game.gj_usertoken = gjapi_token;
				Paycheck.game.firstTime = false;
			}
		#end

		super(0, 0, getInitalState());
		removeEventListener(Event.ADDED_TO_STAGE, create);

		FlxG.mouse.visible = false;

		ScreenshotPlugin.init();

		if (!Define.debug)
		{
			@:privateAccess
			FlxG.log._standardTraceFunction = (v, ?i) -> {};
		}

		@:privateAccess
		FlxG.sound.loadSavedPrefs();

		PlayState.config_trophies_daycycle = [
			1 => Trophies.DAYCYCLE_ONE,
			3 => Trophies.DAYCYCLE_THREE,
			9 => Trophies.DAYCYCLE_NINE,
			27 => Trophies.DAYCYCLE_TWENTY_SEVEN,
			28 => null,
		];

		for (control in Controls.keys)
			control.loadFromSave();

		GamejoltAPI.init(authed ->
		{
			trace('Authed Status: $authed');

			addEventListener(Event.ADDED_TO_STAGE, create);
			create(null);
		});
	}

	override function create(_:Event)
	{
		super.create(_);

		FlxTransitionableState.defaultTransIn = EnboState.DEFAULT_TRANSITION;
		FlxTransitionableState.defaultTransOut = EnboState.DEFAULT_TRANSITION;
	}
}
