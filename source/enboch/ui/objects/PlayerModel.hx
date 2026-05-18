package enboch.ui.objects;

import flixel3d.Flx3DModel;

class PlayerModel extends Flx3DModel
{
	override public function new()
	{
		super();

		loadMeshes('player'.makePath(model));
	}
}
