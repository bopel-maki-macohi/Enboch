package utilShitsie.controls;

class Controls
{
	public static var keys:Array<Control> = [];

	public static var accept:Control = new Control('accept', [ENTER]).loadFromSave();

	public static var screenshot:Control = new Control('screenshot', [F3]).loadFromSave();

	public static var ui_down:Control = new Control('ui_down', [S, DOWN]).loadFromSave();
	public static var ui_up:Control = new Control('ui_up', [W, UP]).loadFromSave();
}
