package enboch.utilShitsie.video;

typedef VideoSettings =
{
	filePath:String,

	?shouldLoop:Bool,
	?actuallyLoad:Bool,
	
	?onPlay:Void->Void,
	?onPlayError:String->Void,

	?web_back:Bool,
}
