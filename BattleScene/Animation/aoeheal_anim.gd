extends Node2D

@onready var sprite = $aoeheal
@onready var anim_player = $aoeheal/aoehealAnimPlayer
@onready var mouse_pos: Vector2

func _ready():
	set_process_input(true)

func _input(event):
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		mouse_pos = get_viewport().get_mouse_position()
		_play_aoeheal_anim_as_pos(mouse_pos)

func _play_aoeheal_anim_as_pos(position: Vector2):
	sprite.global_position = Vector2(position.x + 30, position.y -30)
	anim_player.play("aoeheal_anim")
