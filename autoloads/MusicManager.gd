extends Node2D



const SONG_MAIN_MENU = "res://z_assets/music/Bustling Frog Town.mp3"
const SONG_DAY_1 = "res://z_assets/music/Winding Frog Creek.mp3"
const SONG_DAY_2 = "res://z_assets/music/Construction Frogs.mp3"
const SONG_DAY_3 = "res://z_assets/music/Froggy Morning.mp3"
const SONG_DAY_4 = "res://z_assets/music/Bustling Frog Town.mp3"
const SONG_DAY_5 = "res://z_assets/music/Temp.ogg"
const SONG_DAY_6 = "res://z_assets/music/Temp.ogg"
const SONG_DAY_7 = "res://z_assets/music/Frog Volcano.mp3"
const SONG_LOSE = "res://z_assets/music/Sleeping Frogs.mp3"
const SONG_WIN = "res://z_assets/music/The Frogs Have Done It.mp3"
const SONG_DAY_LIST = [
	SONG_DAY_1,
	SONG_DAY_2,
	SONG_DAY_3,
	SONG_DAY_4,
	SONG_DAY_5,
	SONG_DAY_6,
	SONG_DAY_7
]



func _ready() -> void:
	switch_song()



func switch_song() -> void:
	var path
	if(GameInfo.game_running):
		var weekday = (GameInfo.day_num - 1) % 7
		path = SONG_DAY_LIST[weekday]
	else:
		path = SONG_MAIN_MENU
	#	$AudioStreamPlayer2D.stop()
	play_song(path)



func play_song(path : String) -> void:
	$AudioStreamPlayer2D.stream = load(path)
	$AudioStreamPlayer2D.play()



#func _on_audio_stream_player_2d_finished() -> void:
#	cur_song_ind += 1
#	if (cur_song_ind >= SONG_DAY_LIST.size()):
#		cur_song_ind = 0
#	switch_song(SONG_DAY_LIST[cur_song_ind])
