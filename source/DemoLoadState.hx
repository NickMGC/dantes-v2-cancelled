package;

import Section.SwagSection;
import Song.SwagSong;
import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxState;
import haxe.Json;


class DemoLoadState extends MusicBeatState
{
	override function update(elapsed:Float)
    {
        PlayState.SONG = Song.loadFromJson('comedian', 'comedian');
        MusicBeatState.switchState(new PlayState());
        // FreeplayState.donkeykongismyfavotrituemarvelsuperhero = 'mainstory';
        // PlayState.isStoryMode = true;
    }
}