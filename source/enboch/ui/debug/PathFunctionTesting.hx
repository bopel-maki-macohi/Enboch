package enboch.ui.debug;

import enboch.util.EnboState;

class PathFunctionTesting extends EnboState
{
	override function create()
	{
		super.create();

		trace(AssetLibrary.pathExists('content/characters/drowned'));
		trace(AssetLibrary.readDirectory('content/audio/'));
	}
}
