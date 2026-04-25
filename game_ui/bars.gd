extends VBoxContainer

@onready var happy_bar: TextureProgressBar = $HappyBar
@onready var energy_bar: TextureProgressBar = $EnergyBar
@onready var happy: RichTextLabel = $HappyBar/Happy
@onready var energy: RichTextLabel = $EnergyBar/Energy

func _ready():
	BarsManager.happyUpdate.connect(updateHappyBar)
	BarsManager.energyUpdate.connect(updateEnergyBar)

func updateHappyBar(newhappy : int):
	happy_bar.value = newhappy
	happy.text = str(newhappy)

func updateEnergyBar(newenergy : int):
	energy_bar.value = newenergy
	energy.text = str(newenergy)
