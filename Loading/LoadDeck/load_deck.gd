extends Node2D
@onready var view_port_size = get_viewport_rect().size
@onready var time:float = 0
@onready var loading_time:float = 3
# Called when the node enters the scene tree for the first time.
func _ready():

	$LeftLine.add_point(Vector2(1, view_port_size.y * 0.8))
	$LeftLine.add_point(Vector2(view_port_size.x * 0.4, view_port_size.y * 0.8))
	
	$RightLine.add_point(Vector2(view_port_size.x * 0.6, view_port_size.y * 0.8))
	$RightLine.add_point(Vector2(view_port_size.x, view_port_size.y * 0.8))
	
	$Text.position = Vector2(view_port_size.x * 0.405, view_port_size.y * 0.74)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if time <= 1:
		if time < 0.1:
			$Text.text = "Loading."
		elif time < 0.2:
			$Text.text = "Loading.."
		elif time < 0.3:
			$Text.text = "Loading..."
		elif time < 0.4:
			$Text.text = "Loading."
		elif time < 0.5:
			$Text.text = "Loading.."
		elif time < 0.6:
			$Text.text = "Loading..."
		elif time < 0.7:
			$Text.text = "Loading."
		elif time < 0.8:
			$Text.text = "Loading.."
		elif time < 0.9:
			$Text.text = "Loading..."
		time += delta / float(loading_time)
	else:
		get_tree().change_scene_to_file('res://Deck/deck_management.tscn')
