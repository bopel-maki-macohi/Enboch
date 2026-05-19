package enboch.util.video;

import enboch.data.VideoSettings;

interface IVideo<T>
{
	public var video:T;

	public var settings:VideoSettings;

	public function startVideo():Void;

	public function pauseVideo():Void;
	public function resumeVideo():Void;
	public function restartVideo():Void;

	public function finishVideo():Void;
}
