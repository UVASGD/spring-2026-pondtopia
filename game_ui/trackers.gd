extends VBoxContainer
@onready var day_counter: Label = $DayCounter
@onready var frog_counter: Label = $FrogCounter
@onready var fly_counter: Label = $FlyCounter

func _process(_delta: float) -> void:
	day_counter.text = "Day: %d" % GameInfo.day_num
	frog_counter.text = "🐸: %d/%d" % [GameInfo.num_frogs, GameInfo.frog_capacity]
	fly_counter.text = "🪰: %d" % GameInfo.num_flies
