extends Node2D

@onready var view_port_size:Vector2 = Vector2(get_viewport_rect().size)

# Called when the node enters the scene tree for the first time.
func _ready():
	$Container.size.x = view_port_size.x * 0.3
	$Container.size.y = view_port_size.y * 0.1
	$Container.position.x += (view_port_size.x - $Container.size.x) / 2
	$Container.position.y += view_port_size.y * 0.1
	
	$Container/Text.size = $Container.size
	$Container/Text.position = $Container.position
	print($Container.position)
	print($Container/Text.position)
	print($Container/Text.size)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
