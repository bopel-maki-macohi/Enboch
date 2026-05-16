import flixel.system.frontEnds.LogFrontEnd;
import flixel.FlxG;
import utilShitsie.ScreenshotPlugin;
import utilShitsie.api.GamejoltAPI;
import flixel.util.typeLimit.NextState.InitialState;
import flixel.FlxGame;
import openfl.events.Event;

class InitState extends FlxGame
{
	override public function new(startingState:InitialState)
	{
		super(0, 0, startingState);
		removeEventListener(Event.ADDED_TO_STAGE, create);

		FlxG.mouse.visible = false;

		ScreenshotPlugin.init();

		@:privateAccess
		FlxG.log._standardTraceFunction = null;

		GamejoltAPI.init(authed ->
		{
			trace('Authed Status: $authed');

			@:privateAccess
			FlxG.log._standardTraceFunction = haxe.Log.trace;

			addEventListener(Event.ADDED_TO_STAGE, create);
			create(null);
		});
	}
}
