package options;

#if discord_rpc
import Discord.DiscordClient;
#end
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.addons.display.FlxBackdrop;
import flixel.FlxCamera;
import Controls;
import BarrelDistortionShader.BarrelEffect;	
import flixel.util.FlxTimer;

#if !flash 
import flixel.addons.display.FlxRuntimeShader;
import openfl.filters.ShaderFilter;
#end

class OptionsState extends MusicBeatState {
	var options:Array<String> = ['Controls', 'Graphics', 'Gameplay'];
	private var grpOptions:FlxTypedGroup<Alphabet>;
	private static var curSelected:Int = 0;
	private var camOther:FlxCamera;
	private var camGame:FlxCamera;

	var barrelDistortion:BarrelEffect = new BarrelEffect();
	function openSelectedSubstate(label:String) {
		switch(label) {
			case 'Controls':
				openSubState(new options.ControlsSubState());
			case 'Graphics':
				openSubState(new options.GraphicsSettingsSubState());
			case 'Gameplay':
				openSubState(new options.GameplaySettingsSubState());
		}
	}

	var selectorLeft:Alphabet;
	var optionText:Alphabet;
	var selectorRight:Alphabet;

	public static var canClick:Bool = true;

	override function create() {
		#if discord_rpc
		DiscordClient.changePresence("Options Menu", null);
		#end

		camGame = new FlxCamera();
		camOther = new FlxCamera();
		camOther.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camOther, false);
		FlxG.camera.scroll.x = -750;

		Conductor.changeBPM(102);		
		persistentUpdate = true;

		var background:CheckerboardStuffs = new CheckerboardStuffs(0, 0);
		FlxTween.tween(background, {x: -118}, (588.2352941176471 / 1000) * 8, {ease: FlxEase.linear, type: LOOPING});
		background.color = 0xFFFF7600;
		background.antialiasing = true;
		add(background);

		FlxTween.tween(FlxG.camera.scroll, {x: 0}, 1, {ease: FlxEase.quintOut});

		if(ClientPrefs.shaders) {
			barrelDistortion.barrelDistortion1 = -0.15;
			barrelDistortion.barrelDistortion2 = -0.15;
			camGame.setFilters([new ShaderFilter(barrelDistortion.shader)]);
			FlxG.camera.zoom = 0.95;
		}

		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuBG'));
		bg.antialiasing = true;
		bg.scrollFactor.set();
		bg.screenCenter();
		bg.alpha = 0.3;
		add(bg);

		var dots:FlxBackdrop = new FlxBackdrop(Paths.image('dots'), X);
		dots.scrollFactor.set();
		dots.updateHitbox();
		dots.alpha = 0.7;
		dots.velocity.set(30, 0);
		dots.screenCenter();
		dots.antialiasing = true;
	    add(dots);

		var barslol:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuStuff/options/optionsbars'));
		barslol.scrollFactor.set();
		barslol.updateHitbox();
		barslol.screenCenter();
		barslol.antialiasing = true;
		add(barslol);

		grpOptions = new FlxTypedGroup<Alphabet>();
		add(grpOptions);

		for (i in 0...options.length) {
			optionText = new Alphabet(0, 0, options[i], true, false);
			optionText.screenCenter();
			optionText.y += (100 * (i - (options.length / 2))) + 50;
			grpOptions.add(optionText);
		}

		selectorLeft = new Alphabet(0, 0, '>', true, false);
		add(selectorLeft);
		selectorRight = new Alphabet(0, 0, '<', true, false);
		add(selectorRight);

		var eventThing:FlxSprite = new FlxSprite(0, 610).loadGraphic(Paths.image('eventThing'));
		eventThing.updateHitbox();
		eventThing.color = 0xFF000000;
		eventThing.cameras = [camOther];
		eventThing.antialiasing = true;
		add(eventThing);

		var eventThing2:FlxSprite = new FlxSprite().loadGraphic(Paths.image('eventThing'));
		eventThing2.updateHitbox();
		eventThing2.flipY = true;
		eventThing2.color = 0xFF000000;
		eventThing2.cameras = [camOther];
		eventThing2.antialiasing = true;
		add(eventThing2);

		changeSelection();
		ClientPrefs.saveSettings();

		super.create();
	}

	override function closeSubState() {
		super.closeSubState();
		ClientPrefs.saveSettings();
	}

	override function update(elapsed:Float) {
		super.update(elapsed);

		if (FlxG.sound.music != null) Conductor.songPosition = FlxG.sound.music.time;

    	if(canClick) {
			if (controls.UI_UP_P) 
				changeSelection(-1);

			if (controls.UI_DOWN_P) 
				changeSelection(1);

			if (CustomFadeTransition.canControl) {
				if (controls.BACK) {
					FlxG.sound.play(Paths.sound('cancelMenu'));
					MusicBeatState.switchState(new TitleState());
					FlxTween.tween(FlxG.camera.scroll, {x: -750}, 1, {ease: FlxEase.quintIn});
				}

				if (controls.ACCEPT) {
					canClick = false;
					openSelectedSubstate(options[curSelected]);
					for (item in grpOptions.members) {
						item.visible = false;
						selectorLeft.visible = false;
						selectorRight.visible = false;
					}
				} else {
					for (item in grpOptions.members) {
						item.visible = true;
						selectorLeft.visible = true;
						selectorRight.visible = true;
					}
				}
			}
	    }
	}
	
	function changeSelection(change:Int = 0) {
		curSelected += change;
		if (curSelected < 0) curSelected = options.length - 1;
		if (curSelected >= options.length) curSelected = 0;

		var bullShit:Int = 0;

		for (item in grpOptions.members) {
			item.targetY = bullShit - curSelected;
			bullShit++;

			if (item.targetY == 0) {
				selectorLeft.x = item.x - 63;
				selectorLeft.y = item.y;
				selectorRight.x = item.x + item.width + 15;
				selectorRight.y = item.y;
			}
		}
		FlxG.sound.play(Paths.sound('scrollMenu'));
	}
}