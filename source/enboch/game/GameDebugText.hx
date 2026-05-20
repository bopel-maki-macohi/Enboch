package enboch.game;

import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxStringUtil;

class GameDebugText extends FlxText
{
	var game:PlayState;

	public function new(game:PlayState)
	{
		super(0, 0, 0, '', 16);

		this.game = game;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		if (BOTPLAY)
		{
			text = 'BOTPLAY\n';
		}
		else
		{
			text = '';
			text += 'Git: ${Main.gitBranch}:${Main.gitCommit}\n\n';

			text += 'RNG LIST: ${game?.rngList?.join('-')}\n\n';

			text += 'STATE: ${game?.charSpr?.state}\n';
			text += 'STATES: ${game?.config_states}\n';
			text += 'DEATH STATE: ${game?.config_states - 1}\n\n';

			text += 'MOVEMENT TIME: ${game?.charAITmr?.time}s\n';
			text += 'MOVEMENT TIME LEFT: ${FlxMath.roundDecimal(game?.charAITmr?.timeLeft, 2)}s\n\n';

			text += 'TOTAL PAY: $' + '${FlxStringUtil.formatMoney(Paycheck.totalPay, false, true)}\n';
			text += 'ITEM SPAM: ${game?.itemSpam}\n';
			text += 'PAY: $' + '${FlxStringUtil.formatMoney(GameConfigSetter.getBasePay(PlayState.character) * game?.payPercentage, false, true)}\n\n';

			text += 'DAYCYCLE TIMER PROGRESS: ${FlxMath.roundDecimal(game?.daycycleTmr?.progress * 100, 2)}%\n';
		}
	}
}
