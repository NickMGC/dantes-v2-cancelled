package;

import flixel.sound.FlxSound;
import flixel.FlxCamera;
import flixel.util.FlxColor;
import flixel.input.keyboard.FlxKey;
import sys.FileSystem;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxG;

class IntroState extends FlxState {
    public var camHUD:FlxCamera;

    override public function create():Void {

        super.create();

		camHUD = new FlxCamera();
		FlxG.cameras.add(camHUD);
        FlxG.mouse.visible = false;

        if(!ClientPrefs.hasSeenCutscene) {
            function startVideo(name:String):Void {
                #if VIDEOS_ALLOWED
                var foundFile:Bool = false;
                var fileName:String = 'intro';
                #if sys
                if(FileSystem.exists(fileName)) foundFile = true;
                #end

                if(!foundFile) {
                    fileName = Paths.video(name);
                    if(FileSystem.exists(fileName)) foundFile = true;
                }
    
                if(foundFile) {
                    (new FlxVideo(fileName)).finishCallback = function() {
                        MusicBeatState.switchState(new TitleState());
                        ClientPrefs.hasSeenCutscene = true;
                    }
                    return;
                } else {
                    FlxG.log.warn('Couldnt find video file: ' + fileName);
                    MusicBeatState.switchState(new TitleState());
                }
                #end
            }
            startVideo("intro");
        } else {
            MusicBeatState.switchState(new TitleState());
            ClientPrefs.hasSeenCutscene = true;
        }
    }
}