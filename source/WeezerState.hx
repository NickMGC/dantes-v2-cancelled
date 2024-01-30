import flixel.addons.transition.FlxTransitionableState;
import flixel.system.scaleModes.*;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import lime.app.Application;
import flixel.FlxSprite;
import flixel.FlxG;
import openfl.Lib;

class WeezerState extends MusicBeatState {
	var weezer:FlxSprite;
	var modeStage:StageSizeScaleMode;
    //DMCA takedown speedrun any%
	override function create() {
		transOut = FlxTransitionableState.defaultTransOut;
		modeStage = new StageSizeScaleMode();
		FlxG.scaleMode = modeStage;

		FlxTransitionableState.skipNextTransOut = true;
		Main.fpsVar.visible = false;

		weezer = new FlxSprite(0, 0).loadGraphic(Paths.image('menuStuff/mainMenu/weezer'));
        weezer.screenCenter(X);
        add(weezer);

		FlxTween.tween(Lib.application.window, {height: 720}, 2, {ease: FlxEase.cubeInOut});
		FlxTween.tween(Lib.application.window, {width: 720}, 2, {ease: FlxEase.cubeInOut});
		FlxTween.tween(Lib.application.window, {x: 600}, 2, {ease: FlxEase.cubeInOut});
		FlxTween.tween(weezer, {x: 0}, 2, {ease: FlxEase.cubeInOut});
		FlxG.stage.window.borderless = true;

        FlxG.sound.playMusic(Paths.music('weezer'), 1.2);

		super.create();
	}
}