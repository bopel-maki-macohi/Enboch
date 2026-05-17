package;

import game.PlayStateConstants.*;
import game.ConfigSetter;
import game.StateManager;
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

	var charSprShader:ThresholdShader = null;
	var charSprShaderTween:FlxTween;

	public var config_using_cAM_ro:Bool = true;

	public var config_cAM_ro_max_max:Int = 10;
	public var config_cAM_ro_max_min:Int = 0;

	public var stateChangeChances:Array<Array<Int>> = [];

	public var config_rng_minNumber:Int = 0;
	public var config_rng_maxNumber:Int = 10;

	public var config_trophy_fullpay:Trophy;

	public var config_states:Int = 4;

	public static var config_trophies_daycycle:Map<Int, Trophy> = [];

	function getNumberRelativeToRNGListMaxOutput(number:Int)
		return Math.round(number * (config_rng_maxNumber / 10));

	function getNumberRelativeToConfigStates(number:Int)
		return Math.round(number * (config_states / 4));

	override public function new()
	{
		super();

		ConfigSetter.setConfig(this, character);

		for (i in 0...config_states - 1)
			stateChangeChances.push([]);

		var existingNumbers:Array<Int> = [];

		for (i in 0...config_rng_maxNumber + 1)
		{
			if (i % getNumberRelativeToConfigStates(3) == 0)
			{
				var o = 0;

				for (thing in stateChangeChances)
				{
					if (i + o < config_rng_maxNumber + 1)
						thing.push(i + o);
					o++;
				}
			}
		}

		for (i => thing in stateChangeChances)
			trace('$character-phase$i : $thing');

		config_states = Math.round(Math.max(Math.min(config_states, STATES_MAX), STATES_MIN));

		GamePhaseSprite.loadCharacterAssets(character, config_states);
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

		charAITmr.start(TIMER_CHAR_AI_DEFAULT_LENGTH + FlxG.random.int(0, rng_cAM_ro_max), charAIMethod, 0);

		daycycleTmr.start(TIMER_DAYCYCLE_LENGTH, t ->
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

		if (itemSpam >= ITEM_SPAM_MAX)
		{
			rng_deathWaitSeconds = 0;
			charSpr.state = config_states - 1;
		}
		else
		{
			var jumpChanceNumber:Int = getNumberRelativeToRNGListMaxOutput(10);

			if (config_states == 3)
				jumpChanceNumber = getNumberRelativeToRNGListMaxOutput(5);

			for (i => thing in stateChangeChances)
			{
				if (!thing.contains(rng_stateChangeChance))
					continue;

				charSpr.state = StateManager.parseMovementCode('${config_states}${i}${charSpr.state}', charSpr.state,
					(rng_stateJumpChance >= jumpChanceNumber));
			}
		}

		if (charSpr.state >= config_states - 1)
			deathTmr.start(TIMER_DEATH_DEFAULT_LENGTH + rng_deathWaitSeconds, death);

		regenRNG();
		t.reset(TIMER_CHAR_AI_DEFAULT_LENGTH + FlxG.random.int(0, rng_cAM_ro_max));

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

		payPercentage = ((config_states - charSpr.state) / config_states) - ((itemSpam / ITEM_SPAM_MAX) / 2);

		if (Define.BOTPLAY)
			payPercentage = 0.0;

		if ((Define.BOTPLAY && charSpr.state > 0) || FlxG.mouse.justPressed)
			useItem();

		if (Controls.leave.justPressed && charSpr.state < config_states - 1)
			FlxG.switchState(() -> new MainMenuState());
	}

	function useItem()
	{
		if (!Define.BOTPLAY)
			itemSpam++;

		if (charSpr.state >= config_states - 1 || charSpr.state <= 0)
			return;

		itemSpam = 0;

		var lowerChance:Bool = StateManager.parseLowerItemUseChance(config_states, charSpr.state);

		if (rng_itemUseChance < getNumberRelativeToRNGListMaxOutput(getNumberRelativeToConfigStates(5))
			&& lowerChance
			|| rng_itemUseChance < getNumberRelativeToRNGListMaxOutput(8))
		{
			regenRNG();
			return;
		}

		charSpr.state -= 1;
		rng_stateChangeChance = -1;
		charAIMethod(charAITmr);
	}
}
