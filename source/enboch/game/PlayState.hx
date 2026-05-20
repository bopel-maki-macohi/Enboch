package enboch.game;

import enboch.ui.LevelSelectMenuState;
import enboch.util.*;
import enboch.util.api.trophies.Trophy;
import enboch.util.controls.Controls;
import enboch.util.shader.ScreenGlitchShader;
import enboch.util.shader.ThresholdShader;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.math.FlxMath;
import flixel.sound.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import openfl.filters.ShaderFilter;

@:build(enboch.util.macro.RNGListField.generateList([
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

	public var itemSpr:GamePhaseSprite;

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
	public var payTmr:FlxTimer = new FlxTimer();
	public var deathTmr:FlxTimer = new FlxTimer();
	public var daycycleTmr:FlxTimer = new FlxTimer();

	public var payPercentage = 1.0;

	public var itemSpam:Int = 0;

	public var charSprShader:ThresholdShader = null;
	public var charSprShaderTween:FlxTween;

	public var stateChangeChances:Array<Array<Int>> = [];

	public var safetyHeart:SafetyHeart;
	public var payText:FlxText;

	public var basePay:Int = 9001;

	public var config_using_cAM_ro:Bool = true;

	public var config_cAM_ro_max_max:Int = 10;
	public var config_cAM_ro_max_min:Int = 0;

	public var config_rng_minNumber:Int = 0;
	public var config_rng_maxNumber:Int = 10;

	public var config_trophy_fullpay:Trophy;

	public var config_states:Int = 4;
	public var config_startingState:Int = 0;

	public var config_movementSounds:Array<FlxSound> = [];

	public static var config_trophies_daycycle:Map<Int, Trophy> = [];

	function getNumberRelativeToRNGListMaxOutput(number:Int)
		return Math.round(number * (config_rng_maxNumber / 10));

	function getNumberRelativeToConfigStates(number:Int)
		return Math.round(number * (config_states / 4));

	override public function new()
	{
		super();

		GameConfigSetter.setConfig(this, character);
		basePay = GameConfigSetter.getBasePay(character);

		for (i in 0...config_states - 1)
			stateChangeChances.push([]);

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

			((DEBUG_TEXT) ? new GameDebugText(this) : null),
			safetyHeart = new SafetyHeart(),
			payText = new FlxText(0, 0, 0, 'SWAG SHIT MONEY MONEY MOTHER FUCKER', 16),
		]);

		safetyHeart.x = safetyHeart.scale.x;
		safetyHeart.y = FlxG.height - safetyHeart.height - safetyHeart.scale.y;

		payText.setBorderStyle(OUTLINE, FlxColor.BLACK, 2);
		payText.x = safetyHeart.x;
		payText.y = safetyHeart.y - payText.height;

		charSpr.shader = charSprShader = new ThresholdShader((!Paycheck.game.settings.characterPulse) ? 1 : 0);

		charSpr.onStateChange.add(function()
		{
			for (sound in config_movementSounds)
			{
				if (sound == null)
				{
					config_movementSounds.remove(sound);
					continue;
				}

				sound.play();
			}

			itemSpr.state = charSpr.state;

			charSpr.screenCenter();
		});
		charSpr.onStateChange.add(characterPulse);

		itemSpr.onStateChange.add(function()
		{
			itemSpr.screenCenter();
		});

		charSpr.state = config_startingState;

		regenRNG();

		charAITmr.start(TIMER_CHAR_AI_DEFAULT_LENGTH + FlxG.random.int(0, rng_cAM_ro_max), charAIMethod, 0);
		payTmr.start(charAITmr.time * 2, payMethod, 0);

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

				charSpr.state = GameStateManager.parseMovementCode('${config_states}${i}${charSpr.state}', charSpr.state,
					(rng_stateJumpChance >= jumpChanceNumber));
			}
		}

		if (charSpr.state >= config_states - 1)
			deathTmr.start(TIMER_DEATH_DEFAULT_LENGTH + rng_deathWaitSeconds, death);

		regenRNG();
	}

	function payMethod(t:FlxTimer)
	{
		t.reset(charAITmr.time * 2);

		if (deathTmr.active)
			return;

		if (payPercentage == 1 && config_trophy_fullpay != null)
			config_trophy_fullpay.unlock();

		Paycheck.getPayed(basePay, payPercentage);
	}

	function characterPulse()
	{
		if (!Paycheck.game.settings.characterPulse)
			return;

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

		safetyHeart.percent = ((config_states - charSpr.state) / config_states);
		payText.text = 'Payment: $' + '${Math.round(basePay * payPercentage)} (Payed in ${FlxMath.roundDecimal(payTmr.timeLeft, 2)}s)';

		if (BOTPLAY)
			payPercentage = 0.0;

		if ((BOTPLAY && charSpr.state > 0) || FlxG.mouse.justPressed)
			useItem();

		if (Controls.leave.justPressed && charSpr.state < config_states - 1)
			FlxG.switchState(() -> new LevelSelectMenuState());
	}

	function useItem()
	{
		if (!BOTPLAY)
			itemSpam++;

		if (charSpr.state >= config_states - 1 || charSpr.state <= 0)
			return;

		itemSpam = 0;

		var lowerChance:Bool = GameStateManager.parseLowerItemUseChance(config_states, charSpr.state);

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
