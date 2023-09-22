extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$Button.size = Vector2(100,100)
	$HeroManagement.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_button_toggled(button_pressed):
	$HeroManagement.visible = button_pressed
