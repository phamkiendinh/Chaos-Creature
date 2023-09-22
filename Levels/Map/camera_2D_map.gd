extends Camera2D

var _target_zoom:float = 1.0
var disable_zoom:bool = false
const MAX_ZOOM:float = 0.5
const MIN_ZOOM:float = 0.1
const ZOOM_INCREMENT:float = 0.5
const ZOOM_RATE:float = 2.0
var is_tutorial_cam:bool = false

func _ready():
#	set_physics_process(false)
	self.zoom = Vector2(1, 1)
	pass
	
func _input(event):
	if event is InputEventMouseMotion:
		if event.button_mask == MOUSE_BUTTON_MASK_LEFT:
			position.x -= event.relative.x 
#			self.position.x = get_viewport().get_mouse_position().x
	if !disable_zoom:
		if event is InputEventMouseButton:
			if event.is_pressed():
				if event.button_index == MOUSE_BUTTON_WHEEL_UP:
					zoom_in()
				if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
					zoom_out()

func zoom_in() -> void:
	self.position = self.get_viewport().position / 1.25
	if self.zoom == Vector2(0.36, 0.36):
		self.zoom = Vector2(1, 1)

func zoom_out() -> void:
	self.zoom = Vector2(0.36, 0.36)

#func _physics_process(delta):
#	zoom = lerp(
#		zoom, 
#		_target_zoom * Vector2.ONE,
#		ZOOM_RATE * delta
#	)
#	set_physics_process(false)

