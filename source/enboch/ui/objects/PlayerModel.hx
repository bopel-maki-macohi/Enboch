package enboch.ui.objects;

import flixel3d.FlxModel;

class PlayerModel extends FlxModel
{
	override public function new()
	{
		super();

		loadMeshes('player'.makePath(model));
	}
}
