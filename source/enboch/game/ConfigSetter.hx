package enboch.game;

import enboch.util.api.trophies.Trophies;

class ConfigSetter
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
		}
	}
}
