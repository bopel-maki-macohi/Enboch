package enboch.game;

import enboch.util.api.trophies.Trophies;

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
			case 'phantom':
		}
	}

	public static function getBasePay(character:String):Int
	{
		switch (character)
		{
			case 'drowned': return 50;
			case 'skeleton': return 75;
			case 'guardian': return 100;
			// case 'husk': return 100;
			// case 'phantom': return 100;
		}

		return 100;
	}
}
