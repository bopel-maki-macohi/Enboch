package;

import utilShitsie.trophies.TrophyToastHolder;
import ui.GamejoltLoginState;
import ui.MainMenuState;
import ui.debug.TrophyTesting;
import flixel.util.typeLimit.NextState.InitialState;
import macroShit.GitShit;
import flixel.FlxGame;
import openfl.display.Sprite;

class Main extends Sprite
{
	public static var gitBranch:String = GitShit.getGitBranch();
	public static var gitCommit:String = GitShit.getGitCommit();

	public static var trophyToast:TrophyToastHolder;

	public function new()
	{
		super();

		Paycheck.load();

		trace('Git Branch: $gitBranch');
		trace('Git Commit: $gitCommit');

		addChild(new InitState(getInitalState()));

		addChild(trophyToast = new TrophyToastHolder());
	}

	function getInitalState():InitialState
	{
		#if DIE
		return DeadState;
		#end

		#if TROPHY_TESTING
		return TrophyTesting;
		#end

		if (Paycheck.game.firstTime || #if GD_LOGIN true #else false #end)
			return GamejoltLoginState;

		return MainMenuState;
	}
}
