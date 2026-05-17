package utilShitsie.controls;

class Controls
{
	public static var keys:Array<Control> = [];

	public static var accept:Control = new Control('accept', [ENTER]).loadFromSave();
	public static var leave:Control = new Control('leave', [ESCAPE, BACKSPACE]).loadFromSave();

	public static var screenshot:Control = new Control('screenshot', [F3]).loadFromSave();

	public static var ui/ui_down:Control = new Control('ui/ui_down', [S, DOWN]).loadFromSave();
	public static var ui/ui_up:Control = new Control('ui/ui_up', [W, UP]).loadFromSave();
}
