package game;

import utilShitsie.Define;
import flixel.text.FlxText;

class DebugGameText extends FlxText
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
		if (Define.BOTPLAY)
		{
			text = 'BOTPLAY\n';
		}
		else
		{
			text = 'STATE: ${game?.charSpr?.state}\n';
			text += 'RNG LIST: ${game?.rngList?.join('-')}\n';
			text += 'MOVEMENT TIME: ${game?.charAITmr.time}\n';
			text += 'TOTAL PAY: ${Paycheck.totalPay}\n';
			text += 'ITEM SPAM: ${game?.itemSpam}\n';
			text += 'DAYCYCLE TIMER PROGRESS: ${game?.daycycleTmr?.progress}\n';
			text += 'PAY PERCENT: ${100 * game?.payPercentage}\n';
		}
	}
}
