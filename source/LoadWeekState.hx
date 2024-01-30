package;

import flixel.FlxG;
import flixel.addons.transition.FlxTransitionableState;
import WeekData;

class LoadWeekState extends MusicBeatState {
	var loadedWeeks:Array<WeekData> = [];

	override function create() {
		Paths.clearStoredMemory();
		Paths.clearUnusedMemory();

		WeekData.reloadWeekFiles(true);

		for (i in 0...WeekData.weeksList.length) {
			var weekFile:WeekData = WeekData.weeksLoaded.get(WeekData.weeksList[i]);
			loadedWeeks.push(weekFile);
			WeekData.setDirectoryFromWeek(weekFile);
		}
		WeekData.setDirectoryFromWeek(loadedWeeks[0]);
		CoolUtil.difficulties = CoolUtil.defaultDifficulties.copy();

		var songArray:Array<String> = [];
		var leWeek:Array<Dynamic> = loadedWeeks[0].songs;
		for (i in 0...leWeek.length) {
			songArray.push(leWeek[i][0]);
		}

		PlayState.storyPlaylist = songArray;
		PlayState.isStoryMode = true;
		PlayState.storyDifficulty = 0;

		PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + '', PlayState.storyPlaylist[0].toLowerCase());
		PlayState.campaignScore = 0;
		PlayState.campaignMisses = 0;
		MusicBeatState.switchState(new PlayState());
		super.create();
	}
}