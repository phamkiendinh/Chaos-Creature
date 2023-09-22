extends Button


# Called when the node enters the scene tree for the first time.
func _ready():
	self.position.x = get_viewport_rect().size.x / 2.25
	self.position.y = get_viewport_rect().size.y / 1.2
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
