package;

import utilShitsie.api.trophies.Trophy;
import game.DebugGameText;
import game.GamePhaseSprite;
import shaderHell.ThresholdShader;
import utilShitsie.Define;
import utilShitsie.api.trophies.Trophies;
import ui.MainMenuState;
import utilShitsie.controls.Controls;
import utilShitsie.RNGUtil;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import utilShitsie.EnboState;
import flixel.util.FlxTimer;
import flixel.FlxG;

@:build(macroShit.RNGListField.generateList([
	'stateChangeChance',
	'deathWaitSeconds',
	'stateJumpChance',
	'itemUseChance',
	'cAM_ro_max', // Character AI Movement Random Offset Max
]))
class PlayState extends EnboState
{
	public static var character:String = 'drowned';

	public var charSpr:GamePhaseSprite;

	var itemSpr:GamePhaseSprite;

	public var rngList:Array<Int> = [];

	function regenRNG()
	{
		rngList = RNGUtil.generateRNGList(rngList_length, config_rng_minNumber, config_rng_maxNumber);

		this.rng_stateChangeChance = rngList[0];
		this.rng_deathWaitSeconds = rngList[1];
		this.rng_stateJumpChance = rngList[2];
		this.rng_itemUseChance = rngList[3];

		if (config_using_cAM_ro)
		{
			this.rng_cAM_ro_max = Math.round(Math.max(Math.min(rngList[4], config_cAM_ro_max_max), config_cAM_ro_max_min));
		}
	}

	public var charAITmr:FlxTimer = new FlxTimer();
	public var deathTmr:FlxTimer = new FlxTimer();

	public var daycycleTmr:FlxTimer = new FlxTimer();

	public var payPercentage = 1.0;

	public var itemSpam:Int = 0;
	public final itemSpamMax:Int = 200;

	var charSprShader:ThresholdShader = null;
	var charSprShaderTween:FlxTween;

	public var config_using_cAM_ro:Bool = true;

	public var config_cAM_ro_max_max:Int = 10;
	public var config_cAM_ro_max_min:Int = 0;

	public var config_stateChange_state1Chances:Array<Int> = [];
	public var config_stateChange_state2Chances:Array<Int> = [];
	public var config_stateChange_state3Chances:Array<Int> = [];

	public var config_rng_minNumber:Int = 0;
	public var config_rng_maxNumber:Int = 10;

	public var config_trophy_fullpay:Trophy;

	public static var config_trophies_daycycle:Map<Int, Trophy> = [
		1 => Trophies.DAYCYCLE_ONE,
		3 => Trophies.DAYCYCLE_THREE,
		9 => Trophies.DAYCYCLE_NINE,
		27 => Trophies.DAYCYCLE_TWENTY_SEVEN,
		28 => null,
	];

	override public function new()
	{
		super();

		switch (character)
		{
			case 'drowned':
				config_using_cAM_ro = false;
				config_trophy_fullpay = Trophies.FULLPAY_DROWNED;
			case 'skeleton':
				config_cAM_ro_max_max = 3;
				config_trophy_fullpay = Trophies.FULLPAY_SKELETON;
		}

		for (i in 0...config_rng_maxNumber + 1)
		{
			if (i % 3 == 0)
			{
				config_stateChange_state1Chances.push(i);

				if (i + 1 < config_rng_maxNumber + 1)
					config_stateChange_state2Chances.push(i + 1);
				if (i + 2 < config_rng_maxNumber + 1)
					config_stateChange_state3Chances.push(i + 2);
			}
		}

		trace(config_stateChange_state1Chances);
		trace(config_stateChange_state2Chances);
		trace(config_stateChange_state3Chances);
	}

	override public function create()
	{
		super.create();

		Paycheck.earned = 0;

		addMultiple([
			charSpr = new GamePhaseSprite(character, char),
			itemSpr = new GamePhaseSprite(character, item),

			((Define.DEBUG_TEXT) ? new DebugGameText(this) : null),
		]);

		charSpr.shader = charSprShader = new ThresholdShader(1);

		charSpr.onStateChange.add(function()
		{
			itemSpr.state = charSpr.state;

			charSpr.screenCenter();
		});
		charSpr.onStateChange.add(characterPulse);

		itemSpr.onStateChange.add(function()
		{
			itemSpr.screenCenter();
		});

		regenRNG();

		charAITmr.start(5 + FlxG.random.int(0, rng_cAM_ro_max), charAIMethod, 0);

		daycycleTmr.start(60 * 20, t ->
		{
			trace(t.elapsedLoops + ' day cycle(s)');

			if (config_trophies_daycycle.exists(t.elapsedLoops))
			{
				if (config_trophies_daycycle.get(t.elapsedLoops) == null)
					t.cancel();
				else
					config_trophies_daycycle.get(t.elapsedLoops).unlock();
			}
		}, 0);

		characterPulse();
	}

	function charAIMethod(t:FlxTimer)
	{
		if (t == null)
			return;

		if (itemSpam >= itemSpamMax)
		{
			rng_stateChangeChance = 2;
			rng_deathWaitSeconds = 0;
			charSpr.state = 3;
		}
		else
		{
			if (charSpr.state == 0 && config_stateChange_state1Chances.contains(rng_stateChangeChance))
				charSpr.state = (rng_stateJumpChance < 10) ? 1 : 2;
			else if (charSpr.state == 1 && config_stateChange_state2Chances.contains(rng_stateChangeChance))
				charSpr.state = (rng_stateJumpChance < 10) ? 2 : 1;
			else if (charSpr.state == 2 && config_stateChange_state3Chances.contains(rng_stateChangeChance))
				charSpr.state = 3; // ur dead lmao
		}

		if (charSpr.state >= 3)
			deathTmr.start(3 + rng_deathWaitSeconds, death);

		regenRNG();
		t.reset(5 + FlxG.random.int(0, rng_cAM_ro_max));

		if (!deathTmr.active && (t.elapsedLoops % 2 == 0))
		{
			if (payPercentage == 1 && config_trophy_fullpay != null)
				config_trophy_fullpay.unlock();

			Paycheck.getPayed(payPercentage);
		}
	}

	function characterPulse()
	{
		if (charSprShaderTween != null)
			charSprShaderTween.cancel();

		charSprShaderTween = FlxTween.num(1, 0, 2.5, {ease: FlxEase.quintOut}, v -> charSprShader.brightnessThreshold = v);
	}

	function death(t:FlxTimer)
	{
		charAITmr.cancel();
		charAITmr = null;

		transOut = null;

		trace('u dead');
		FlxG.switchState(() -> new DeadState());
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		payPercentage = ((4 - charSpr.state) / 4) - ((itemSpam / itemSpamMax) / 2);

		if (Define.BOTPLAY)
			payPercentage = 0.0;

		if ((Define.BOTPLAY && charSpr.state > 0) || FlxG.mouse.justPressed)
			useItem();

		if (Controls.leave.justPressed && charSpr.state < 3)
			FlxG.switchState(() -> new MainMenuState());
	}

	function useItem()
	{
		if (!Define.BOTPLAY)
			itemSpam++;

		if (charSpr.state >= 3 || charSpr.state <= 0)
			return;

		if (itemSpam > 0)
			itemSpam = 0;

		if (rng_itemUseChance < 5 && charSpr.state == 2 || rng_itemUseChance < 8)
		{
			regenRNG();
			return;
		}

		charSpr.state -= 1;
		rng_stateChangeChance = -1;
		charAIMethod(charAITmr);
	}
}
