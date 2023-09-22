extends Node2D
class_name EventNode

@onready var generic_node = preload("res://Levels/Events/GenericEventTemplate.tscn")

var node_status:bool = false
var node_arr = [generic_node]
var in_tutorial = false

func random_choice(list: Array):
	return list[ randi() % list.size() ]

func _ready():
	var node = random_choice(node_arr)
	var inst = generic_node.instantiate()
	self.add_child(inst)

func _process(delta):
	pass

func to_transitional_screen(is_tutorial:bool = false):
	if is_tutorial:
		var manager_node = get_node("/root/TutorialRound")
	var manager_node = get_node("/root/Manager")
	manager_node.to_map_screen()
	self.visible = false
