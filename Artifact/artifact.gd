extends TextureButton
@onready var artifact_database = preload("res://Artifact/artifact_database.gd")
@onready var json = artifact_database.new()

var artifact_name:String
var type:String
var description:String
var image_path

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
