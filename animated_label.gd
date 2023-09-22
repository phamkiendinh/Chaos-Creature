extends RichTextLabel

var based_time:float = 1.5
@onready var tween = create_tween()

func calc_tween_time():
	var text_length = self.text.length()
	var timing = text_length / 30.0 + based_time
	return timing

func _ready():
	var timing = calc_tween_time()
	self.visible_ratio = 0
	tween.tween_property(self, "visible_ratio", 1, timing)
	tween.set_trans(Tween.TRANS_CIRC)

func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == MOUSE_BUTTON_LEFT: 
				tween.tween_property(self, "visible_ratio", 1, 0.1)
