extends Area2D
# Called when the node enters the scene tree for the first time.
@onready var slot_id:int = -1
func _ready():
	self.rotation = deg_to_rad(-90)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
