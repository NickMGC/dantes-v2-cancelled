package;

import Controls.Control;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.sound.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.FlxCamera;
import flixel.util.FlxStringUtil;

class PauseSubState extends MusicBeatSubstate {
	var optionShit:Array<String> = [
		'resume',
		'restart',
		'exit'
	];
	var menuItems:FlxTypedGroup<FlxSprite>;
	var selector:FlxSprite;
	var curSelected:Int = 0;

	var pauseMusic:FlxSound;
	public static var songName:String = 'tea-time';

	public function new(x:Float, y:Float) {
		super();

		pauseMusic = new FlxSound();
		pauseMusic.loadEmbedded(Paths.music(songName), true, true);
		pauseMusic.volume = 0;
		pauseMusic.play(false, FlxG.random.int(0, Std.int(pauseMusic.length / 2)));
		FlxG.sound.list.add(pauseMusic);

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.alpha = 0;
		bg.scrollFactor.set();
		add(bg);

		var chartingText:FlxText = new FlxText(20, 15 + 101, 0, "CHARTING MODE", 32);
		chartingText.scrollFactor.set();
		chartingText.setFormat(Paths.font('DIN2014Bold.ttf'), 32);
		chartingText.x = FlxG.width - (chartingText.width + 20);
		chartingText.y = FlxG.height - (chartingText.height + 20);
		chartingText.updateHitbox();
		chartingText.visible = PlayState.chartingMode;
		add(chartingText);

		selector = new FlxSprite(25, 300).loadGraphic(Paths.image('menuStuff/mainMenu/selector'));
		selector.antialiasing = true;
		add(selector);

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		for (i in 0...optionShit.length) {
			var menuItem:FlxSprite = new FlxSprite(-477, (i * 150) + 150).loadGraphic(Paths.image('menuStuff/pause/' + optionShit[i]));
			menuItem.ID = i;
			menuItem.antialiasing = true;
			menuItems.add(menuItem);
		}

		var eventThing:FlxSprite = new FlxSprite(0, 720).loadGraphic(Paths.image('eventThing'));
		eventThing.color = 0xFF000000;
		eventThing.antialiasing = true;
		add(eventThing);

		var eventThing2:FlxSprite = new FlxSprite(0, -115).loadGraphic(Paths.image('eventThing'));
		eventThing2.flipY = true;
		eventThing2.color = 0xFF000000;
		eventThing2.antialiasing = true;
		add(eventThing2);

		FlxTween.tween(bg, {alpha: 0.6}, 0.75, {ease: FlxEase.quartInOut});
		FlxTween.tween(eventThing, {y: 605}, 0.75, {ease: FlxEase.quartOut});
		FlxTween.tween(eventThing2, {y: 0}, 0.75, {ease: FlxEase.quartOut});

		changeItem(0);
		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
	}

	override function update(elapsed:Float) {
		if (pauseMusic.volume < 0.5) pauseMusic.volume += 0.01 * elapsed;

		super.update(elapsed);

		if ((controls.UI_UP_P || controls.UI_DOWN_P)) changeItem(controls.UI_UP_P ? -1 : 1);

		menuItems.forEach(function(spr:FlxSprite) {
			if (controls.ACCEPT) {
				var daChoice:String = optionShit[curSelected];
				switch (daChoice) {
					case "resume":
						close();
					case "restart":
						restartSong();
					case "exit":
						PlayState.deathCounter = 0;
						PlayState.seenCutscene = false;
						if(PlayState.isStoryMode)
							MusicBeatState.switchState(new TitleState());
						else
							MusicBeatState.switchState(new FreeplayState(FreeplayState.donkeykongismyfavotrituemarvelsuperhero));

						FlxG.sound.playMusic(Paths.music('freakyMenu'));
						PlayState.chartingMode = false;
				}
			}
		});
	}

	public static function restartSong() {
		PlayState.instance.paused = true; // For lua
		FlxG.sound.music.volume = 0;
		PlayState.instance.vocals.volume = 0;

		MusicBeatState.resetState();
	}

	override function destroy() {
		pauseMusic.destroy();
		super.destroy();
	}

	function changeItem(huh:Int = 0) {
		curSelected = Std.int(Math.min(Math.max(curSelected + huh, 0), menuItems.length - 1));
		menuItems.forEach(function(spr:FlxSprite) {
			spr.x = 25;

			if (spr.ID == curSelected) {
				var add:Float = 0;
				spr.x = 110;
				selector.y = spr.y + 25;
				if(menuItems.length > 4) add = menuItems.length * 8;
				spr.centerOffsets();
			}
		});
	}
}