extends Node

### AUTOLOAD

### SignalBus ###
## Stores signals for easy access.

# Signals for shell scene buttons
signal quit_pressed
signal start_game_pressed(args : Array)
signal skip_to_win_pressed

func signal_test() : # this is just to make the warning messages go away. Never call this method.
	quit_pressed.emit()
	start_game_pressed.emit()
	skip_to_win_pressed.emit()
	
