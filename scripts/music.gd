extends AudioStreamPlayer2D

var currently_playing = false

func _process(_delta):
	if Input.is_action_just_pressed("mute"):
		currently_playing = !currently_playing
		playing = currently_playing
	if Input.is_action_just_pressed("funny"):
		pitch_scale += 0.01
		if pitch_scale > 2:
			pitch_scale = 0.5
