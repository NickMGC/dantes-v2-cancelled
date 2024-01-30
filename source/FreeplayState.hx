package;

#if discord_rpc
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import lime.utils.Assets;
import flixel.sound.FlxSound;
import openfl.utils.Assets as OpenFlAssets;
import WeekData;
import flixel.addons.display.FlxBackdrop;
import flixel.util.FlxGradient;
import flixel.FlxCamera;

using StringTools;

class FreeplayState extends MusicBeatState {
	var songs:Array<SongMetadata> = [];
	private static var curSelected:Int = 0;
	var curDifficulty:Int = 0;
	public var cat:String = '';
	public static var donkeykongismyfavotrituemarvelsuperhero:String = '';

	var scoreText:FlxText;
	var ratingText:FlxText;
	var lerpScore:Int = 0;
	var lerpRating:Float = 0;
	var intendedScore:Int = 0;
	var intendedRating:Float = 0;

	private var grpSongs:FlxTypedGroup<Alphabet>;
	var songText:Alphabet;

	private var iconArray:Array<HealthIcon> = [];
	private var lefticonArray:Array<HealthIcon> = [];

	var bg:FlxSprite;
	var background:CheckerboardStuffs;
	var disc:FlxSprite;
	var barslol:FlxSprite;
	var dots:FlxBackdrop;

	public function new(category:String) {
		super();
		cat = category;
		donkeykongismyfavotrituemarvelsuperhero = cat;
	}

	override function create() {
		switch (cat.toLowerCase()) {
			case 'mainstory':
				addWeek(['Comedian', 'Not Funny', 'Punchline', 'Card Trick'], 0, ['dantes', 'maddantes', 'monster-dantes', 'face']);
			case 'freeplay':
				addWeek(['Me Lol', 'Inferno', 'Apocolyplece', 'Dantoon', 'Final shot', 'Pete'], 1, ['face', 'face', 'face', 'face', 'face', 'pete']);
		};

		Paths.clearStoredMemory();
		//Paths.clearUnusedMemory();

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;
		persistentUpdate = true;
		PlayState.isStoryMode = false;
		WeekData.reloadWeekFiles(false);

		#if discord_rpc
		DiscordClient.changePresence("Choosing a song", null);
		#end

		for (i in 0...WeekData.weeksList.length) {
			var leWeek:WeekData = WeekData.weeksLoaded.get(WeekData.weeksList[i]);
			var leSongs:Array<String> = [];
			var leChars:Array<String> = [];

			for (j in 0...leWeek.songs.length) {
				leSongs.push(leWeek.songs[j][0]);
				leChars.push(leWeek.songs[j][1]);
			}

			WeekData.setDirectoryFromWeek(leWeek);
		}

		background = new CheckerboardStuffs(0, 0);
		FlxTween.tween(background, {x: -118}, (588.2352941176471 / 1000) * 8, {ease: FlxEase.linear, type: LOOPING});
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

		grpSongs = new FlxTypedGroup<Alphabet>();
		add(grpSongs);

		for (i in 0...songs.length) {
			songText = new Alphabet(0, (70 * i) + 30, songs[i].songName, true, false);
			songText.isMenuItem = true;
			songText.itemType = 'D-Shape';
			songText.targetY = i - curSelected;
			grpSongs.add(songText);

			if (songText.width > 980) {
				var textScale:Float = 990 / songText.width;
				songText.scale.x = textScale;
				for (letter in songText.lettersArray) {
					letter.x *= textScale;
					letter.offset.x *= textScale;
				}
			}

			Paths.currentModDirectory = songs[i].folder;

			var lefticon:HealthIcon = new HealthIcon(songs[i].songCharacter);
			lefticon.x = -800;
			lefticon.sprTracker = songText;
			lefticonArray.push(lefticon);
			HealthIcon.left = true;
			add(lefticon);
		}

		disc = new FlxSprite(700, -20).loadGraphic(Paths.image('menuStuff/freeplay/disc'));
		disc.antialiasing = true;
		add(disc);

		for (i in 0...songs.length) {
			var icon:HealthIcon = new HealthIcon(songs[i].songCharacter);
			icon.x = 1010;
			icon.y = 280;
			icon.scale.set(1.9, 1.9);
			iconArray.push(icon);
			add(icon);
		}
		WeekData.setDirectoryFromWeek();

		barslol = new FlxSprite().loadGraphic(Paths.image('menuStuff/mainMenu/barslol'));
		barslol.antialiasing = true;
		barslol.screenCenter();
		barslol.flipX = true;
		add(barslol);

		var eventThing:FlxSprite = new FlxSprite(0, 605).loadGraphic(Paths.image('eventThing'));
		eventThing.antialiasing = true;
		eventThing.color = 0xFF000000;
		add(eventThing);

		var eventThing2:FlxSprite = new FlxSprite().loadGraphic(Paths.image('eventThing'));
		eventThing2.antialiasing = true;
		eventThing2.color = 0xFF000000;
		eventThing2.flipY = true;
		add(eventThing2);

		scoreText = new FlxText(FlxG.width * 0.7, 5, 0, "", 32);
		scoreText.setFormat(Paths.font("DIN2014Bold.ttf"), 32, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		scoreText.antialiasing = true;
		scoreText.borderSize = 3;
		scoreText.y = 13;
		add(scoreText);

		ratingText = new FlxText(FlxG.width * 0.7, 5, 0, "", 32);
		ratingText.setFormat(Paths.font("DIN2014Bold.ttf"), 32, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		ratingText.antialiasing = true;
		ratingText.borderSize = 3;
		ratingText.y = 667;
		add(ratingText);

		if(curSelected >= songs.length) curSelected = 0;
		changeSelection();

		super.create();
	}

	override function closeSubState() {
		changeSelection(0, false);
		persistentUpdate = true;
		super.closeSubState();
	}

	public function addSong(songName:String, weekNum:Int, songCharacter:String) {
		songs.push(new SongMetadata(songName, weekNum, songCharacter));
	}

	public function addWeek(songs:Array<String>, weekNum:Int, ?songCharacters:Array<String>) {
		if (songCharacters == null) songCharacters = ['bf'];

		var num:Int = 0;
		for (song in songs) {
			addSong(song, weekNum, songCharacters[num]);
			if (songCharacters.length != 1) num++;
		}
	}

	var holdTime:Float = 0;
	override function update(elapsed:Float) {
		if (FlxG.sound.music.volume < 0.7) FlxG.sound.music.volume += 0.5 * FlxG.elapsed;

		disc.angle += 0.5;

		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, CoolUtil.boundTo(elapsed * 24, 0, 1)));
		lerpRating = FlxMath.lerp(lerpRating, intendedRating, CoolUtil.boundTo(elapsed * 12, 0, 1));
		if (Math.abs(lerpScore - intendedScore) <= 10) lerpScore = intendedScore;
		if (Math.abs(lerpRating - intendedRating) <= 0.01) lerpRating = intendedRating;

		scoreText.text = "Score: " + lerpScore;
		ratingText.text = "Rating: " + Math.floor(lerpRating * 100);
		positionHighscore();

		var upP = controls.UI_UP_P;
		var downP = controls.UI_DOWN_P;
		var accepted = controls.ACCEPT;
		var space = FlxG.keys.justPressed.SPACE;
		var ctrl = FlxG.keys.justPressed.CONTROL;

		var shiftMult:Int = 1;
		if(FlxG.keys.pressed.SHIFT) shiftMult = 3;

		if(songs.length > 1) {
			holdTime = 0;
			if (upP) changeSelection(-shiftMult);
			if (downP) changeSelection(shiftMult);
	
			if(controls.UI_DOWN || controls.UI_UP) {
				var checkLastHold:Int = Math.floor((holdTime - 0.5) * 10);
				holdTime += elapsed;
				var checkNewHold:Int = Math.floor((holdTime - 0.5) * 10);
	
				if(holdTime > 0.5 && checkNewHold - checkLastHold > 0) changeSelection((checkNewHold - checkLastHold) * (controls.UI_UP ? -shiftMult : shiftMult));
			}
		}

		if (CustomFadeTransition.canControl) {
			if (controls.BACK) {
				if(FlxG.save.data.beatenStory) {
					MusicBeatState.switchState(new FreeplaySelectState());
				} else MusicBeatState.switchState(new TitleState());
				FlxG.sound.play(Paths.sound('cancelMenu'));
			}
	
			if (accepted) {
				persistentUpdate = false;
				var songLowercase:String = Paths.formatToSongPath(songs[curSelected].songName);
				var poop:String = Highscore.formatSong(songLowercase, 0);
	
				PlayState.SONG = Song.loadFromJson(poop, songLowercase);
				PlayState.isStoryMode = false;
				PlayState.storyDifficulty = 0;
				
				MusicBeatState.switchState(new PlayState());
				FlxG.sound.music.volume = 0;
			} else if (controls.RESET) {
				persistentUpdate = false;
				openSubState(new ResetScoreSubState(songs[curSelected].songName, 0, songs[curSelected].songCharacter));
				FlxG.sound.play(Paths.sound('scrollMenu'));
			}
		}

		super.update(elapsed);
	}

	function changeSelection(change:Int = 0, playSound:Bool = true) {
		if(playSound) FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		curSelected += change;

		if (curSelected < 0) curSelected = songs.length - 1;
		if (curSelected >= songs.length) curSelected = 0;

		intendedScore = Highscore.getScore(songs[curSelected].songName, 0);
		intendedRating = Highscore.getRating(songs[curSelected].songName, 0);

		var bullShit:Int = 0;

		for (i in 0...iconArray.length) {
			iconArray[i].alpha = 0;
		}
		for (i in 0...lefticonArray.length) {
			lefticonArray[i].alpha = 1;
		}

		iconArray[curSelected].alpha = 1;
		lefticonArray[curSelected].alpha = 1;

		for (item in grpSongs.members) {
			item.targetY = bullShit - curSelected;
			bullShit++;
		}
		
		Paths.currentModDirectory = songs[curSelected].folder;
		PlayState.storyWeek = songs[curSelected].week;
		CoolUtil.difficulties = CoolUtil.defaultDifficulties.copy();
		
		curDifficulty = 0;
	}

	private function positionHighscore() {
		scoreText.x = FlxG.width - scoreText.width - 15;
		ratingText.x = FlxG.width - ratingText.width - 15;
	}
}

class SongMetadata {
	public var songName:String = "";
	public var week:Int = 0;
	public var songCharacter:String = "";
	public var folder:String = "";

	public function new(song:String, week:Int, songCharacter:String) {
		this.songName = song;
		this.week = week;
		this.songCharacter = songCharacter;
		this.folder = Paths.currentModDirectory;
		if(this.folder == null) this.folder = '';
	}
}