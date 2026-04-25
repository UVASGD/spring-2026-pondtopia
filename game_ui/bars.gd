extends VBoxContainer

@onready var happy_bar: TextureProgressBar = $HappyBar
@onready var energy_bar: TextureProgressBar = $EnergyBar

func _ready():
	BarsManager.happyUpdate.connect(updateHappyBar)
	BarsManager.energyUpdate.connect(updateEnergyBar)

func updateHappyBar(newhappy : int):
	happy_bar.value = newhappy

func updateEnergyBar(newenergy : int):
	energy_bar.value = newenergy
