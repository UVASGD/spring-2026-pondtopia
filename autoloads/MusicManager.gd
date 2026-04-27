extends Node2D

const SONG_ORDER = [
	"res://z_assets/music/Winding Frog Creek.mp3",
	"res://z_assets/music/Construction Frogs.mp3",
	"res://z_assets/music/Froggy Morning.mp3",
	"res://z_assets/music/Bustling Frog Town.mp3",
	"res://z_assets/music/Frog Volcano.mp3"
]
const SONG_LOSE = "res://z_assets/music/Sleeping Frogs.mp3"
const SONG_WIN = "res://z_assets/music/The Frogs Have Done It.mp3"

var cur_song_ind : int



func _ready() -> void:
	var rng = RandomNumberGenerator.new()
	cur_song_ind = rng.randi_range(0, SONG_ORDER.size() - 1)
	switch_song(SONG_ORDER[cur_song_ind])



func switch_song(path : String) -> void:
	$AudioStreamPlayer2D.stream = load(path)
	$AudioStreamPlayer2D.play()



func _on_audio_stream_player_2d_finished() -> void:
	cur_song_ind += 1
	if (cur_song_ind >= SONG_ORDER.size()):
		cur_song_ind = 0
	switch_song(SONG_ORDER[cur_song_ind])
