package;

import lime.app.Application;
import flixel.FlxSubState;
#if cpp
import sys.FileSystem;
import sys.io.File;
#end
import flixel.FlxG;
import openfl.Lib;
import Conductor;

class CantalopeSubState extends MusicBeatSubstate {
	override public function create():Void {
		super.create();

		FlxG.sound.music.stop();
		Paths.image('cantalope');
		FlxG.sound.playMusic(Paths.music('cantaloupe'), 1, false);
		#if cpp FlxG.sound.music.onComplete = () -> Sys.exit(1); #end // swap with flixel, lime, or haxe close util? //this code was for the demo build, it isn't really used anymore
		Conductor.changeBPM(200);
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
		Conductor.songPosition = FlxG.sound.music.time;
	}

	override function beatHit():Void {
		super.beatHit();

		if (curBeat == 4) {
			Main.fpsVar.visible = false;
			FlxG.mouse.visible = false;
			add(new flixel.FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, 0xFFFFFFFF));
			var can:flixel.FlxSprite = new flixel.FlxSprite(0, 0, Paths.image('cantalope'));
			can.scale.set(0.15, 0.15);
			can.updateHitbox();
			add(can.screenCenter());
			FlxG.fullscreen = true;
		}
	}
}