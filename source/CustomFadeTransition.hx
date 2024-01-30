package;

import flixel.FlxG;
import flixel.addons.ui.FlxUIState;
import flixel.math.FlxRect;
import flixel.addons.transition.FlxTransitionableState;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxGradient;
import flixel.FlxSubState;
import flixel.FlxSprite;
import flixel.FlxCamera;

class CustomFadeTransition extends MusicBeatSubstate {
	public static var finishCallback:Void->Void;
	private var leTween:FlxTween = null;
	public static var nextCamera:FlxCamera;
	var isTransIn:Bool = false;
	var transGradient:FlxSprite;

	public static var canControl:Bool = true;

	public function new(duration:Float, isTransIn:Bool) {
		super();

		this.isTransIn = isTransIn;
		var width:Int = Std.int(FlxG.width);
		var height:Int = Std.int(FlxG.height);

		transGradient = new FlxSprite(0, 0, Paths.image('sonic'));
		transGradient.updateHitbox();
		transGradient.scrollFactor.set();
		transGradient.color = 0xFF000000;
		add(transGradient);

		if(isTransIn) {
			canControl = false;
			FlxTween.tween(transGradient, {x: -1329}, duration, {onComplete: function(twn:FlxTween) {
				close(); 
				canControl = true;
			}, ease: FlxEase.circInOut});
		} else {
			canControl = false;
			transGradient.x = 1280;
			transGradient.flipX = true;
			leTween = FlxTween.tween(transGradient, {x: -49}, duration, {onComplete: function(twn:FlxTween) {
				if(finishCallback != null) finishCallback();
				canControl = true;
			}, ease: FlxEase.circInOut});
		}

		transGradient.cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
	}

	override function destroy() {
		if(leTween != null) {
			finishCallback();
			leTween.cancel();
		}
		super.destroy();
	}
}