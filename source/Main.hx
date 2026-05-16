package;

import utilShitsie.Define;
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

	public function new()
	{
		super();

		Paycheck.load();

		trace('Git Branch: $gitBranch');
		trace('Git Commit: $gitCommit');

		addChild(new InitState(getInitalState()));
	}

	function getInitalState():InitialState
	{
		if (Define.DIE)
			return DeadState;

		if (Define.TROPHY_TESTING)
			return TrophyTesting;

		if (Paycheck.game.firstTime || Define.GJ_LOGIN)
			return GamejoltLoginState;

		return MainMenuState;
	}
}
