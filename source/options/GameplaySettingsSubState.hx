package options;

#if discord_rpc
import Discord.DiscordClient;
#end
import flixel.FlxSubState;

class GameplaySettingsSubState extends BaseOptionsMenu {
	public function new() {
		rpcTitle = 'Gameplay Settings';

		var option:Option = new Option('Controller Mode', 'controllerMode', 'bool', false);
		addOption(option);

		var option:Option = new Option('Downscroll', 'downScroll', 'bool', false);
		addOption(option);

		var option:Option = new Option('Time Bar:', 'timeBarType', 'string', 'Disabled', ['Time Left', 'Time Elapsed', 'Disabled']);
		addOption(option);

		var option:Option = new Option('Safe Frames', 'safeFrames', 'float', 10);
		option.scrollSpeed = 5;
		option.minValue = 2;
		option.maxValue = 10;
		option.changeValue = 0.1;
		addOption(option);

		super();
	}
}