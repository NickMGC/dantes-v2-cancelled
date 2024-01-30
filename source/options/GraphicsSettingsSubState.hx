package options;

#if discord_rpc
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.FlxSubState;

class GraphicsSettingsSubState extends BaseOptionsMenu {
	public function new() {
		rpcTitle = 'Changing Graphics Settings';

		var option:Option = new Option('FPS Counter', 'showFPS', 'bool', false);
		addOption(option);
		option.onChange = onChangeFPSCounter;

		var option:Option = new Option('Shaders', 'shaders', 'bool', true);
		addOption(option);

		var option:Option = new Option('Potato Mode', 'potatoMode', 'bool', false);
		addOption(option);

		var option:Option = new Option('Framerate', 'framerate', 'int', 60);
		addOption(option);

		option.minValue = 60;
		option.maxValue = FlxG.stage.window.displayMode.refreshRate;
		option.displayFormat = '%v FPS';
		option.onChange = onChangeFramerate;

		super();
	}

	function onChangeFPSCounter()
		if(Main.fpsVar != null) Main.fpsVar.visible = ClientPrefs.showFPS;

	function onChangeFramerate() {
		if(ClientPrefs.framerate > FlxG.drawFramerate) {
			FlxG.updateFramerate = ClientPrefs.framerate;
			FlxG.drawFramerate = ClientPrefs.framerate;
		} else {
			FlxG.drawFramerate = ClientPrefs.framerate;
			FlxG.updateFramerate = ClientPrefs.framerate;
		}
	}
}