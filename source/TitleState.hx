package;

#if discord_rpc
import Discord.DiscordClient;
import sys.thread.Thread;
#end
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.input.keyboard.FlxKey;
import flixel.addons.transition.FlxTransitionableState;
import flixel.math.FlxMath;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup;
import flixel.input.gamepad.FlxGamepad;
import flixel.sound.FlxSound;
import flixel.system.ui.FlxSoundTray;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.app.Application;
import openfl.Assets;
import flixel.addons.display.FlxBackdrop;
import flixel.effects.FlxFlicker;

using StringTools;

class TitleState extends MusicBeatState {
	public static var curSelected:Int = 0;

	public static var muteKeys:Array<FlxKey> = [FlxKey.ZERO];
	public static var volumeDownKeys:Array<FlxKey> = [FlxKey.NUMPADMINUS, FlxKey.MINUS];
	public static var volumeUpKeys:Array<FlxKey> = [FlxKey.NUMPADPLUS, FlxKey.PLUS];

	public static var initialized:Bool = false;

	var blackScreen:FlxSprite;
	var credGroup:FlxGroup;
	var textGroup:FlxGroup;
	var ngSpr:FlxSprite;

	var curWacky:Array<String> = [];
	var curWacky2:Array<String> = [];

	var dots:FlxBackdrop;
	var cube:FlxBackdrop;
	var eventThing:FlxBackdrop;
	var eventThing2:FlxBackdrop;
	var barslol:FlxSprite;
	var bg:FlxSprite;
	var dan:FlxSprite;
	var selector:FlxSprite;
	public static var finishedTransition:Bool = false;

	var optionShit:Array<String> = [
		'play',
		'freeplay',
		'credits',
		'options',
	];

	var characters:Array<TitleCharacter> = [
	    {x: 840,  y: 170, image:    "dan"},
		{x: 975,  y: 0,   image: "dantes"},
		{x: 975,  y: 345, image: "george"},
		{x: 0,    y: 0,   image:  "dagon"},
		{x: 1010, y: 410, image:    "tim"},
	];

	var menuItems:FlxTypedGroup<FlxSprite>;

	var curChar:TitleCharacter;
	var char:FlxSprite;

	var soundDidTheDo:Bool = false;
	var skippedIntro:Bool = false;

	override public function create():Void {
		FlxG.game.focusLostFramerate = 60;
		FlxG.sound.muteKeys = muteKeys;
		FlxG.sound.volumeDownKeys = volumeDownKeys;
		FlxG.sound.volumeUpKeys = volumeUpKeys;
		FlxG.keys.preventDefaultKeys = [TAB];
		ClientPrefs.hasSeenCutscene = true;
		PlayerSettings.init();

		curWacky = FlxG.random.getObject(getIntroTextShit());
		curWacky2 = FlxG.random.getObject(getIntroTextShit());

		super.create();

		FlxG.save.bind('funkin', 'ninjamuffin99');
		ClientPrefs.loadPrefs();

		Highscore.load();

		if (FlxG.save.data.weekCompleted != null) PlayState.weekCompleted = FlxG.save.data.weekCompleted;
		if (finishedTransition) FlxG.camera.scroll.x = 1828;

		FlxG.mouse.visible = false;
		if(FlxG.save.data.flashing == null && !FlashingState.leftState) {
			FlxTransitionableState.skipNextTransIn = true;
			FlxTransitionableState.skipNextTransOut = true;
			MusicBeatState.switchState(new FlashingState());
		} else {
			#if discord_rpc
			DiscordClient.initialize();
			Application.current.onExit.add(function(exitCode) {
				DiscordClient.shutdown();
			});
			#end
			if (finishedTransition)
				startIntro();
			else {
				new FlxTimer().start(1, function(tmr:FlxTimer) {
					startIntro();
				});
			}
		}
	}

	var logoBl:FlxSprite;
	var titleText:FlxSprite;

	function startIntro() {
		if (!initialized) {
			if(FlxG.sound.music == null) {
				FlxG.sound.playMusic(Paths.music('freakyMenu'), 0);
				FlxG.sound.music.fadeIn(4, 0, 0.7);
			}
		}

		var cursor:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuStuff/custom'));
		FlxG.mouse.load(cursor.pixels, 0.35, 0, 0);

		Conductor.changeBPM(102);
		persistentUpdate = persistentDraw = true;

		cube = new FlxBackdrop();
        cube.frames = Paths.getSparrowAtlas("menuStuff/cubes", null);
        cube.animation.addByPrefix("cubeAnim", "cubes", 24, true);
        cube.animation.play("cubeAnim");
		cube.color = 0xFFFF7600;
        add(cube);

		bg = new FlxSprite().loadGraphic(Paths.image('menuBG'));
		bg.scrollFactor.set(0);
		bg.antialiasing = true;
		bg.screenCenter();
		bg.alpha = 0.3;
		add(bg);

		dots = new FlxBackdrop(Paths.image('dots'), X);
		dots.antialiasing = true;
		dots.scrollFactor.set(0.3, 0.3);
		dots.alpha = 0.7;
		dots.screenCenter();
		dots.updateHitbox();
	    add(dots);

		var charIndex:Int = FlxG.random.int(0, 4);
		curChar = characters[charIndex];
		char = new FlxSprite(2650, 140).loadGraphic(Paths.image('menuStuff/mainMenu/${curChar.image}'));
		char.scale.set(0.85, 0.85);
		char.antialiasing = true;
		add(char);
		if (finishedTransition) if(charIndex == 0) FlxG.sound.play(Paths.sound('OHMYGOD'), 2).pitch = (1 + (Math.random() / 6));

		if (charIndex == 3) 
			char.offset.set(-50, 80);
		else if (charIndex == 1) 
			char.offset.set(0, 75);
		else 
			char.offset.set(0, 0);

		FlxG.mouse.visible = charIndex == 0                                                                                                                                                                                                                                                                                                                                                                                                                                                                       ;//OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOH

		barslol = new FlxSprite().loadGraphic(Paths.image('menuStuff/options/optionsbars'));
		barslol.scrollFactor.set(0.7, 0.7);
		barslol.updateHitbox();
		barslol.antialiasing = true;
	    add(barslol);

		var barsol:FlxSprite = new FlxSprite(1280).loadGraphic(Paths.image('menuStuff/mainMenu/barslol'));
		barsol.scrollFactor.set(0.7, 0.7);
		barsol.updateHitbox();
		barsol.antialiasing = true;
	    add(barsol);

		if (!finishedTransition) {
			dan = new FlxSprite().loadGraphic(Paths.image('menuStuff/mainMenu/TitleDan'));
			dan.antialiasing = true;
			add(dan);
	
			logoBl = new FlxSprite(715, 50).loadGraphic(Paths.image('menuStuff/mainMenu/logo'));
			logoBl.antialiasing = true;
			logoBl.scrollFactor.set(2.3, 2.3);
			logoBl.scale.set(0.7, 0.7);
			logoBl.updateHitbox();
			add(logoBl);
		}

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		for (i in 0...optionShit.length) {
			var menuItem:FlxSprite = new FlxSprite(1920, (i * 100) + 160).loadGraphic(Paths.image('menuStuff/mainMenu/' + optionShit[i]));
			menuItem.ID = i;
			menuItem.antialiasing = true;
			menuItem.updateHitbox();
			menuItems.add(menuItem);
		}

		selector = new FlxSprite(1945, 300).loadGraphic(Paths.image('menuStuff/mainMenu/selector'));
		selector.antialiasing = true;
		add(selector);

		eventThing = new FlxBackdrop(Paths.image('eventThing'), X);
		eventThing.y = 605;
		eventThing.color = 0xFF000000;
		eventThing.scrollFactor.set();
		eventThing.updateHitbox();
		eventThing.antialiasing = true;
	    add(eventThing);

		eventThing2 = new FlxBackdrop(Paths.image('eventThing'), X);
		eventThing2.flipY = true;
		eventThing2.color = 0xFF000000;
		eventThing2.scrollFactor.set();
		eventThing2.updateHitbox();
		eventThing2.antialiasing = true;
	    add(eventThing2);

		if (!finishedTransition) {
			titleText = new FlxSprite(625, 500);
			titleText.frames = Paths.getSparrowAtlas('menuStuff/mainMenu/titleEnter');
			titleText.animation.addByPrefix('idle', "Press Enter to Begin", 24);
			titleText.animation.addByPrefix('press', "ENTER PRESSED", 24);
			titleText.antialiasing = true;
			titleText.animation.play('idle');
			titleText.scrollFactor.set(2.5, 2.5);
			titleText.updateHitbox();
			add(titleText);
		}

		credGroup = new FlxGroup();
		add(credGroup);
		textGroup = new FlxGroup();

		blackScreen = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		credGroup.add(blackScreen);

		ngSpr = new FlxSprite(0, FlxG.height * 0.52).loadGraphic(Paths.image('menuStuff/mainMenu/newgrounds_logo'));
		add(ngSpr);
		ngSpr.y += 750;
		ngSpr.visible = false;
		ngSpr.setGraphicSize(Std.int(ngSpr.width * 0.8));
		ngSpr.updateHitbox();
		ngSpr.screenCenter(X);
		ngSpr.antialiasing = true;

		if (initialized)
			skipIntro();
		else
			initialized = true;

		if (finishedTransition) 			changeItem(0); //fuck you im leaving this formatting
	}

	function getIntroTextShit():Array<Array<String>> {
		var fullText:String = Assets.getText(Paths.txt('introText'));

		var firstArray:Array<String> = fullText.split('\n');
		var swagGoodArray:Array<Array<String>> = [];

		for (i in firstArray) swagGoodArray.push(i.split('--'));

		return swagGoodArray;
	}

	var transitioning:Bool = false;
	var selectedSomethin:Bool = false;

	override function update(elapsed:Float) {
		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;
			// FlxG.watch.addQuick('amp', FlxG.sound.music.amplitude);

		if (!soundDidTheDo) {
			if (FlxG.camera.scroll.x >= 300) {
				if (!finishedTransition) if(characters.indexOf(curChar) == 0) FlxG.sound.play(Paths.sound('OHMYGOD'), 2).pitch = (1 + (Math.random() / 6));
				soundDidTheDo = true;
			}
		}

		FlxG.camera.zoom = FlxMath.lerp(1, FlxG.camera.zoom, 0.95);

		var pressedEnter:Bool = FlxG.keys.justPressed.ENTER || controls.ACCEPT;
		var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

		//there's probably a better way of doing this but fuck it
		if (cube != null) cube.x = -FlxG.camera.scroll.x / 3.855;
		if (dan != null) dan.x = -FlxG.camera.scroll.x;
		if (eventThing != null) eventThing.x = FlxG.camera.scroll.x / 2.855;
		if (eventThing2 != null) eventThing2.x = FlxG.camera.scroll.x / 2.855;

		if (FlxG.keys.justPressed.F) FlxG.fullscreen = !FlxG.fullscreen;
		if (gamepad != null) if (gamepad.justPressed.START) pressedEnter = true;

		if (!transitioning && !finishedTransition && skippedIntro && initialized) {
			if(pressedEnter) {
				if(titleText != null) titleText.animation.play('press');
				changeItem(0);
				FlxG.camera.flash(FlxColor.WHITE, 1);
				FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);

				FlxTween.tween(FlxG.camera.scroll, {x: 1828}, 2.5, {ease: FlxEase.quintInOut, onComplete: function(twn:FlxTween) {
					finishedTransition = true;
				}});

				transitioning = true;
			}
		}

		#if hl
		if (FlxG.keys.justPressed.SPACE) FlxG.save.data.beatenStory = true;
		if (FlxG.keys.justPressed.CONTROL) FlxG.save.data.beatenStory = false;
		#end

		if (FlxG.camera.scroll.x == 1828) {
			if(dan != null) dan.destroy();
			if(logoBl != null) {
				logoBl.destroy();
				logoBl = null;
			}
			if(titleText != null) titleText.destroy();
		}

		if (FlxG.camera.scroll.x >= 400) {
			if (!selectedSomethin) {
				if (FlxG.mouse.overlaps(char)) if (FlxG.mouse.pressed) if(characters.indexOf(curChar) == 0) FlxG.sound.play(Paths.sound('OHMYGOD'), 2).pitch = (1 + (Math.random() / 6));

				if (controls.UI_UP_P) {
					FlxG.sound.play(Paths.sound('scrollMenu'));
					changeItem(-1);
				}
		
				if (controls.UI_DOWN_P) {
					FlxG.sound.play(Paths.sound('scrollMenu'));
					changeItem(1);
				}
		
				if (CustomFadeTransition.canControl) {
					if (controls.ACCEPT) {
						selectedSomethin = true;
						FlxG.camera.flash(ClientPrefs.flashing ? FlxColor.WHITE : 0xFFFFFFFF, 1);
						FlxG.sound.play(Paths.sound('confirmMenu'));
		
						menuItems.forEach(function(spr:FlxSprite) {
							if (curSelected == spr.ID) {
								FlxFlicker.flicker(spr, 1, 0.075, false, false);
								new FlxTimer().start(0.5, function(tmr:FlxTimer) {
									FlxTween.tween(FlxG.camera.scroll, {x: 1078}, 1, {ease: FlxEase.quintIn});
								});
							} else {
								new FlxTimer().start(1, function(tmr:FlxTimer) {
									var daChoice:String = optionShit[curSelected];
									switch (daChoice) {
										case 'play':
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
				}
			}
		}

		if (pressedEnter && !skippedIntro && initialized) skipIntro();

		super.update(elapsed);
	}

	function changeItem(huh:Int = 0) {
		curSelected += huh;

		if (curSelected >= menuItems.length) curSelected = 0;
		if (curSelected < 0) curSelected = menuItems.length - 1;

		menuItems.forEach(function(spr:FlxSprite) {
			spr.updateHitbox();
			spr.x = 1945;

			if (spr.ID == curSelected) {
				var add:Float = 0;
				spr.x = 2030;
				selector.y = spr.y + 25;
				if(menuItems.length > 4) add = menuItems.length * 8;
				spr.centerOffsets();
			}
		});
	}

	function createCoolText(textArray:Array<String>, ?offset:Float = 0) {
		for (i in 0...textArray.length) {
			var money:Alphabet = new Alphabet(0, 0, textArray[i], true, false);
			money.screenCenter(X);
			money.y += (i * 60) + 200 + offset;
			if(credGroup != null && textGroup != null) {
				credGroup.add(money);
				textGroup.add(money);
			}
			money.y -= 350;
			FlxTween.tween(money, {y: money.y + 350}, 0.5, {ease: FlxEase.expoOut, startDelay: 0.0});
		}
	}

	function addMoreText(text:String, ?offset:Float = 0) {
		if(textGroup != null && credGroup != null) {
			var coolText:Alphabet = new Alphabet(0, 0, text, true, false);
			coolText.screenCenter(X);
			coolText.y += (textGroup.length * 60) + 200 + offset;
			credGroup.add(coolText);
			textGroup.add(coolText);
			coolText.y += 750;
		    FlxTween.tween(coolText, {y: coolText.y - 750}, 0.5, {ease: FlxEase.expoOut, startDelay: 0.0});
		}
	}

	function deleteCoolText() {
		while (textGroup.members.length > 0) {
			credGroup.remove(textGroup.members[0], true);
			textGroup.remove(textGroup.members[0], true);
		}
	}

	private var sickBeats:Int = 0; //Basically curBeat but won't be skipped if you hold the tab or resize the screen
	override function beatHit() {
		super.beatHit();

		if (logoBl != null) {
	    	FlxTween.cancelTweensOf(logoBl);
		    logoBl.scale.set(0.8, 0.8);
	    	FlxTween.tween(logoBl.scale, {x: 0.7, y: 0.7}, (Conductor.crochet / 1000) * 0.85, {ease: FlxEase.expoOut}); // fyu the duration of this tween is 2 steps :3
		}

        if(curBeat % 2 == 0) FlxG.camera.zoom += 0.025;

		sickBeats++;
		switch (sickBeats) {
			case 1:
				createCoolText(["VS Dantes by"], 15);
			case 2:
				addMoreText('Me lol', 15);
				addMoreText('Me lol', 15);
				addMoreText('Me lol', 15);
				addMoreText('Me lol', 15);
				addMoreText('Me lol', 15);
				addMoreText('Me lol', 15);
				addMoreText('Me lol', 15);
				addMoreText('Me lol', 15);
				addMoreText('Me lol', 15);
			case 3:
				deleteCoolText();
			case 4:
				createCoolText(['Not associated', 'with'], -40);
			case 5:
				addMoreText('newgrounds', -40);
		    	ngSpr.visible = true;
				FlxTween.tween(ngSpr, {y: ngSpr.y - 750}, 0.5, {ease: FlxEase.expoOut, startDelay: 0.0});
			case 6:
				deleteCoolText();
				ngSpr.visible = false;
			case 7:
				createCoolText([curWacky[0]]);
			case 8:
				addMoreText(curWacky[1]);
			case 9:
				deleteCoolText();
			case 10:
				createCoolText([curWacky2[0]]);
			case 11:
				addMoreText(curWacky2[1]);
			case 12:
				deleteCoolText();
			case 13:
				addMoreText("FNF'");
			case 14:
				addMoreText('VS');
			case 15:
				addMoreText('Dantes');
			case 16:
				skipIntro();
		}
	}

	function skipIntro():Void {
		if (!skippedIntro) {
			remove(ngSpr);

			if (!finishedTransition) FlxG.camera.flash(FlxColor.WHITE, 2);
			remove(credGroup);
			skippedIntro = true;
		}
	}
}

typedef TitleCharacter = {
	var x:Int;
	var y:Int;
	var image:String;
}