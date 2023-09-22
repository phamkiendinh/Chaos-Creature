extends Sprite2D
var _target_zoom:float = 1.0

const MAX_ZOOM:float = 0.5
const MIN_ZOOM:float = 0.1
const ZOOM_INCREMENT:float = 0.5
const ZOOM_RATE:float = 2.0

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		if event.button_mask == MOUSE_BUTTON_MASK_LEFT:
			self.get_parent().position -= event.relative / self.get_parent().zoom
	pass


