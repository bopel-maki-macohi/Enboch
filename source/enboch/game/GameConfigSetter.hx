package enboch.game;

import enboch.util.api.trophies.Trophies;
import flixel.sound.FlxSound;

using haxe.io.Path;

class GameConfigSetter
{
	public static function setConfig(game:PlayState, character:String)
	{
		switch (character)
		{
			case 'drowned':
				game.config_using_cAM_ro = false;
				game.config_trophy_fullpay = Trophies.FULLPAY_DROWNED;
			case 'skeleton':
				game.config_cAM_ro_max_max = 3;
				game.config_trophy_fullpay = Trophies.FULLPAY_SKELETON;
			case 'guardian':
				game.config_rng_minNumber = -2;

				game.config_cAM_ro_max_min = -2;
				game.config_cAM_ro_max_max = 2;

				game.config_rng_maxNumber = 15;

				game.config_states = 3;

				game.config_trophy_fullpay = Trophies.FULLPAY_GUARDIAN;

			case 'husk':
				game.config_states = 5;
				game.config_cAM_ro_max_max = 4;

				game.config_startingState = 2;

				game.config_trophy_fullpay = Trophies.FULLPAY_HUSK;

			case 'phantom':
				game.config_rng_minNumber = -4; // 1s min
				game.config_rng_maxNumber = -2; // 3s max

				game.config_cAM_ro_max_min = 1; // 2s random min
				game.config_cAM_ro_max_max = 3; // 6s random max

				for (s in 'movement/phantom'.makePath(audio).withoutExtension().readDirectoryRecursive())
				{
					var sound = new FlxSound().loadEmbedded(s);
					game.config_movementSounds.push(sound);
				}
		}
	}

	public static function getBasePay(character:String):Int
	{
		switch (character.toLowerCase())
		{
			case 'drowned': return 50;
			case 'skeleton': return 75;
			case 'guardian': return 100;
			case 'husk': return 200;
			case 'phantom': return 175;
		}

		return 100;
	}
}
