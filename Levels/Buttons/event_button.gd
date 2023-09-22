extends Button


# Called when the node enters the scene tree for the first time.
func _ready():
	self.size.x = get_viewport_rect().size.x / 2
	self.size.y = get_viewport_rect().size.y / 4
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
