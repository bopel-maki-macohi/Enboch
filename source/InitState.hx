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
