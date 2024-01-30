package;
#if discord_rpc
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import lime.app.Application;
import openfl.Assets;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxMath;
import flixel.util.FlxColor;
import flixel.util.FlxGradient;
import flixel.util.FlxTimer;
#if cpp
import sys.FileSystem;
import sys.io.File;
#end

using StringTools;

class MainMenuState extends MusicBeatState {
	public static var psychEngineVersion:String = '0.5.2h'; //eww
	public static var curSelected:Int = 0;

	private var camGame:FlxCamera;

	var optionShit:Array<MainMenuButton> = [
		{x: 200, y: 100, scale: 4.2, name: 'storymode'},
		{x: 110, y: 280, scale: 2.2, name:  'freeplay'},
		{x: 440, y: 280, scale: 2.2, name:   'credits'},
		{x: 10,  y: 450, scale: 4,   name:   'options'},
	];

	var characters:Array<MainMenuCharacter> = [
	    {x: 840,  y: 170, image:    "dan"},
		{x: 974,  y: 431, image: "dantes"},
		{x: 974,  y: 346, image: "george"},
		{x: 0,    y: 0,   image:  "dagon"},
		{x: 1011, y: 409, image:    "tim"},
	];

	var menuItems:FlxTypedGroup<FlxSprite>;
	var background:CheckerboardStuffs;
	var curChar:MainMenuCharacter;
	var transGradient:FlxSprite;
	var dotsThing:FlxSprite;
	var barslol:FlxSprite;
	var char:FlxSprite;

	var canClick:Bool = true;

	override function create() {
		Paths.clearUnusedMemory();
		Paths.clearStoredMemory();

		#if discord_rpc
		DiscordClient.changePresence("In the Main Menu", null);
        #end

		FlxG.mouse.visible = true;

		camGame = new FlxCamera();
		FlxG.cameras.reset(camGame);
		FlxG.cameras.setDefaultDrawTarget(camGame, true);

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;
		persistentUpdate = persistentDraw = true;

		FlxG.camera.zoom = 4;
		FlxTween.tween(FlxG.camera, {zoom: 1}, 1.3, {ease: FlxEase.expoOut});

		background = new CheckerboardStuffs(-118, 0);
		background.antialiasing = true;
		FlxTween.tween(background, {y: -120, x: 0}, (588.2352941176471 / 1000) * 8, {ease: FlxEase.linear, type: LOOPING});
		background.color = 0xFFFF7600;
		add(background);

		dotsThing = new FlxSprite();
		dotsThing.loadGraphic(Paths.image("menuStuff/mainMenu/dots"));
		dotsThing.antialiasing = true;
		FlxTween.tween(dotsThing, {x: 75}, (588.2352941176471 / 1000) * 4, {ease: FlxEase.expoInOut, type: PINGPONG});
		add(dotsThing);

		var charIndex:Int = FlxG.random.int(0, 4);
		curChar = characters[charIndex];
		char = new FlxSprite(840, 170).loadGraphic(Paths.image('menuStuff/mainMenu/${curChar.image}'));
		char.antialiasing = true;
		add(char);

		if(charIndex == 0) FlxG.sound.play(Paths.sound('OHMYGOD'), 2).pitch = (1 + (Math.random() / 6));
		if(charIndex == 3) char.offset.set(200, 100);
		else char.offset.set(0,  0);

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		for (i in 0...optionShit.length) {
			var option:MainMenuButton = optionShit[i];
			var menuItem:FlxSprite = new FlxSprite(option.x, option.y);
			menuItem.frames = Paths.getSparrowAtlas('menuStuff/mainMenu/menu_' + option.name);
			menuItem.animation.addByPrefix('idle', option.name + " basic", 24);
			menuItem.animation.addByPrefix('selected', option.name + " white", 24);
			menuItem.animation.play('idle');
			menuItem.ID = i;
			menuItem.antialiasing = true;
			menuItem.setGraphicSize(Std.int(menuItem.height * option.scale));
			menuItem.updateHitbox();
			menuItems.add(menuItem);
		}

		transGradient = FlxGradient.createGradientFlxSprite(1280, 720, [0x665C00B2, 0x0]);
		transGradient.scrollFactor.set();
		add(transGradient);

		barslol = new FlxSprite().loadGraphic(Paths.image('menuStuff/mainMenu/barslol'));
		barslol.antialiasing = true;
		barslol.screenCenter();
		add(barslol);

		super.create();
	}

	override function update(elapsed:Float) {
		if (FlxG.sound.music != null) Conductor.songPosition = FlxG.sound.music.time;
		if (FlxG.sound.music.volume < 0.8) FlxG.sound.music.volume += 0.5 * FlxG.elapsed;

		#if hl
		if (FlxG.keys.justPressed.SPACE) FlxG.save.data.beatenStory = true;
		if (FlxG.keys.justPressed.CONTROL) FlxG.save.data.beatenStory = false;
		#end

		function goToState() {
			canClick = false;

			FlxTween.tween(FlxG.camera, {angle: 10}, 1.3, {ease: FlxEase.expoIn});
			FlxTween.tween(FlxG.camera, {zoom: 4}, 1.3, {ease: FlxEase.expoIn});

			FlxG.sound.play(Paths.sound('confirmMenu'));

			menuItems.forEach(function(spr:FlxSprite) {
				if (curSelected == spr.ID) {
					FlxFlicker.flicker(spr, 1, 0.075, false, false);
				} else {
					new FlxTimer().start(1, function(tmr:FlxTimer) {
						var daChoice:String = optionShit[curSelected].name;
						switch (daChoice) {
							case 'storymode':
								MusicBeatState.switchState(new LoadWeekState());
							case 'freeplay':
								if(FlxG.save.data.beatenStory) {
									MusicBeatState.switchState(new FreeplaySelectState());
							    } else {
									FreeplayState.donkeykongismyfavotrituemarvelsuperhero = 'mainstory';
									MusicBeatState.switchState(new FreeplayState(FreeplayState.donkeykongismyfavotrituemarvelsuperhero));
								}
							case 'credits':
								MusicBeatState.switchState(new CreditsState());
							case 'options':
								MusicBeatState.switchState(new options.OptionsState());
						}
					});
				}
			});	
		}

		menuItems.forEach(function(spr:FlxSprite) {
		    if(canClick) {
		        if (controls.BACK) {
				 	FlxG.sound.play(Paths.sound('cancelMenu'));
					MusicBeatState.switchState(new TitleState());
					canClick = false;
		        }

		    	if (FlxG.mouse.overlaps(spr)) {
					if (spr.ID == 3) spr.scale.set(0.975, 0.975);

			    	curSelected = spr.ID;
			    	spr.animation.play('selected');
					if(FlxG.mouse.justPressed) goToState();
			    } else {
					spr.animation.play('idle');
					if (spr.ID == 3) spr.scale.set(0.9, 0.9);
				}
		    }
		});

		super.update(elapsed);
	}
}

typedef MainMenuButton = {
	var x:Int;
	var y:Int;
	var scale:Float;
	var name:String;
}

typedef MainMenuCharacter = {
	var x:Int;
	var y:Int;
	var image:String;
}