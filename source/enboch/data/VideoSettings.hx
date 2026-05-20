package enboch.data;

typedef VideoSettings =
{
	filePath:String,

	?shouldLoop:Bool,
	?actuallyLoad:Bool,
	?killOnEnd:Bool,
	?instaStart:Bool,
	?persist:Bool,

	?playbackRate:Float,
}
