package enboch.data;

typedef VideoSettings =
{
	filePath:String,

	?shouldLoop:Bool,
	?actuallyLoad:Bool,
	?killOnEnd:Bool,

	?onPlay:Void->Void,
	?onPlayError:String->Void,

	?web_back:Bool,
}
