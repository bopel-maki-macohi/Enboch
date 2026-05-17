import utilShitsie.EnboState;
import flixel.addons.transition.FlxTransitionableState;
import utilShitsie.Define;
import flixel.system.frontEnds.LogFrontEnd;
import flixel.FlxG;
import utilShitsie.ScreenshotPlugin;
import utilShitsie.api.GamejoltAPI;
import flixel.util.typeLimit.NextState.InitialState;
import flixel.FlxGame;
import openfl.events.Event;

using StringTools;

class InitState extends FlxGame
{
	override public function new(startingState:InitialState)
	{
		super(0, 0, startingState);
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
			}
		#end

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
