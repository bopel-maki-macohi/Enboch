package utilShitsie.controls;

class Controls
{
	public static var accept:Control = new Control('accept', [ENTER]).loadFromSave();

	public static var screenshot:Control = new Control('screenshot', [F3]).loadFromSave();

	public static var keys:Array<Control> = [accept, screenshot];
}
