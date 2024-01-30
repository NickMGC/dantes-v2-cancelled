package;

#if discord_rpc
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.addons.display.FlxBackdrop;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.FlxCamera;
import flixel.util.FlxGradient;

using StringTools;

typedef FreeplayMenuButton = {
	var x:Int;
	var y:Int;
	var name:String;
}

class FreeplaySelectState extends MusicBeatState {
	var menuItems:FlxTypedGroup<FlxSprite>;
	public static var curSelected:Int = 0;

	var optionStuff:Array<FreeplayMenuButton> = [{x: 50, y: 50, name: 'mainstory'}, {x: 700, y: 50, name: 'freeplay'}];

	var background:FlxSprite;
	var dots:FlxBackdrop;
	var transGradient:FlxSprite;
    var bg:FlxSprite;
	var barslol:FlxSprite;

	override function create() {
		#if discord_rpc
		DiscordClient.changePresence("Choosing a song", null);
		#end

		FlxG.mouse.visible = true;

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;
		

		persistentUpdate = persistentDraw = true;

		background = new CheckerboardStuffs(0, 0);
		FlxTween.tween(background, {x: -118}, (588.2352941176471 / 1000) * 6, {ease: FlxEase.linear, type: LOOPING});
		background.color = 0xFFFF7600;
		background.antialiasing = true;
		add(background);

		bg = new FlxSprite().loadGraphic(Paths.image('menuBG'));
		bg.antialiasing = true;
		bg.screenCenter();
		bg.alpha = 0.3;
		add(bg);

		dots = new FlxBackdrop(Paths.image('dots'), X);
		dots.scrollFactor.set();
		dots.velocity.set(50, 0);
		dots.screenCenter();
		dots.antialiasing = true;
		add(dots);

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		for (i in 0...optionStuff.length) {
			var option:FreeplayMenuButton = optionStuff[i];
			var menuItem:FlxSprite = new FlxSprite(option.x, option.y).loadGraphic(Paths.image('menuStuff/freeplay/category-' + option.name));
			menuItem.ID = i;
			menuItem.antialiasing = true;
			menuItem.updateHitbox();
			menuItems.add(menuItem);
		}

		barslol = new FlxSprite().loadGraphic(Paths.image('menuStuff/freeplay/barslol'));
		barslol.scrollFactor.set(0, 0);
		barslol.scale.set(2, 1);
		barslol.screenCenter();
		barslol.flipX = true;
		barslol.antialiasing = true;
		add(barslol);

		transGradient = FlxGradient.createGradientFlxSprite(1280, 720, [0x8CBD1800, 0x0]);
		transGradient.scrollFactor.set();
		transGradient.alpha = 0.75;
		add(transGradient);

		super.create();
	}

	function goToState() {
		switch(curSelected) {
			case 0:
				FreeplayState.donkeykongismyfavotrituemarvelsuperhero = 'mainstory';
			default:
				FreeplayState.donkeykongismyfavotrituemarvelsuperhero = 'freeplay';
		}
		MusicBeatState.switchState(new FreeplayState(FreeplayState.donkeykongismyfavotrituemarvelsuperhero));
	}

	override function update(elapsed:Float) {
		if (FlxG.sound.music.volume < 0.8) FlxG.sound.music.volume += 0.5 * FlxG.elapsed;

		if (CustomFadeTransition.canControl) {
			if (controls.BACK) {
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new TitleState());
			}
	
			menuItems.forEach(function(spr:FlxSprite) {
				if (FlxG.mouse.overlaps(spr)) {
					curSelected = spr.ID;
					if (FlxG.mouse.pressed) goToState();
				}
			});
		}
		super.update(elapsed);
	}
}