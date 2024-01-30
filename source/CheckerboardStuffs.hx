package;

import flixel.graphics.frames.FlxAtlasFrames;
import animateatlas.AtlasFrameMaker;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;

class CheckerboardStuffs extends FlxTypedSpriteGroup<FlxSprite> {
    public function new(x:Int, y:Int) {
        super(x, y);

        createCubes();
    }

    function createCubes() {
        var numCubesX:Int = Math.ceil(1920 / 118);
        var numCubesY:Int = Math.ceil(1080 / 124);

        for (yIndex in 0...numCubesY) {
            for (xIndex in 0...numCubesX) {
       			var cube:FlxSprite = new FlxSprite();
                cube.frames = Paths.getSparrowAtlas("menuStuff/cubes", null);
                cube.animation.addByPrefix("cubeAnim", "cubes", 24, true);
                cube.animation.play("cubeAnim");
                cube.x = 118 * xIndex;
                cube.y = 124 * yIndex;
                cube.scrollFactor.set();
        		add(cube);
            }
        }
    }
}