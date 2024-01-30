package;

#if discord_rpc
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.group.FlxGroup;
import flixel.FlxCamera;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.net.curl.CURLCode;
import WeekData;
import openfl.utils.Assets as OpenFlAssets;

using StringTools;

#if sys
import sys.FileSystem;
#end

class PeteState extends MusicBeatState {
    var freezeFrame:FlxSprite;
    var grad:FlxSprite;
    var cool:FlxSprite;
    var fuck:FlxSprite;

    var canClick:Bool = false;
    var canClickCool:Bool = false;

	override function create() {
		super.create();

        freezeFrame = new FlxSprite(0, 0).loadGraphic(Paths.image('finalframe'));
        freezeFrame.width = FlxG.width;
        freezeFrame.height = FlxG.height;
        freezeFrame.updateHitbox();
        freezeFrame.screenCenter();
		add(freezeFrame);

        grad = new FlxSprite(0, 0).loadGraphic(Paths.image('hguiofuhjpsod'));
        grad.width = FlxG.width;
        grad.height = FlxG.height;
        grad.updateHitbox();
        grad.screenCenter();
		add(grad);

        fuck = new FlxSprite(0, 0);
        fuck.frames = Paths.getSparrowAtlas('fuck_you');	
        fuck.animation.addByPrefix('select', 'fuckyouselect', 24, false);
        fuck.animation.addByPrefix('deselect', 'fuckyou', 24, false);
        fuck.scale.set(1, 1);
        fuck.visible = false;
        fuck.updateHitbox();

        cool = new FlxSprite(0, 0);
        cool.frames = Paths.getSparrowAtlas('youre_cool');	
        cool.animation.addByPrefix('select', 'yourecoolselect', 24, false);
        cool.animation.addByPrefix('deselect', 'yourecool', 24, false);
        cool.scale.set(1, 1);
        cool.visible = false;
        cool.updateHitbox();

        add(fuck);
        add(cool);

        cool.antialiasing = true;
        fuck.antialiasing = true;

        cool.screenCenter();
        cool.x = 100;
        cool.y = 200;

        fuck.screenCenter();
        fuck.x = 800;
        fuck.y = 200;

        startVideo('chooseyourfate', 0);
    }

    function options():Void {

        new FlxTimer().start(1, function(tmr:FlxTimer) {
            cool.visible = true;
            canClickCool = true;
            FlxG.sound.play(Paths.sound('cool'), 0.6);
		});

        new FlxTimer().start(2, function(tmr:FlxTimer) {
            fuck.visible = true;
            canClick = true;
            FlxG.sound.play(Paths.sound('fuck'), 0.6);
		});

    }

    function click(type:String) {
        canClick = false;
        canClickCool = false;
        fuck.visible = false;
        cool.visible = false;
        freezeFrame.visible = false;
        grad.visible = false;
        switch(type) {
            case 'cool':
                startVideo('cool', 1);
                canClick = false;
                canClickCool = false;
            case 'fuck':
                startVideo('kill', 2);
                canClick = false;
                canClickCool = false;
        }
    }
    
    function epicW() {
        FlxG.sound.playMusic(Paths.music('freakyMenu'));
        if (PlayState.isStoryMode)
            MusicBeatState.switchState(new TitleState());
        else
            MusicBeatState.switchState(new FreeplayState(FreeplayState.donkeykongismyfavotrituemarvelsuperhero));
    }

    function youreFucked() {
        startMadness();
    }

    function startMadness():Void {   
        PlayState.SONG = Song.loadFromJson("comedian", "comedian");
        MusicBeatState.switchState(new PlayState());
    }

    var over:Bool = false;

	override function update(elapsed:Float) {
		super.update(elapsed);
        FlxG.mouse.visible = true;
        if(canClick) {
        if (FlxG.mouse.overlaps(fuck)) {
			if(!over) {
                over = true;
                FlxG.sound.play(Paths.sound('fuck'), 0.6);
                fuck.animation.play('select', true);
            }
			if(FlxG.mouse.pressed) {
                click('fuck');
			}
        } else {
            if(fuck.animation.curAnim != null) {
                fuck.animation.play('deselect', true);
            }
        }

        if(!FlxG.mouse.overlaps(cool) && !FlxG.mouse.overlaps(fuck)) {
            over = false;
        }
        }

        if(canClickCool){
            if (FlxG.mouse.overlaps(cool))
            {
                if(!over){
                    over = true;
                    FlxG.sound.play(Paths.sound('cool'), 0.6);
                    cool.animation.play('select', true);
                }
                if(FlxG.mouse.pressed)
                {
                    click('cool');
                }
            }else{
                if(cool.animation.curAnim != null){
                    cool.animation.play('deselect', true);
                }
            
            }
            if(!FlxG.mouse.overlaps(cool) && !FlxG.mouse.overlaps(fuck)){
                over = false;
            }
        }
        
	}

    public function startVideo(name:String, funcToCall:Int):Void {

        var finishCallback:Void->Void;

        switch(funcToCall){
            case 0:
                finishCallback = options; 
            case 1:
                finishCallback = epicW; 
            case 2:
                finishCallback = youreFucked;
        }
       
        
		#if VIDEOS_ALLOWED
		var foundFile:Bool = false;
		var fileName:String = '';
		#if sys
		if(FileSystem.exists(fileName)) {
			foundFile = true;
		}
		#end

		if(!foundFile) {
			fileName = Paths.video(name);
			#if sys
			if(FileSystem.exists(fileName)) {
			#else
			if(OpenFlAssets.exists(fileName)) {
			#end
				foundFile = true;
			}
		}

		if(foundFile) {
			var bg = new FlxSprite(-FlxG.width, -FlxG.height).makeGraphic(FlxG.width * 3, FlxG.height * 3, FlxColor.BLACK);
			bg.scrollFactor.set();
			add(bg);

			(new FlxVideo(fileName)).finishCallback = function() {
				remove(bg);
                finishCallback();
			}
			return;
		} else {
			FlxG.log.warn('Couldnt find video file: ' + fileName);
		}
		#end
	}
}