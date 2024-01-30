package;

#if discord_rpc
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.util.FlxGradient;
import flixel.addons.display.FlxBackdrop;
import flixel.FlxCamera;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import lime.utils.Assets;
import openfl.Assets;

using StringTools;

class CreditsState extends MusicBeatState {
	var curSelected:Int = -1;
	private var grpOptions:FlxTypedGroup<Alphabet>;
	private var iconArray:Array<AttachedSprite> = [];
	private var creditsStuff:Array<Array<String>> = [];

	var background:CheckerboardStuffs;
	var dots:FlxBackdrop;
	var toplayer:FlxSprite;
	var box:FlxSprite;	
	var descText:FlxText;
	var descBox:AttachedSprite;
	var transGradient:FlxSprite;

	override function create() {
		Paths.clearUnusedMemory();
		Paths.clearStoredMemory();
		super.create();	

		Conductor.changeBPM(102);

		#if discord_rpc
		DiscordClient.changePresence("In the Credits Menu", null);
		#end
		FlxG.mouse.visible = false;
		persistentUpdate = true;

		background = new CheckerboardStuffs(0, 0);
		FlxTween.tween(background, {x: -120}, (588.2352941176471 / 1000) * 4, {ease: FlxEase.linear, type: LOOPING});
		background.color = 0xFF2F814A;
		background.antialiasing = true;
		add(background);

		//hdfg note for basically everyone: fucking update flixel-addons
		dots = new FlxBackdrop(Paths.image('dots'), X);
		dots.scrollFactor.set();
		dots.velocity.set(50, 0);
		dots.screenCenter();
		dots.y = 200;
		dots.antialiasing = true;
		dots.alpha = 0.3;
		add(dots);
		
		box = new FlxSprite().loadGraphic(Paths.image('menuStuff/credits/box'));
		box.scrollFactor.set();
	    box.screenCenter();
		add(box);
		
		grpOptions = new FlxTypedGroup<Alphabet>();
		add(grpOptions);

		var creditsthing:Array<Array<String>> = [ //removing all the icons for now because too lazy to remake them rn
		    ['   VS Dantes Team'],
			['Flying Felt Boot','noicon',                                              'Owner, Artist'],
			['NickNGC',         'nick',           'Co-Owner, Side Artist, Coder, UI Designer, Charter'],
			['PlankDev',        'plank',                                                  'Side Coder'],
			["Itz_Miles",       'miles',        'Side Coder, GFX Transformations Library [ParallaxLT]'],
			['SansPZSG',        'noicon',                                              'Main Composer'],
			['Hordy17',         'noicon',                                              'Main Composer'],
			['Sano Seraphim',   'noicon',                                                   'Composer'],
			['Iccer',           'noicon',                             'VS Dantes logo, Concept Artist'],
			['MrHat',           'noicon',                      'Concept artist, quality assurance guy'],

	 	    ['   Special Thanks'],
			['Dieloski',        'noicon',                                              'Voiced Dantes'],
			["My dad?!?!?",     'noicon',                                               'Voiced Dagon'],
			['Alex_km',         'noicon',                                 'Helped with Dantes sprites'],
			['Sheeesh',         'noicon',                                          'Custom MenuBG art'],
			['D4rkwinged',      'noicon',                            'Made chromatic scales for Dagon'],
			['deasodiakk',      'noicon',                 'Made chromatic scales for Me lol, etc [28]'],
			['FistiQ',          'noicon',                             'Monster Dantes chromatic scale'],
			['Psych Crew',	    'psychcrew',	 	                            'Created Psych Engine'],
			["Funkin' Crew",	'fnfcrew',		                        "Created Friday Night Funkin'"]
		];
		
		for(i in creditsthing) {
			creditsStuff.push(i);
		}
	
		for (i in 0...creditsStuff.length) {
			var isSelectable:Bool = !unselectableCheck(i);
			var optionText:Alphabet = new Alphabet(0, 70 * i, creditsStuff[i][0], !isSelectable, false);
			optionText.isMenuItem = true;
			optionText.screenCenter(X);
			optionText.yAdd -= 70;
			if(isSelectable) optionText.x -= 70;
			optionText.forceX = optionText.x;
			optionText.targetY = i;
			grpOptions.add(optionText);

			if(isSelectable) {
				var icon:AttachedSprite = new AttachedSprite('menuStuff/credits/icons/' + creditsStuff[i][1]);
				icon.antialiasing = (creditsStuff[i][1] == "plank" ? false : true); // hardcoding this check in because grjwvfhoogikewfklghvfd
				icon.xAdd = optionText.width + 10;
				icon.sprTracker = optionText;
				iconArray.push(icon);
				add(icon);

				if(curSelected == -1) curSelected = i;
			}
		}
		
		toplayer = new FlxSprite().loadGraphic(Paths.image('menuStuff/credits/toplayer'));
		toplayer.scrollFactor.set();
		toplayer.screenCenter();
	    toplayer.antialiasing = true;
		add(toplayer);

		descBox = new AttachedSprite();
		descBox.makeGraphic(1, 1, FlxColor.BLACK);
		descBox.xAdd = -10;
		descBox.yAdd = -10;
		descBox.alphaMult = 0.6;
		descBox.alpha = 0.6;
		add(descBox);

		descText = new FlxText(50, FlxG.height + -680 - 25, 1180, "", 32);
		descText.setFormat(Paths.font("DIN2014Bold.ttf"), 32, FlxColor.WHITE, CENTER);
		descText.scrollFactor.set();
		descBox.sprTracker = descText;
		add(descText);

		changeSelection();
	}

	override function beatHit() {
		super.beatHit();
		if(curBeat % 2 == 0) FlxG.camera.zoom += 0.025;
	}

	override function update(elapsed:Float) {
		if (FlxG.sound.music != null) Conductor.songPosition = FlxG.sound.music.time;
		if (FlxG.sound.music.volume < 0.7) FlxG.sound.music.volume += 0.5 * FlxG.elapsed;

		FlxG.camera.zoom = FlxMath.lerp(1, FlxG.camera.zoom, 0.95);

		if(creditsStuff.length > 1) {
			var upP = controls.UI_UP_P;
			var downP = controls.UI_DOWN_P;
			var shiftMult:Int = 1;

			if (upP) changeSelection(-shiftMult);
			if (downP) changeSelection(shiftMult);
		
			if (CustomFadeTransition.canControl) {
				if (controls.BACK) {
				    FlxG.sound.play(Paths.sound('cancelMenu'));
				    MusicBeatState.switchState(new TitleState());
			    }
		    }
		}	

		for (item in grpOptions.members) { {
				var lerpVal:Float = CoolUtil.boundTo(elapsed * 12, 0, 1);
				if (item.targetY == 0) {
					var lastX:Float = item.x;
					item.screenCenter(X);
					item.x = FlxMath.lerp(lastX, item.x - 50, lerpVal);
					item.forceX = item.x;
				} else {
					item.x = FlxMath.lerp(item.x, 210 + -20 * Math.abs(item.targetY), lerpVal);
					item.forceX = item.x;
				}
			}
		}
		super.update(elapsed);
	}

	function changeSelection(change:Int = 0) {
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
		do {
			curSelected += change;
			if (curSelected < 0) curSelected = creditsStuff.length - 1;
			if (curSelected >= creditsStuff.length) curSelected = 0;
		} while (unselectableCheck(curSelected));

		var bullShit:Int = 0;

		for (item in grpOptions.members) {
			item.targetY = bullShit - curSelected;
			bullShit++;

			if(!unselectableCheck(bullShit-1)) {
				item.alpha = 0.6;
				if (item.targetY == 0) item.alpha = 1;
			}
		}

		descText.text = creditsStuff[curSelected][2];
		descText.y = FlxG.height - descText.height + -680 - 60 + 75;

		descBox.setGraphicSize(Std.int(descText.width + 20), Std.int(descText.height + 25));
		descBox.updateHitbox();
	}

	private function unselectableCheck(num:Int):Bool {
		return creditsStuff[num].length <= 1;
	}
}