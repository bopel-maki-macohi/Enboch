package game;

import flixel.math.FlxMath;
import flixel.util.FlxStringUtil;
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
			text += 'MOVEMENT TIME: ${game?.charAITmr.time}s\n';
			text += 'TOTAL PAY: $' + '${FlxStringUtil.formatMoney(Paycheck.totalPay, false, true)}\n';
			text += 'ITEM SPAM: ${game?.itemSpam}\n';
			text += 'DAYCYCLE TIMER PROGRESS: ${FlxMath.roundDecimal(game?.daycycleTmr?.progress * 100, 2)}\n';
			text += 'PAY: $' + '${FlxStringUtil.formatMoney(100 * game?.payPercentage, false, true)}\n';
		}
	}
}
